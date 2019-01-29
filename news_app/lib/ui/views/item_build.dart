import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/screens/web_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

BuildContext _context;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

buildListSliver(NewsModel values, BuildContext context) {
  _context = context;
  if (values.articles.length == 0) {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Center(
          child: Text('You didn\'t like anything',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 24))),
    ));
  } else {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => _buildItem(values, index),
          childCount: values.articles.length),
    );
  }
}

_buildItem(NewsModel values, int index) {
  String url = values.articles[index].urlToImage;
  if (url == null)
    url = 'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';

  return Container(
    child: InkWell(
      onTap: () => logicWeb(values.articles[index]),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Theme.of(_context).accentColor,
                  Theme.of(_context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.grey
                ]),
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
                  _textItemBuild(_context, values.articles[index].title),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(_context).accentColor,
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

logicWeb(Articles values) async {
  String url = values.url;
  SharedPreferences prefs = await _prefs;
  if (!prefs.getBool('browser'))
    _openWebSite(values);
  else if (prefs.getBool('browser')) {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

_openWebSite(Articles model) {
  Navigator.push(_context,
      MaterialPageRoute(builder: (context) => WebViewScreen(model: model)));
}

_textItemBuild(BuildContext context, String text) {
  return Container(
    height: 120,
    width: MediaQuery.of(context).size.width * 0.8,
    padding: const EdgeInsets.all(10.0),
    child: Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
