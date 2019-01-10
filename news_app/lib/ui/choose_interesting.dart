import 'package:flutter/material.dart';
import 'package:news_app/blocs/interesting_bloc.dart';
import 'package:news_app/models/add_news_to_interesting.dart';

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

    String _validate;


class ChoosInterestingState extends State<ChoosInteresting> {
  // TextFaild controller in Alert
  TextEditingController teControl = TextEditingController();
  // ToDo add normal list with theme
  final List<_ListItem> _items = <String>['Sport', 'Media', 'Politic', 'Other']
      .map<_ListItem>((String item) => _ListItem(item, false))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab(),
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

  FloatingActionButton fab() {
    return FloatingActionButton(
        child: Icon(Icons.add), onPressed: () => logicAlert());
  }

  logicAlert() async {
    bool isError = false;

    await showDialog(
      context: context,
      child: AlertDialog(
          actions: <Widget>[
            FlatButton(
                child: const Text('ADD'),
                onPressed: () {
                  setState(() {
                    for (var copy in _items) {
                      if (copy.value == teControl.text) {
                        isError = true; // If in list this theme hav been createte output error
                      }
                    }
                    if (!isError) {
                      _items.add(_ListItem(teControl.text, true));
                      teControl.text = "";
                      Navigator.pop(context);
                    }
                  });
                }),
            FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  teControl.text = "";
                  Navigator.pop(context);
                }),
          ],
          title: Text('Enter interesting theme'),
          content: TextField(
            controller: teControl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Enter here',
              hintText: 'Pease',
              errorText: _validate,
            ),
          )),
    );
  }


  saveToDB() {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].checkState)
        blocInteresting.add(InterestingModel(
            id: sId++,
            newsType: _items[i].value,
            blocked: _items[i].checkState));
    }
    Navigator.pushReplacementNamed(context, "/news");
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
