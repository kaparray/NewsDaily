import 'package:material_ui/material_ui.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/views/stream_builder.dart';

ScrollController? scrollControllerLikedList;

class LikedList extends StatefulWidget {
  const LikedList({super.key});

  @override
  State<LikedList> createState() => LikedListState();
}

class LikedListState extends State<LikedList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollControllerLikedList = _controller;
    bloc.fetchLikedNews();
  }

  @override
  void dispose() {
    if (scrollControllerLikedList == _controller) {
      scrollControllerLikedList = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: bloc.fetchLikedNews,
      edgeOffset: 152,
      child: CustomScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          const SliverAppBar.large(title: Text('Favorites')),
          streamBuilder(
            bloc.likeNews,
            emptyMessage: "You didn't like anything",
            emptyHint: 'Tap the heart on a story to save it here.',
            emptyIcon: Icons.favorite_border,
            onRetry: bloc.fetchLikedNews,
          ),
        ],
      ),
    );
  }
}
