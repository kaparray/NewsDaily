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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[_customAppBar(), streamBuilder(bloc.searchNews)],
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return SliverToBoxAdapter(
      child: Row(
        children: <Widget>[
          IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: goBack),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> goBack() async {
    final navigator = Navigator.of(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('priorityTheme');
    navigator.pop();
  }
}
