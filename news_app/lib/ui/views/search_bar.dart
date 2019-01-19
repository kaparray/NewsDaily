import 'package:flutter/material.dart';


buildSearchBar(BuildContext context) {
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
                      onSubmitted: (text) {
                        Navigator.of(context).pushNamed('/search');
                      },
                    ),
                  )))
        ]),
      ),
    );
  }
