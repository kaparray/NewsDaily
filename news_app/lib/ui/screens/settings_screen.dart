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
  bool switchTheme = false;
  String country = '';

  @override
  void initState() {
    scrollControllerSettings = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerSettings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTheme();
    initCountry();
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
              title: Text('Dark theme'),
              subtitle: Text('Enable dark theme throughout the app'),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeTheme(value),
                value: switchTheme,
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
              onTap: () => changePrimaryColor(),
            ),
          ],
        ),
      ),
    );
  }

  initTheme() {
    setState(() {
      Theme.of(context).brightness == Brightness.dark
          ? switchTheme = true
          : switchTheme = false;
    });
  }

  changeTheme(value) {
    DynamicTheme.of(context).setThemeData(ThemeData(
        accentColor: Theme.of(context).accentColor,
        brightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark));
    setState(() {
      switchTheme = value;
    });
  }

  initCountry() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      country = prefs.getString('country');
    });
  }

  showPickerArray(BuildContext context) async {
    Color textStyle = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[800];
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.white;

    final SharedPreferences prefs = await _prefs;
    Picker(
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

  changePrimaryColor() {
    Color local;
    showDialog(
        context: context,
        child: SimpleDialog(
          title: Text('Primary color', style: TextStyle(fontSize: 24)),
          children: <Widget>[
            MaterialColorPicker(
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
                    onPressed: () {
                      DynamicTheme.of(context).setThemeData(ThemeData(
                          accentColor: local,
                          brightness: Theme.of(context).brightness));
                      Navigator.pop(context, false);
                    },
                    child: Text("Confirm"))
              ],
            ),
          ],
        ));
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
