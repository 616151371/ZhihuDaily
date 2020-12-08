import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zhihu_daily/entities/zhihu_news_entity.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zhihu_daily/utils/dace_util.dart';
import 'package:zhihu_daily/views/zhi_hu_swiper_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:date_format/date_format.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int DATE_TYPE = 1901;
  List<ZhihuNewsTopStory> _headerList = new List<ZhihuNewsTopStory>();
  List<ZhihuNewsStory> _newsList = new List<ZhihuNewsStory>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  DateTime today;
  DateTime beforeDay;

  @override
  void initState() {
    today = getNow();
    super.initState();
  }

  @override
  void setState(fn) {
    today = getNow();
    super.setState(fn);
  }

  DateTime getNow() {
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: AppBarLeading(
              today.day.toString(), DaceUtil.getChineseMonth(today.month)),
          centerTitle: false,
          title: Text(widget.title),
          actions: [
            IconButton(
                icon: CircleAvatar(
                    backgroundImage: AssetImage("images/account_avatar.png")),
                onPressed: () {
                })
          ],
        ),
        body: SmartRefresher(
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullUp: true,
            enablePullDown: true,
            controller: _refreshController,
            child: ListView.builder(
              itemCount: _newsList.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _getHeader();
                }
                return _getItem(index - 1);
              },
            )));
  }

  void _onRefresh() {
    queryData();
  }

  void _onLoading() {
    queryBeforeData();
  }

  Widget _getHeader() {
    if (_headerList.isEmpty) {
      return null;
    }
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.width,
        child: Swiper(
            autoplay: true,
            itemCount: _headerList.length,
            itemHeight: MediaQuery.of(context).size.width,
            pagination: ZhiHuSwiperPagination(),
            itemBuilder: (context, index) {
              return _getSwiperItem(index);
            }));
  }

  Widget _getSwiperItem(int index) {
    ZhihuNewsTopStory story = _headerList[index];
    String colorStr = story.imageHue;
    String endColorStr = colorStr;
    String startColorStr = "0xff" + colorStr.substring(2);
    Color endColor = Color(int.parse(endColorStr));
    Color startColor = Color(int.parse(startColorStr));
    return Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Image.network(story.image),
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [startColor, endColor],
                        stops: [0.6, 1.0])),
              )),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(story.title,
                        maxLines: null,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: Colors.white))),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(story.hint,
                        style: TextStyle(color: Colors.white60)))
              ])
        ]);
  }

  Widget _getItem(int index) {
    if (index > _newsList.length - 1) {
      return null;
    }
    ZhihuNewsStory story = _newsList[index];
    if (story.type == DATE_TYPE) {
      return Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Row(children: [
            Text(
              story.title,
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
                child: Divider(indent: 10, height: 2, color: Colors.grey[500]))
          ]));
    }
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width / 5.0 + 30,
      padding: EdgeInsets.all(10.0),
      child: Row(children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(story.title,
                    style: TextStyle(color: Colors.black, fontSize: 16))),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                story.hint,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            )
          ],
        )),
        Image.network(
          story.images[0],
          width: size.width / 5.0,
          height: size.width / 5.0,
        )
      ]),
    );
  }

  void queryData() async {
    try {
      Response response =
          await Dio().get("http://news-at.zhihu.com/api/4/news/latest");
      if (response.statusCode == 200) {
        ZhihuNewsEntity newsEntity =
            new ZhihuNewsEntity().fromJson(json.decode(response.toString()));
        setState(() {
          beforeDay = today;
          _newsList.clear();
          _headerList.clear();
          _newsList.addAll(newsEntity.stories);
          _headerList.addAll(newsEntity.topStories);
        });
      } else {
        Toast.show(response.statusMessage, context);
      }
      _refreshController.refreshCompleted();
    } catch (e) {
      print(e);
      Toast.show("网络错误", context);
      _refreshController.refreshFailed();
    }
  }

  void queryBeforeData() async {
    try {
      var url = "http://news-at.zhihu.com/api/4/news/before/" +
          formatDate(beforeDay, [yyyy, mm, dd]);
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        ZhihuNewsEntity newsEntity =
            new ZhihuNewsEntity().fromJson(json.decode(response.toString()));
        if (newsEntity == null ||
            newsEntity.stories == null ||
            newsEntity.stories.length == 0) {
          _refreshController.loadNoData();
          return;
        }
        setState(() {
          beforeDay = beforeDay.subtract(Duration(days: 1));
          ZhihuNewsStory dateTypeStory = ZhihuNewsStory();
          dateTypeStory.type = DATE_TYPE;
          dateTypeStory.title = formatDate(beforeDay, [mm, ' 月 ', d, ' 日']);
          _newsList.add(dateTypeStory);
          _newsList.addAll(newsEntity.stories);
        });
        _refreshController.loadComplete();
      } else {
        Toast.show(response.statusMessage, context);
        _refreshController.loadFailed();
      }
    } catch (e) {
      print(e);
      Toast.show("网络错误", context);
      _refreshController.loadFailed();
    }
  }
}

class AppBarLeading extends StatelessWidget {
  final String month;
  final String day;

  AppBarLeading(this.day, this.month);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 44,
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold),
                ),
                Text(month),
              ],
            )),
            VerticalDivider(
              indent: 10,
              endIndent: 10,
              color: Colors.grey[850],
              width: 1,
            )
          ],
        ));
  }
}
