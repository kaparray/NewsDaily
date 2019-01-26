import 'package:flutter/material.dart';
import 'package:news_app/ui/bottom_nav_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

void main() async {
  await initApp();
  runApp(App());
}

initApp() async {
  final SharedPreferences prefs = await _prefs;
  List<String> _list = [];
  if (prefs.getBool('firtStart') == null) {
    await prefs.setStringList('liked', _list);
    await prefs.setString('country', 'English');
    await prefs.setBool('firtStart', false);
  }
}

@immutable
class App extends StatefulWidget {
  @override
  createState() => AppState();
}

class AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BottomNavBar(),
            theme: theme,
            routes: {
              "/news": (_) => BottomNavBar(),
            },
          );
        });
  }
}
