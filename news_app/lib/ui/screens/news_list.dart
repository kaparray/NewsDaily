import 'package:news_app/ui/views/search_bar.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:flutter/material.dart';

ScrollController scrollControllerNewsList;

class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  @override
  void initState() {
    scrollControllerNewsList = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerNewsList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControllerNewsList,
        slivers: <Widget>[
          buildSearchBar(context), // Serach
          streamBuilder(),
        ],
      ),
    );
  }
}
