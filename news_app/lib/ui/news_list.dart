import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/ui/web_view.dart';

TextEditingController _tec = TextEditingController();

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllNews();
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('News in US'),
            ),
          ),
          _buildSearchBar(), // Serach
          StreamBuilder(
            stream: bloc.allNews,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildList(snapshot.data.articles);
              } else {
                return SliverToBoxAdapter(
                    child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ));
              }
            },
          ),
        ],
      ),
    ));
  }
// ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(16.0)),



  _buildList(values) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {

        String url = values[index].urlToImage;

        if (url == null) url = 'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';
        return Container(
          child: InkWell(
            onTap: () => openWebSite(context, values[index]),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
 decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                                        Colors.black54.withOpacity(
                                          0.5),
                                        BlendMode.hardLight),
                    fit: BoxFit.cover, image: NetworkImage(url,)),
              ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    textItemBuild(context, values[index].title),
                  ],
                ),
                ),
                )),
          ),
        );
      }, childCount: values.length),
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
                      onEditingComplete: () {},
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
