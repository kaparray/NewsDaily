import 'package:flutter/material.dart';
import 'package:news_app/ui/choose_interesting.dart';
import 'package:news_app/blocs/interesting_bloc.dart';

void main() {
  bloc.getInteresting();
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
