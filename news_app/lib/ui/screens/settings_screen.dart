import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

ScrollController scrollControllerSettings;

class SettingsScreen extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {
  bool swBrowser = false;
  bool swTheme = false;
  String country = '';
  Color _local = Color(0x000);

  bool initData;

  @override
  void initState() {
    scrollControllerSettings = ScrollController(initialScrollOffset: 84);
    initStateCustome().then((_) {
      setState((){});
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerSettings.dispose();
    super.dispose();
  }

  // Init state logic
  Future initStateCustome() async {
    SharedPreferences prefs = await _prefs;
      country = prefs.getString('country');
      swBrowser = prefs.getBool('browser');
      _local = Color(prefs.getInt('color') ?? 0xFF26A69A);
      initData = true;
  }

  @override
  Widget build(BuildContext context) {
    if (initData == false || initData == null) {
      print(initData);
      return LinearProgressIndicator();
    }
    return SafeArea(
      child: SingleChildScrollView(
        controller: scrollControllerSettings,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2),
                  borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(
                  bottom: 10, left: 10.0, right: 10.0, top: 10.0),
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              child: Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              onTap: () => changeTheme(!swTheme),
              title: Text('Dark theme'),
              subtitle: Text('Enable dark theme throughout the app'),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeTheme(value),
                value: Theme.of(context).brightness == Brightness.dark
                    ? swTheme = true
                    : swTheme = false,
              ),
            ),
            Divider(), // Divider
            ListTile(
              title: Text('News country'),
              subtitle: Text(country),
              onTap: () => showPickerArray(context),
            ),
            Divider(), // Divider
            ListTile(
              title: Text('Primary color'),
              trailing: Container(
                child: CircleColor(
                  color: _local,
                  circleSize: 50,
                ),
              ),
              onTap: () => changePrimaryColor(),
            ),
            Divider(), // Divider
            ListTile(
              onTap: () => changeBrowser(!swBrowser),
              title: Text('Open in browser'),
              subtitle: Text('To work more efficiently'),
              trailing: Switch(
                value: swBrowser,
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeBrowser(value),
              ),
            ),
            Divider(), // Divider
          ],
        ),
      ),
    );
  }

  // Theme Logic
  changeTheme(value) async {
    SharedPreferences prefs = await _prefs;
    DynamicTheme.of(context).setThemeData(ThemeData(
        accentColor: Theme.of(context).accentColor,
        brightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark));
    setState(() {
      swTheme = value;
    });
    await prefs.setString('theme', swTheme ? 'dark' : 'light');
  }

  // Picer Logic
  showPickerArray(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    String country = prefs.getString('country');
    int selected = 0;
    Color textStyle = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[800];
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.white;

    if (country == 'Russia')
      selected = 0;
    else if (country == 'US')
      selected = 1;
    else if (country == 'United Kingdom')
      selected = 2;
    else if (country == 'Germany')
      selected = 3;
    else if (country == 'France') selected = 4;

    Picker(
        selecteds: [selected],
        textStyle: TextStyle(color: textStyle, fontSize: 24),
        backgroundColor: backgroundColor,
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(PickerCountry), isArray: true),
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          prefs.setString(
              'country',
              picker
                  .getSelectedValues()
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', ''));
        }).showDialog(context);
  }

  // Change Coloro L
  changePrimaryColor() async {
    SharedPreferences prefs = await _prefs;
    Color local = Color(prefs.getInt('color') ?? 0xFF26A69A);

    showDialog(
        context: context,
        child: SimpleDialog(
          title: Text('Primary color', style: TextStyle(fontSize: 24)),
          children: <Widget>[
            MaterialColorPicker(
                selectedColor: local,
                onColorChange: (Color color) {
                  local = color;
                },
                colors: [
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
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () async {
                      DynamicTheme.of(context).setThemeData(ThemeData(
                          accentColor: local,
                          brightness: Theme.of(context).brightness));
                      await prefs.setInt('color', local.value);
                      Navigator.pop(context, false);
                    },
                    child: Text("Confirm"))
              ],
            ),
          ],
        ));
  }

  changeBrowser(bool value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool('browser', value);
    setState(() {
      swBrowser = value;
    });
  }
}

const PickerCountry = '''
[
    [
        "Russia",
        "US",
        "United Kingdom",
        "Germany",
        "France"
    ]
]
    ''';
