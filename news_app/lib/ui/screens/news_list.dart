import 'package:flutter/material.dart';
import 'package:news_app/ui/views/search_bar.dart';
import 'package:news_app/ui/views/stream_builder.dart';

  ScrollController scrollController;


class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}

class NewsListState extends State<NewsList> {


  backToStart() async {
  if (scrollController.positions.isNotEmpty) {
    await scrollController.animateTo(0, curve: Curves.ease, duration: Duration(seconds: 2));
   }
}

  @override
  void initState() {
      scrollController = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
    void dispose() {
      scrollController.dispose();
      super.dispose();
    }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          buildSearchBar(context), // Serach
          streamBuilder(),
        ],
      ),
    );
  }
}
