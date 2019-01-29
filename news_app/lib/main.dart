import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/bottom_nav_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

int color;
String theme;

void main() async {
  await initApp();
  runApp(App());
}

initApp() async {
  final SharedPreferences prefs = await _prefs;
  List<String> _list = [];
  if (prefs.getBool('firtStart') == null) {
    await prefs.setStringList('liked', _list);
    await prefs.setString('country', 'US');
    await prefs.setBool('firtStart', false);
    await prefs.setInt('color', 0xFF26A69A);
    await prefs.setString('theme', 'light');
    await prefs.setBool('browser', true);
  } else if (prefs.getBool('firtStart') == false) {
    color = prefs.getInt('color');
    theme = prefs.getString('theme');
  }
}

@immutable
class App extends StatefulWidget {
  @override
  createState() => AppState();
}

class AppState extends State<App> {
  Brightness _brightness;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (theme == 'dark')
      _brightness = Brightness.dark;
    else if (theme == 'light') _brightness = Brightness.light;

    return DynamicTheme(
        defaultBrightness: _brightness,
        data: (brightness) => ThemeData(
            brightness: _brightness, accentColor: Color(color ?? 0xFF26A69A)),
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
