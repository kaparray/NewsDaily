import 'package:flutter/material.dart';
import 'package:news_app/ui/views/item_build.dart';

streamBuilder(val) {
  return StreamBuilder(
    stream: val,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildListSliver(snapshot.data, context);
      } else if (snapshot.hashCode.toString() == 'apiKeyMissing') {
        return SliverToBoxAdapter(
          child: Center(
            child: Text('Oppps! Error server'),
          ),
        );
      } else {
        return SliverToBoxAdapter(
            child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            ),
          ),
        ));
      }
    },
  );
}
