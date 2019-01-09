import 'package:flutter/material.dart';
import 'package:news_app/blocs/interesting_bloc.dart';
import 'package:news_app/models/add_news_to_interesting.dart';
import 'package:news_app/ui/news_list.dart';

class _ListItem {
  _ListItem(this.value, this.checkState);

  final String value;
  bool checkState;
}

class ChoosInteresting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChoosInterestingState();
  }
}

class ChoosInterestingState extends State<ChoosInteresting> {
  // ToDo add normal list with theme
  final List<_ListItem> _items = <String>['Sport', 'Media', 'Politic', 'Other']
      .map<_ListItem>((String item) => _ListItem(item, false))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 24,
            onPressed: saveToDB,
          )
        ],
        title: Text('Choose interesting theme'),
      ),
      body: SafeArea(
        bottom: false,
        child: buildList(),
      ),
    );
  }

  saveToDB() {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].checkState)
        blocInteresting.add(InterestingModel(
            id: s_id++,
            news_type: _items[i].value,
            blocked: _items[i].checkState));
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewsList()));
  }

  Scrollbar buildList() {
    return Scrollbar(
      child: ListView(
        children: _items.map<Widget>(buildListTitle).toList(),
      ),
    );
  }

  Widget buildListTitle(_ListItem item) {
    return CheckboxListTile(
      title: Text('${item.value}'),
      value: item.checkState,
      onChanged: (bool value) {
        setState(() {
          item.checkState = value;
        });
      },
    );
  }
}
