import 'package:flutter/material.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


class SearchScreen extends StatefulWidget {
  String title;
  SearchScreen({this.title});

  @override
  createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _cuctomAppBar(),
            streamBuilderSearch(),
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
