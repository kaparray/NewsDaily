import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/resources/news_api_provider.dart';
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
  // Animations
  Animation colorAnimation;
  AnimationController colorAnimationController;
  // List
  List<String> _listLiked = [];
  // Shared Preferences
  SharedPreferences prefs;
  // Icons
  IconData icons;
  // Height and len
  double height = 150;
  int maxline = 2;

  initSharedPref() async {
    prefs = await _prefs;
    _listLiked = prefs.getStringList("liked");
    if (_listLiked.indexOf(widget.model.url) >= 0)
      icons = Icons.favorite;
    else
      icons = Icons.favorite_border;
    setState(() {});
  }

  initHeight() {
    if (widget.model.title.length >= 90) {
      height += 10;
      maxline++;
    }
    if (widget.model.title.length >= 110) {
      height += 15;
      maxline++;
    }
  }

  initState() {
    initSharedPref();
    initHeight();
    colorAnimationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    colorAnimation =
        Tween(begin: 1.0, end: .5).animate(colorAnimationController);
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

  _buildItem(context) {
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
      height: height,
      child: InkWell(
        onTap: () => logicWeb(widget.model, context),
        child: Card(
            color: Colors.black54,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black54.withOpacity(colorAnimation.value),
                          BlendMode.hardLight),
                      fit: BoxFit.cover,
                      image: image),
                ),
                child: _columnWithContent(),
              ),
            )),
      ),
    );
  }

  _columnWithContent() {
    return Column(
      children: <Widget>[
        _headerItemBuild(),
        _textItemBuild(),
        _dateItemBuild(),
      ],
    );
  }

  _headerItemBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.model.source.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Share.share(widget.model.url);
                },
              ),
              IconButton(
                icon: Icon(
                  icons,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => _likeUiLogi(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _dateItemBuild() {
    // Parse date to normal format
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final unformedDate = format.parse(widget.model.publishedAt);
    Duration difference = unformedDate.difference(DateTime.now());

    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        (int.tryParse(difference.inHours.abs().toString()) < 12)
            ? difference.inHours.abs().toString() + " hours ago"
            : difference.inDays.abs().toString() + " days ago",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  _likeUiLogi() async {
    if (_listLiked.indexOf(widget.model.url) < 0) {
      icons = Icons.favorite;
      _listLiked.add("${widget.model.url}");
      await prefs.setStringList("liked", _listLiked);
      await NewsApiProvider().addToFiresstore({
        "url": widget.model.url,
        "urlToImage": widget.model.urlToImage,
        "title": widget.model.title,
        "author": widget.model.author,
        "publishedAt": widget.model.publishedAt,
        "source": widget.model.source.toJson()
      });
    } else if (_listLiked.indexOf(widget.model.url) >= 0) {
      icons = Icons.favorite_border;
      num index = _listLiked.indexOf(widget.model.url);
      _listLiked.removeAt(index);
      await prefs.setStringList("liked", _listLiked);
      await NewsApiProvider().deliteFromFirestore({
        "url": widget.model.url,
        "urlToImage": widget.model.urlToImage,
        "title": widget.model.title,
        "author": widget.model.author,
        "publishedAt": widget.model.publishedAt,
        "source": widget.model.source.toJson()
      });
    }
    setState(() {});
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

  _textItemBuild() {
    return Flexible(
      child: new Text(
        widget.model.title,
        maxLines: maxline,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      ),
    );
  }
}
