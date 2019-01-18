import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class NewsApiProvider {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Client client = Client();
  final _apiKey = '53ea041b1e1c4c659b41767532da63f2';

  // Chech shared preference, push requset to newsapi.org server and parse to model
  Future<NewsModel> fetchNewsList() async {

    final SharedPreferences prefs = await _prefs;
    String priorityTheme = prefs.getString("priorityTheme");
    print(priorityTheme);
    String url = "https://newsapi.org/v2/top-headlines?q=$priorityTheme&country=us&apiKey=$_apiKey";
    if (priorityTheme == null) url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey";

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }
}
