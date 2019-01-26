import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class SettingsScreen extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {
  bool switchTheme = false;

  @override
  Widget build(BuildContext context) {
    initTheme();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
              title: Text('News languege'),
              subtitle: Text(''),
              onTap: () => showPickerArray(context),
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
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
    setState(() {
      switchTheme = value;
    });
  }

  initLang() async {
    final SharedPreferences prefs = await _prefs;
    //   prefs.getString();
  }

  showPickerArray(BuildContext context) async {
    Color textStyle = Theme.of(context).brightness == Brightness.dark ? Colors.white: Colors.grey[800];
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white;


    final SharedPreferences prefs = await _prefs;
    Picker(
      textStyle: TextStyle(color: textStyle, fontSize: 24),
        backgroundColor: backgroundColor,
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(PickerLang), isArray: true),
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          prefs.setString('lang', picker.getSelectedValues().toString());
        }).showDialog(context);
  }
}

const PickerLang = '''
[
    [
        "Russina",
        "English",
        "Spanian",
        "German"
    ]
]
    ''';
