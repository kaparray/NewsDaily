import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/main.dart' show buildTheme, defaultSeedColor;
import 'package:news_app/utils/news_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

ScrollController? scrollControllerSettings;

/// Colors offered in the "Primary color" dialog.
const primaryColorChoices = <MaterialColor>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {
  final _controller = ScrollController(initialScrollOffset: 84);
  bool swBrowser = false;
  String country = '';
  Color _local = const Color(defaultSeedColor);
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    scrollControllerSettings = _controller;
    _loadPrefs();
  }

  @override
  void dispose() {
    if (scrollControllerSettings == _controller) {
      scrollControllerSettings = null;
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      country = prefs.getString('country') ?? 'US';
      swBrowser = prefs.getBool('browser') ?? false;
      _local = Color(prefs.getInt('color') ?? defaultSeedColor);
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const LinearProgressIndicator();
    final accent = Theme.of(context).colorScheme.secondary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: accent, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              alignment: Alignment.center,
              child: const Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              onTap: () => changeTheme(!isDark),
              title: const Text('Dark theme'),
              subtitle: const Text('Enable dark theme throughout the app'),
              trailing: Switch(
                activeThumbColor: accent,
                onChanged: changeTheme,
                value: isDark,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('News country'),
              subtitle: Text(country),
              onTap: showCountryPicker,
            ),
            const Divider(),
            ListTile(
              title: const Text('Primary color'),
              trailing: CircleAvatar(backgroundColor: _local, radius: 25),
              onTap: changePrimaryColor,
            ),
            const Divider(),
            ListTile(
              onTap: () => changeBrowser(!swBrowser),
              title: const Text('Open in browser'),
              subtitle: const Text('To work more efficiently'),
              trailing: Switch(
                value: swBrowser,
                activeThumbColor: accent,
                onChanged: changeBrowser,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> changeTheme(bool dark) async {
    final adaptive = AdaptiveTheme.of(context);
    if (dark) {
      adaptive.setDark();
    } else {
      adaptive.setLight();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', dark ? 'dark' : 'light');
  }

  Future<void> showCountryPicker() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Please Select'),
        children: [
          for (final name in countryCodes.keys)
            ListTile(
              title: Text(name),
              trailing: name == country ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, name),
            ),
        ],
      ),
    );
    if (selected == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', selected);
    if (mounted) setState(() => country = selected);
  }

  Future<void> changePrimaryColor() async {
    final adaptive = AdaptiveTheme.of(context);
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Primary color', style: TextStyle(fontSize: 24)),
        contentPadding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final c in primaryColorChoices)
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context, c),
                  child: CircleAvatar(
                    backgroundColor: c,
                    radius: 22,
                    child: c.toARGB32() == _local.toARGB32()
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
    if (picked == null) return;
    final seed = Color(picked.toARGB32());
    adaptive.setTheme(
      light: buildTheme(Brightness.light, seed),
      dark: buildTheme(Brightness.dark, seed),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color', seed.toARGB32());
    if (mounted) setState(() => _local = seed);
  }

  Future<void> changeBrowser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('browser', value);
    if (mounted) setState(() => swBrowser = value);
  }
}
