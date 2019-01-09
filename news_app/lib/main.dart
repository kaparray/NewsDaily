import 'package:flutter/material.dart';
import 'package:news_app/ui/choose_interesting.dart';
import 'package:news_app/blocs/interesting_bloc.dart';
import 'resources/db_helper.dart';

void main() {
  if (DBHelper.get().db == null)
    blocInteresting.getInteresting();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChoosInteresting(),
      theme: ThemeData.dark(),
    );
  }
}
