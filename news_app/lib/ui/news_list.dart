import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/blocs/news_bloc.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllNews();
    return Scaffold(
      appBar: AppBar(
        title: Text('News in US'),
      ),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder(
          stream: bloc.allNews,
          builder: (context, AsyncSnapshot<NewsModel> snapshot) {
            if (snapshot.hasData) {
              return buidList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buidList(AsyncSnapshot<NewsModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.articles.length,
      itemBuilder: (context, index) =>
          buildItem(snapshot.data.articles[index], index, context),
    );
  }

  buildItem(Articles model, int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
      child: Hero(
        tag: 'newsHero $index',
        child: GestureDetector(
          onTap: () => openWebSite(context, model),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  textItemBuild(context, model.title),
                  imageItemBuild(context, model),
                ],
              )),
        ),
      ),
    );
  }

  openWebSite(BuildContext context, Articles model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new WebviewScaffold(
                  url: model.url,
                )));
  }

  textItemBuild(BuildContext context, String text) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  imageItemBuild(BuildContext context, Articles model) {
    String url =
        'https://cdn-images-1.medium.com/max/1600/1*U8_90Kf74Oc0xRF8iOV6jw.png';
    if (model.urlToImage != null) url = model.urlToImage;
    return Container(
        padding: EdgeInsets.all(4),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image:
                DecorationImage(fit: BoxFit.cover, image: NetworkImage(url))));
  }
}
