import 'package:flutter/material.dart';
import 'package:news_app/models/objet_db_helper.dart';
import 'package:news_app/ui/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


void main() {

  initApp();
  runApp(App());
}

initApp() async {
  List<String> _list = [];
  final SharedPreferences prefs = await _prefs;
  prefs.setStringList("liked", _list);

  ObjectDBHelper().createDB();
  //ObjectDBHelper().addDatr();
  //ObjectDBHelper().loadContactsFromDb();
}

@immutable
class App extends StatefulWidget {
  @override
  createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
      theme: ThemeData.dark(),
      routes: {
        "/news": (_) => BottomNavBar(),
      },
    );
  }

}
