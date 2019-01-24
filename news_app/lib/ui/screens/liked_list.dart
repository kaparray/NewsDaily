import 'package:news_app/ui/views/search_bar.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:flutter/material.dart';


ScrollController scrollControllerLikedList;

class LikedList extends StatefulWidget {
  @override
  createState() => LikedListState();
}

class LikedListState extends State<LikedList> {
  @override
  void initState() {
    scrollControllerLikedList = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerLikedList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollControllerLikedList,
          slivers: <Widget>[
            buildSearchBar(context, 'liked'),
            streamBuilderLiked()
          ],
        ),
      ),
    );
  }
}
