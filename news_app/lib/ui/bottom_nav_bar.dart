// @dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app/ui/screens/liked_list.dart';
import 'package:news_app/ui/screens/news_list.dart';
import 'package:news_app/ui/screens/settings_screen.dart';
import 'package:news_app/ui/utils/back_to_start.dart';

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
    LikedList(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.chrome_reader_mode), label: 'News'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorit',
                activeIcon: Icon(Icons.favorite)),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
          currentIndex: _currentItem,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onItemTapped,
        ),
        body: _listWidgets[_currentItem]);
  }

  _onItemTapped(int index) {
    setState(() {
      if (index == _currentItem && index == 0)
        backToStart(scrollControllerNewsList);
      if (index == _currentItem && index == 1)
        backToStart(scrollControllerLikedList);
      if (index == _currentItem && index == 2)
        backToStart(scrollControllerSettings);
      _currentItem = index;
    });
  }
}
