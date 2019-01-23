import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/views/item_build.dart';

streamBuilder() {
  return StreamBuilder(
    stream: bloc.allNews,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildList(snapshot.data);
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ),
          ),
        ));
      }
    },
  );
}

streamBuilderSearch() {
  return StreamBuilder(
    stream: bloc.searchNews,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildList(snapshot.data);
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ),
          ),
        ));
      }
    },
  );
}

  streamBuilderLiked() {
    return StreamBuilder(
      stream: bloc.searchNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot.data);
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            ),
          ));
        }
      },
    );
}
