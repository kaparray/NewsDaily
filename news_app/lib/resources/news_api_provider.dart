import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/news_model.dart';

class NewsApiProvider {
  Client client = Client();
  final _apiKey = '903abf18b5754ec5a7a3066f25442ec2';

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
