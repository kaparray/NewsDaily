import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/screens/web_view.dart';
import 'package:share/share.dart';

buildList(NewsModel values) {
  if (values.articles.length == 0) {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Center(child: Text('You didn\'t like anything', style: TextStyle(color: Colors.white, fontSize: 24))),
    ));
  } else {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => _buildItem(values, context, index),
          childCount: values.articles.length),
    );
  }
}

_buildItem(NewsModel values, BuildContext context, int index) {
  String url = values.articles[index].urlToImage;
  if (url == null)
    url = 'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';

  return Container(
    child: InkWell(
      onTap: () => _openWebSite(context, values.articles[index]),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black54.withOpacity(0.5), BlendMode.hardLight),
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      url,
                    )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  _textItemBuild(context, values.articles[index].title),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.cyan,
                    ),
                    onPressed: () {
                      Share.share(values.articles[index].url);
                    },
                  )
                ],
              ),
            ),
          )),
    ),
  );
}

_openWebSite(BuildContext context, Articles model) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => WebView(model: model)));
}

_textItemBuild(BuildContext context, String text) {
  return Container(
    height: 120,
    width: MediaQuery.of(context).size.width * 0.8,
    padding: const EdgeInsets.all(10.0),
    child: Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
