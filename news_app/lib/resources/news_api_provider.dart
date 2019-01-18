import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/news_model.dart';

class NewsApiProvider {
  Client client = Client();
  final _apiKey = '53ea041b1e1c4c659b41767532da63f2';

  Future<NewsModel> fetchNewsList() async {
    print("entered");
    final response = await client.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey");
    print(response.body);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }
}
