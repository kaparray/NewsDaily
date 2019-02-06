import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/resources/news_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

@immutable
class WebViewScreen extends StatefulWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Articles model;

  WebViewScreen({this.model});

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewScreen> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initSharedPref();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('${widget.model.source.name}'),
        actions: <Widget>[
          IconButton(icon: Icon(icons), onPressed: () => _likeUiLogi()),
        ],
      ),
      body: WebView(
        initialUrl: widget.model.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  _likeUiLogi() async {
    if (_listLiked.indexOf(widget.model.url) < 0) {
      icons = Icons.favorite;
      _listLiked.add("${widget.model.url}");
      await prefs.setStringList("liked", _listLiked);
      await NewsApiProvider().addToFiresstore({
        "url": widget.model.url,
        "urlToImage": widget.model.urlToImage,
        "title": widget.model.title,
        "author": widget.model.author,
        "publishedAt": widget.model.publishedAt,
        "source": widget.model.source.toJson()
      });
    } else if (_listLiked.indexOf(widget.model.url) >= 0) {
      icons = Icons.favorite_border;
      num index = _listLiked.indexOf(widget.model.url);
      _listLiked.removeAt(index);
      await prefs.setStringList("liked", _listLiked);
      await NewsApiProvider().deliteFromFirestore({
        "url": widget.model.url,
        "urlToImage": widget.model.urlToImage,
        "title": widget.model.title,
        "author": widget.model.author,
        "publishedAt": widget.model.publishedAt,
        "source": widget.model.source.toJson()
      });
    }
    setState(() {});
  }
}
