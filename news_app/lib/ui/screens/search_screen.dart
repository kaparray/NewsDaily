import 'package:material_ui/material_ui.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final String title;
  const SearchScreen({super.key, required this.title});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.fetchSearchNews();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _clearQuery();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: bloc.fetchSearchNews,
          edgeOffset: 64,
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                leading: IconButton(
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              streamBuilder(
                bloc.searchNews,
                emptyMessage: 'No results',
                emptyHint: 'Try a different keyword.',
                emptyIcon: Icons.search_off,
                onRetry: bloc.fetchSearchNews,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearQuery() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('priorityTheme');
  }
}
