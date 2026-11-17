import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/bottom_nav_bar.dart';
import 'package:news_app/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultSeedColor = 0xFF26A69A;

int? color;
String? theme;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(App(savedThemeMode: savedThemeMode));
}

Future<void> initApp() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('firtStart') == null) {
    await prefs.setStringList('liked', <String>[]);
    await prefs.setString('country', 'US');
    await prefs.setBool('firtStart', false);
    await prefs.setInt('color', defaultSeedColor);
    await prefs.setString('theme', 'light');
    await prefs.setBool('browser', true);
  } else {
    color = prefs.getInt('color');
    theme = prefs.getString('theme');
  }
}

class App extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({super.key, this.savedThemeMode});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = Color(color ?? defaultSeedColor);

    return AdaptiveTheme(
      light: buildTheme(Brightness.light, seedColor),
      dark: buildTheme(Brightness.dark, seedColor),
      initial:
          widget.savedThemeMode ??
          (theme == 'dark' ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light),
      builder: (themeData, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Daily',
        home: const BottomNavBar(),
        theme: themeData,
        darkTheme: darkTheme,
        routes: {'/news': (_) => const BottomNavBar()},
      ),
    );
  }
}
