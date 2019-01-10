import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news_app/models/news_model.dart';


class WebView extends StatefulWidget {

  Articles model;

  WebView({this.model});

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.model.url,
      appBar: AppBar(
        title: Text('${widget.model.source.name}'),
      ),
    );
  }
}
