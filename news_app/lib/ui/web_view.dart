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
  IconData icons;
  List<String> _listLiked = [];
  SharedPreferences prefs;

  initSharedPref() async {
    prefs = await widget._prefs;
    _listLiked = prefs.getStringList("liked");
    if (_listLiked.indexOf(widget.model.url) >= 0)
      icons = Icons.favorite;
    else
      icons = Icons.favorite_border;
  }

  @override
  Widget build(BuildContext context) {
    initSharedPref(); // Get list from SharedProference
    return WebviewScaffold(
      withJavascript: false,
      url: widget.model.url,
      appBar: AppBar(
        title: Text('${widget.model.source.name}'),
        actions: <Widget>[
          IconButton(icon: Icon(icons), onPressed: () => _likeUiLogi()),
        ],
      ),
    );
  }

  _likeUiLogi() async {
    if (_listLiked.indexOf(widget.model.url) < 0) {
      icons = Icons.favorite;
      _listLiked.add("${widget.model.url}");
      await prefs.setStringList("liked", _listLiked);
    } else if (_listLiked.indexOf(widget.model.url) >= 0) {
      icons = Icons.favorite_border;
      num index = _listLiked.indexOf(widget.model.url);
      _listLiked.removeAt(index);
      await prefs.setStringList("liked", _listLiked);
    }
    setState(() {});
  }
}
