import 'package:news_app/blocs/news_bloc.dart';
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
    bloc.fetchLikedNews();
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControllerLikedList,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2),
                  borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(
                  bottom: 10, left: 10.0, right: 10.0, top: 10.0),
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              child: Text(
                'You favorite news',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          streamBuilder(bloc.likeNews),
        ],
      ),
    );
  }
}
