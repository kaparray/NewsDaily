import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_model.dart';
import '../utils/news_utils.dart';

class NewsApiProvider {
  NewsApiProvider({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  /// Shared preferences key holding liked articles as JSON strings.
  static const favoritesKey = 'favorites';

  static const _apiKey = '53ea041b1e1c4c659b41767532da63f2';

  Future<NewsModel> _get(Uri uri) async {
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load news (${response.statusCode})');
  }

  /// Top headlines for the country stored in shared preferences.
  Future<NewsModel> fetchNewsList() async {
    final prefs = await SharedPreferences.getInstance();
    final code = countryCode(prefs.getString('country'));
    return _get(
      Uri.https('newsapi.org', '/v2/top-headlines', {
        'country': code,
        'apiKey': _apiKey,
      }),
    );
  }

  Future<NewsModel> fetchSearchNews() async {
    final prefs = await SharedPreferences.getInstance();
    final query = prefs.getString('priorityTheme') ?? '';
    return _get(
      Uri.https('newsapi.org', '/v2/everything', {
        'q': query,
        'apiKey': _apiKey,
      }),
    );
  }

  /// Favorites are stored locally on the device (SharedPreferences on
  /// Android, NSUserDefaults on iOS).
  Future<NewsModel> getFavoriteNews() async {
    final prefs = await SharedPreferences.getInstance();
    final list = <Articles>[
      for (final raw in prefs.getStringList(favoritesKey) ?? const <String>[])
        Articles.fromJson(json.decode(raw) as Map<String, dynamic>),
    ];
    return NewsModel(articles: list.reversed.toList());
  }

  Future<void> addFavorite(Map<String, dynamic> val) async {
    final prefs = await SharedPreferences.getInstance();
    final url = val['url'];
    final list = (prefs.getStringList(favoritesKey) ?? const <String>[])
        .where((raw) => (json.decode(raw) as Map)['url'] != url)
        .toList()
      ..add(json.encode(val));
    await prefs.setStringList(favoritesKey, list);
  }

  Future<void> deleteFavorite(Map<String, dynamic> val) async {
    final prefs = await SharedPreferences.getInstance();
    final url = val['url'];
    final list = (prefs.getStringList(favoritesKey) ?? const <String>[])
        .where((raw) => (json.decode(raw) as Map)['url'] != url)
        .toList();
    await prefs.setStringList(favoritesKey, list);
  }
}
