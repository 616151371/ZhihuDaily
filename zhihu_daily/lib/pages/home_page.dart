import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zhihu_daily/entities/zhihu_news_entity.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zhihu_daily/utils/dace_util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ZhihuNewsTopStory> _headerList = new List<ZhihuNewsTopStory>();
  List<ZhihuNewsStory> _newsList = new List<ZhihuNewsStory>();
  DateTime today;

  @override
  void initState() {
    today = getNow();
    queryData();
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
                  print(">>>>>> avatar pressed");
                })
          ],
        ),
        body: ListView.builder(
          itemCount: 50,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _getHeader();
            }
            return _getItem(index);
          },
        ));
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
            itemCount: _headerList.length,
            itemHeight: MediaQuery.of(context).size.width,
            pagination: new SwiperPagination(),
            control: new SwiperControl(),
            itemBuilder: (context, index) {
              ZhihuNewsTopStory story = _headerList[index];
              return Image.network(story.image);
            }));
  }

  Widget _getItem(int index) {
    if (index - 1 > _newsList.length - 1) {
      return null;
    }
    ZhihuNewsStory story = _newsList[index - 1];
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
            Text(story.title,
                style: TextStyle(color: Colors.black, fontSize: 16)),
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
        _newsList.addAll(newsEntity.stories);
        _headerList.addAll(newsEntity.topStories);
        setState(() {});
      }
    } catch (e) {
      print(e);
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
