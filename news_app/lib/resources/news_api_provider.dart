import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_model.dart';

class NewsApiProvider {
  Client client = Client();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _apiKey = '53ea041b1e1c4c659b41767532da63f2';

  // Chech shared preference, push requset to newsapi.org server and parse to model
  Future<NewsModel> fetchNewsList() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey";

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
}
