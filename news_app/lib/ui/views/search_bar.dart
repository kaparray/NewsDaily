import 'package:flutter/material.dart';
import 'package:news_app/ui/screens/serch_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

buildSearchBar(BuildContext context, String type) {
  return SliverPadding(
    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
    sliver: SliverList(
      delegate: SliverChildListDelegate([
        Card(
            color: Colors.transparent,
            elevation: 8,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  color: Theme.of(context).accentColor,
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 18, color: Colors.black54),
                        hintText: 'Search'),
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.black54,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    controller: TextEditingController(),
                    onSubmitted: (text) => searchLogic(context, type, text),
                  ),
                )))
      ]),
    ),
  );
}

searchLogic(BuildContext context, String type, String text) {
  if (type == 'liked') {
    // ToDo
  } else if (type == 'search') {
    Navigator.popUntil(context, (route) {
      sarePref(text);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SearchScreen(
                title: text,
              )));
    });
  }
}

sarePref(text) async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString("priorityTheme", text);
}
