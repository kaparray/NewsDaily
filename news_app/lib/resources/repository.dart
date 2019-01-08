import 'dart:async';
import 'news_api_provider.dart';
import '../models/news_model.dart';

class Repository {
  // Get news from sserver
  final newsApiProvider = NewsApiProvider();
  Future<NewsModel> fetchAllNews() => newsApiProvider.fetchNewsList();
}
