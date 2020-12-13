import 'package:flutter/material.dart';
import 'package:zhihu_daily/pages/news_detail_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home_page",
      routes: {
        "home_page": (context) => HomePage(title: "知乎日报"),
        "news_detail_page": (context) => NewsDetailPage(),
      },
      title: 'ZhiHu Daily',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      )
    );
  }
}
