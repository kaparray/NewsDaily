import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/main.dart' show defaultSeedColor;
import 'package:news_app/ui/theme.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        const SliverAppBar.large(title: Text('Settings')),
        if (!_initialized)
          const SliverToBoxAdapter(child: LinearProgressIndicator())
        else
          SliverList.list(
            children: <Widget>[
              const _SectionHeader('Appearance'),
              _SettingsGroup(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Dark theme'),
                    subtitle: const Text('Easier on the eyes at night'),
                    value: isDark,
                    onChanged: changeTheme,
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Primary color'),
                    subtitle: const Text('Accent used across the app'),
                    trailing: Semantics(
                      label: 'Current color',
                      child: CircleAvatar(backgroundColor: _local, radius: 16),
                    ),
                    onTap: changePrimaryColor,
                  ),
                ],
              ),
              const _SectionHeader('Content'),
              _SettingsGroup(
                children: [
                  ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text('News country'),
                    subtitle: Text(country),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: showCountryPicker,
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.open_in_browser),
                    title: const Text('Open in browser'),
                    subtitle: const Text(
                      'Open stories in your default browser app',
                    ),
                    value: swBrowser,
                    onChanged: changeBrowser,
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),
            ],
          ),
      ],
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
        title: const Text('News country'),
        children: [
          for (final name in countryCodes.keys)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Insets.xl),
              title: Text(name),
              selected: name == country,
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
        title: const Text('Primary color'),
        contentPadding: const EdgeInsets.all(Insets.xl),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final c in primaryColorChoices)
                Semantics(
                  button: true,
                  selected: c.toARGB32() == _local.toARGB32(),
                  label: 'Color ${primaryColorChoices.indexOf(c) + 1}',
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context, c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      radius: 24,
                      child: c.toARGB32() == _local.toARGB32()
                          ? Icon(
                              Icons.check,
                              color:
                                  ThemeData.estimateBrightnessForColor(c) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            )
                          : null,
                    ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Insets.xl + Insets.sm,
        Insets.lg,
        Insets.xl,
        Insets.sm,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Card(
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 72),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
