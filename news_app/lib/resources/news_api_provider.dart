import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NewsApiProvider {
  Client client = Client();
  final _prefs = SharedPreferences.getInstance();

  String cntry = 'us';

  final _apiKey = '53ea041b1e1c4c659b41767532da63f2';

  // Chech shared preference, push requset to newsapi.org server and parse to model
  Future<NewsModel> fetchNewsList() async {
    final SharedPreferences pref = await _prefs;
    String country = pref.getString('country');

    if (country == 'Russia')
      cntry = 'ru';
    else if (country == 'US')
      cntry = 'us';
    else if (country == 'Germany')
      cntry = 'de';
    else if (country == 'United Kingdom')
      cntry = 'gb';
    else if (country == 'France') cntry = 'fr';

    String url =
        "https://newsapi.org/v2/top-headlines?country=$cntry&apiKey=$_apiKey";

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }

  Future<NewsModel> fetchSearchNews() async {
    final SharedPreferences prefs = await _prefs;
    String priorityTheme = prefs.getString("priorityTheme");

    String url =
        "https://newsapi.org/v2/everything?q=$priorityTheme&apiKey=$_apiKey";

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }

  Future<NewsModel> getFavoriteNews() async {
    final NewsModel nm = NewsModel();
    List<Articles> list = List<Articles>();
    var articles = await Firestore.instance
        .collection("users")
        .document(await getMyUID())
        .get();
    if (articles.data != null) {
      for (int i = 0; i < articles.data.length; i++)
        list.add(Articles.fromJson(articles.data.values.toList()[i]));
    }
    nm.articles = list;
    return nm;
  }

  generateUID() async {
    final myUID = Uuid().v4();
    (await _prefs).setString('id', myUID);
  }

  getMyUID() async {
    String uid = (await _prefs).getString('id');
    return uid ?? generateUID();
  }

  addToFiresstore(val) async {
    final String key =
        val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('users')
        .document(await getMyUID())
        .setData({key: val}, merge: true);
  }

  deliteFromFirestore(val) async {
    final String key =
        val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('users')
        .document(await getMyUID())
        .updateData({key: FieldValue.delete()});
  }
}
