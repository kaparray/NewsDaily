import 'package:flutter/material.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/web_view.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class NewsList extends StatefulWidget {
  @override
  createState() => NewsListState();
}


class NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          _buildSearchBar(), // Serach
          StreamBuilder(
            stream: bloc.allNews,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildList(snapshot.data);
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
          ),
        ],
      ),
    );
  }
_buildList(NewsModel values) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        String url = values.articles[index].urlToImage;
        if (url == null)
          url = 'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';

        return Container(
          child: InkWell(
            onTap: () => openWebSite(context, values.articles[index]),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black54.withOpacity(0.5),
                              BlendMode.hardLight),
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
                        textItemBuild(context, values.articles[index].title),
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
      }, childCount: values.articles.length),
    );
  }

  _buildSearchBar() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Card(
              color: Colors.transparent,
              elevation: 8,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.cyan,
                    child: TextField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black54),
                          hintText: 'Search'),
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.black54,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                      controller: TextEditingController(),
                      onSubmitted: (text) async {
                        final SharedPreferences prefs =
                            await _prefs; // Set into 'priorityTheme' data
                        await prefs.setString("priorityTheme", text);
                        setState(() {});
                      },
                    ),
                  )))
        ]),
      ),
    );
  }

  openWebSite(BuildContext context, Articles model) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebView(model: model)));
  }

  textItemBuild(BuildContext context, String text) {
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
}



