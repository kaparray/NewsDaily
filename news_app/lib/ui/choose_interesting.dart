import 'package:flutter/material.dart';

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
  final List<_ListItem> _items = <String>[
    'Sport', 'Media', 'Politic', 'Other'
    ].map<_ListItem>((String item) => _ListItem(item, false)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose interesting theme'),
      ),
      body: SafeArea(
        bottom: false,
        child: buildList(),
      ),
    );
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
        setState((){
          item.checkState = value;
        });
      },
    );
  }

}

