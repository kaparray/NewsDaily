// @dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/bottom_nav_bar.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

int color;
String theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(App(savedThemeMode: savedThemeMode));
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
  final AdaptiveThemeMode? savedThemeMode;

  const App({Key key, this.savedThemeMode}) : super(key: key);

  @override
  createState() => AppState();
}

class AppState extends State<App> {

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = theme == 'dark' ? Brightness.dark : Brightness.light;
    final seedColor = Color(color ?? 0xFF26A69A);

    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: seedColor,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: seedColor,
      ),
      initial: widget.savedThemeMode ??
          (brightness == Brightness.dark
              ? AdaptiveThemeMode.dark
              : AdaptiveThemeMode.light),
      builder: (themeData, darkTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BottomNavBar(),
          theme: themeData,
          darkTheme: darkTheme,
          routes: {
            "/news": (_) => BottomNavBar(),
          },
        );
      },
    );
  }
}
