import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zhihu_daily/entities/zhihu_news_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  var _webviewLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var story = ModalRoute.of(context).settings.arguments;
    String webUrl = "";
    if (story is ZhihuNewsTopStory) {
      webUrl = story.url;
    } else if (story is ZhihuNewsStory) {
      webUrl = story.url;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              WebView(
                  onPageFinished: (url) {
                    setState(() {
                      _webviewLoaded = true;
                    });
                  },
                  navigationDelegate: (request) {
                    if (webUrl == request.url) {
                      return NavigationDecision.navigate;
                    }
                    if (request.url.startsWith("https") ||
                        request.url.startsWith("http")) {
                      launch(request.url,
                          forceSafariVC: false, forceWebView: false);
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  initialUrl: webUrl,
                  userAgent: "ZhihuHybrid"),
              _indicator()
            ],
          )),
          BottomNavigationWidget()
        ])));
  }

  Widget _indicator() {
    if (_webviewLoaded) {
      return Container();
    }
    return CircularProgressIndicator();
  }
}

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        width: double.infinity,
        height: 40 + bottomPadding,
        child: Row(children: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              }),
          VerticalDivider(
            color: Color(0xD2D3D4),
          ),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.chat_bubble_outline_rounded), onPressed: null),
          ),
          Expanded(
            child: IconButton(icon: Icon(CupertinoIcons.star), onPressed: null),
          ),
          Expanded(
            child: IconButton(icon: Icon(CupertinoIcons.star), onPressed: null),
          ),
          Expanded(
            child: IconButton(icon: Icon(Icons.ios_share), onPressed: null),
          ),
        ]));
  }
}
