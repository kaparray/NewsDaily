import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';

class AllNews extends StatelessWidget {
  int index;
  Articles model;

  AllNews(int i, Articles m) {
    this.index = i;
    this.model = m;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('US NEWS'),
        ),
        body: Column(
          children: <Widget>[
             Hero(
              tag: 'newsHero ${index}',
              child: Image.network(model.urlToImage)
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Text(model.title, style: TextStyle(fontSize: 18))
            ),


            Padding(
              padding: EdgeInsets.all(10),
              child: Text(model.content,  style: TextStyle(fontSize: 14),),
            ),

          ],
        )
        );
  }
}
