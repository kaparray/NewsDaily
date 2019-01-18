import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class WebView extends StatefulWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Articles model;

  WebView({this.model});

  @override
  WebViewState createState() => WebViewState();
}
class WebViewState extends State<WebView> {
  IconData icons = Icons.bookmark_border;
  List<String> _listLiked = [];
  SharedPreferences prefs;


  initSharedPref() async {
    prefs = await widget._prefs;
     _listLiked = prefs.getStringList("liked");
     if (_listLiked.indexOf(widget.model.url) >= 0) icons = Icons.bookmark;
  }

  @override
  Widget build(BuildContext context) {
     initSharedPref();

    return WebviewScaffold(
      withJavascript: false,
      url: widget.model.url,
      appBar: AppBar(
        title: Text('${widget.model.source.name}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(icons),
            onPressed: () async {
              if (icons == Icons.bookmark_border) {
                _listLiked.add("${widget.model.url}");
                await prefs.setStringList("liked", _listLiked);
                icons = Icons.bookmark;
              } else if (icons == Icons.bookmark) {
                num index = _listLiked.indexOf(widget.model.url);
                _listLiked.remove(index);
                await prefs.setStringList("liked", _listLiked);
                icons = Icons.bookmark_border;
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
