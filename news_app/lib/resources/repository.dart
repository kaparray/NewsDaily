import 'dart:async';

import '../models/news_model.dart';
import 'news_api_provider.dart';

class Repository {
  Repository({NewsApiProvider? provider})
    : newsApiProvider = provider ?? NewsApiProvider();

  final NewsApiProvider newsApiProvider;

  /// Get top headlines from the server.
  Future<NewsModel> fetchAllNews() => newsApiProvider.fetchNewsList();

  /// Search news on the server.
  Future<NewsModel> fetchSearchNews() => newsApiProvider.fetchSearchNews();

  /// Get favorite news from Firestore.
  Future<NewsModel> fetchLikedNews() => newsApiProvider.getFavoriteNews();

  Future<void> addFavorite(Map<String, dynamic> val) =>
      newsApiProvider.addToFirestore(val);

  Future<void> deleteFavorite(Map<String, dynamic> val) =>
      newsApiProvider.deleteFromFirestore(val);
}
