import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/screens/web_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

buildListSliver(NewsModel values, BuildContext context) {
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
          (context, index) => ListItemBuild(values.articles[index]),
          childCount: values.articles.length),
    );
  }
}

class ListItemBuild extends StatefulWidget {
  final Articles model;
  ListItemBuild(this.model);

  createState() => ListItemState();
}

class ListItemState extends State<ListItemBuild> with TickerProviderStateMixin {
  Animation colorAnimation;
  AnimationController colorAnimationController;

  initState() {
    colorAnimationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    colorAnimation =
        Tween(begin: 1.0, end: 0.5).animate(colorAnimationController);
    super.initState();
  }

  dispose() {
    colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, _) {
        return _buildItem(context);
      },
    );
  }

  Container _buildItem(context) {
    String url = widget.model.urlToImage;
    var image = Image.network(url).image;
    image
        .resolve(ImageConfiguration())
        .addListener((imageInfo, synchronousCall) {
      colorAnimationController.forward();
    });

    if (url == null)
      url = 'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';

    return Container(
      child: InkWell(
        onTap: () => logicWeb(widget.model, context),
        child: Card(
            color: Colors.black54,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black54.withOpacity(colorAnimation.value),
                          BlendMode.hardLight),
                      fit: BoxFit.cover,
                      image: image),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    _textItemBuild(context, widget.model.title),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        Share.share(widget.model.url);
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  logicWeb(Articles values, context) async {
    String url = values.url;
    SharedPreferences prefs = await _prefs;
    if (!prefs.getBool('browser'))
      _openWebSite(values, context);
    else if (prefs.getBool('browser')) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  _openWebSite(Articles model, context) {
    Navigator.push(context,
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
}
