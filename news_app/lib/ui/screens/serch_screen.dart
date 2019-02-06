import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
ScrollController scrollController;

class SearchScreen extends StatefulWidget {
  final String title;
  SearchScreen({this.title});

  @override
  createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        print("offset = ${scrollController.offset}");
        if (scrollController.offset > 1700) {
          // ToDo listener and get next page on newsapi.org
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchSearchNews();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            _cuctomAppBar(),
            streamBuilder(bloc.searchNews),
          ],
        ),
      ),
    );
  }

  _cuctomAppBar() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => goBack(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 48.0),
                child: Text(
                  "${widget.title}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  goBack() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("priorityTheme", null);
    Navigator.pop(context);
  }
}
