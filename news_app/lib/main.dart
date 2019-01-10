import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app/ui/choose_interesting.dart';
import 'package:news_app/blocs/interesting_bloc.dart';
import 'package:news_app/ui/news_list.dart';
import 'package:path_provider/path_provider.dart';

void main() {

  startLogic();
}


startLogic() async {
  Directory docDir = await getApplicationDocumentsDirectory();
  List listContent = docDir.listSync();
  for (var fileOrDir in listContent)
  {
    if (fileOrDir is File && fileOrDir.path.split('/').last == 'local.db')
    {
      runApp(App(false));
    }
  }
  blocInteresting.getInteresting();
  runApp(App(true));
}

class App extends StatefulWidget {

  bool _firstStart;

  App(this._firstStart);

  @override
  AppState createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: uiLogic(),
      theme: ThemeData.dark(),
      routes: {
        "/news": (_) => new NewsList(),
        "/choos_interesting": (_) => new NewsList()
      },
    );
  }

  Widget uiLogic() {
    if (widget._firstStart == true) return ChoosInteresting();
    else return NewsList();
  }
}
