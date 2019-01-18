import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news_app/models/news_model.dart';

@immutable
class WebView extends StatefulWidget {

  final Articles model;

  WebView({this.model});

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebView> {

  IconData icons = Icons.bookmark_border;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withJavascript: false,
      url: widget.model.url,
      appBar: AppBar(
        title: Text('${widget.model.source.name}'),
        actions: <Widget>[
           IconButton(
              icon: Icon(icons),
              onPressed: () {

                setState(() {
                  if (icons == Icons.bookmark_border) icons = Icons.bookmark;
                  else if (icons == Icons.bookmark) icons = Icons.bookmark_border;
                });
              },
            ),
        ],
      ),
    );
  }
}
