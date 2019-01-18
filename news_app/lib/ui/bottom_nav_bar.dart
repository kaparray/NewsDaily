import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/screens/news_list.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavBarState();
  }
}

class BottomNavBarState extends State<BottomNavBar> {
  num _currentItem = 0;
  final _listWidgets = [
    NewsList(),
    Center(
      child: Text('Comming soon...'),
    ),
    Center(
      child: Text('Comming soon...'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllNews();
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.chrome_reader_mode), title: Text('News')),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), title: Text('Favorit')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings'))
          ],
          currentIndex: _currentItem,
          fixedColor: Colors.cyan,
          onTap: _onItemTapped,
        ),
        body: _listWidgets[_currentItem]);
  }

  _onItemTapped(int index) {
    setState(() {
      _currentItem = index;
    });
  }
}
