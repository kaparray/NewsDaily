import 'dart:async';

import 'news_api_provider.dart';
import '../models/news_model.dart';

class Repository {
  final newsApiProvider = NewsApiProvider();

  // Get news from server
  Future<NewsModel> fetchAllNews() => newsApiProvider.fetchNewsList();

  // Get news from server
  Future<NewsModel> fetchSearchNews() => newsApiProvider.fetchSearchNews();

  // Get favorite news from firebase
  Future<NewsModel> fetchLikedNews() => newsApiProvider.getFavoriteNews();

  addFavorit(val) => newsApiProvider.addToFiresstore(val);

  deliteFavorit(val) => newsApiProvider.deliteFromFirestore(val);
}
