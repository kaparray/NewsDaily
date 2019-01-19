import 'package:flutter/material.dart';
import 'package:news_app/ui/views/search_bar.dart';
import 'package:news_app/ui/views/stream_builder.dart';

class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          buildSearchBar(context, () {setState(() {});}), // Serach
          streamBuilder(),
        ],
      ),
    );
  }
}
