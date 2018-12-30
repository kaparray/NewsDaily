import 'package:flutter/material.dart';
import 'blocs/news_bloc.dart';
import 'models/news_model.dart';

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

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllNews();
    return Scaffold(
      appBar: AppBar(
        title: Text('News in US'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: bloc.allNews,
          builder: (context, AsyncSnapshot<NewsModel> snapshot) {
            if (snapshot.hasData) {
              return buidList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buidList(AsyncSnapshot<NewsModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.articles.length,
      itemBuilder: (context, index) => buildItem(snapshot, index),
    );
  }

  buildItem(AsyncSnapshot<NewsModel> snapshot, int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(snapshot.data.articles[index].title),
      ),
    );
  }

}
