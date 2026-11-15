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
  final _controller = ScrollController(initialScrollOffset: 84);

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
    return SafeArea(
      child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              alignment: Alignment.center,
              child: const Text(
                'Your favorite news',
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
