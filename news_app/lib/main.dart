import 'package:flutter/material.dart';
import 'package:news_app/ui/news_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsList(),
      theme: ThemeData.dark(),
    );
  }
}
