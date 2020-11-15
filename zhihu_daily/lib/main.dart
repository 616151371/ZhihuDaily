import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zhihu_daily/zhihu_news_entity.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZhiHu Daily',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '知乎日报'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ZhihuNewsTopStory> _headerList = new List<ZhihuNewsTopStory>();
  List<ZhihuNewsStory> _newsList = new List<ZhihuNewsStory>();

  @override
  void initState() {
    queryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
