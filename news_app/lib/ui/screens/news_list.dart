import 'package:material_ui/material_ui.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/views/search_bar.dart';
import 'package:news_app/ui/views/stream_builder.dart';

ScrollController? scrollControllerNewsList;

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final _controller = ScrollController(initialScrollOffset: 84);

  @override
  void initState() {
    super.initState();
    scrollControllerNewsList = _controller;
    bloc.fetchAllNews();
  }

  @override
  void dispose() {
    if (scrollControllerNewsList == _controller) {
      scrollControllerNewsList = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[buildSearchBar(context), streamBuilder(bloc.allNews)],
      ),
    );
  }
}
