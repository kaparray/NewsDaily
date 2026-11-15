import 'package:material_ui/material_ui.dart';
import 'package:news_app/ui/screens/liked_list.dart';
import 'package:news_app/ui/screens/news_list.dart';
import 'package:news_app/ui/screens/settings_screen.dart';
import 'package:news_app/ui/utils/back_to_start.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentItem = 0;
  static const _listWidgets = <Widget>[
    NewsList(),
    LikedList(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
            activeIcon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentItem,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
      body: _listWidgets[_currentItem],
    );
  }

  void _onItemTapped(int index) {
    if (index == _currentItem) {
      backToStart(switch (index) {
        0 => scrollControllerNewsList,
        1 => scrollControllerLikedList,
        _ => scrollControllerSettings,
      });
    }
    setState(() => _currentItem = index);
  }
}
