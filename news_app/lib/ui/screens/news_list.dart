import 'package:material_ui/material_ui.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/screens/search_screen.dart';
import 'package:news_app/ui/theme.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

ScrollController? scrollControllerNewsList;

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final _controller = ScrollController();

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
    return RefreshIndicator(
      onRefresh: bloc.fetchAllNews,
      edgeOffset: 136,
      child: CustomScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('News Daily'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.lg,
                  0,
                  Insets.lg,
                  Insets.lg,
                ),
                child: SearchBar(
                  hintText: 'Search news',
                  leading: const Icon(Icons.search),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) searchLogic(context, text);
                  },
                ),
              ),
            ),
          ),
          streamBuilder(bloc.allNews, onRetry: bloc.fetchAllNews),
        ],
      ),
    );
  }
}

Future<void> searchLogic(BuildContext context, String text) async {
  final navigator = Navigator.of(context);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('priorityTheme', text);
  navigator.popUntil((route) => route.isFirst);
  navigator.push(
    MaterialPageRoute<void>(builder: (_) => SearchScreen(title: text)),
  );
}
