import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/news_model.dart';
import '../utils/news_utils.dart';

class NewsApiProvider {
  NewsApiProvider({http.Client? client, FirebaseFirestore? firestore})
    : client = client ?? http.Client(),
      _firestore = firestore;

  final http.Client client;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

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

  Future<NewsModel> getFavoriteNews() async {
    final doc = await firestore.collection('users').doc(await getMyUID()).get();
    final data = doc.data();
    final list = <Articles>[
      if (data != null)
        for (final value in data.values)
          if (value is Map) Articles.fromJson(value),
    ];
    return NewsModel(articles: list);
  }

  Future<String> getMyUID() async {
    final prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('id');
    if (uid == null) {
      uid = const Uuid().v4();
      await prefs.setString('id', uid);
    }
    return uid;
  }

  Future<void> addToFirestore(Map<String, dynamic> val) async {
    final key = firestoreKeyForUrl(val['url'].toString());
    await firestore.collection('users').doc(await getMyUID()).set({
      key: val,
    }, SetOptions(merge: true));
  }

  Future<void> deleteFromFirestore(Map<String, dynamic> val) async {
    final key = firestoreKeyForUrl(val['url'].toString());
    await firestore.collection('users').doc(await getMyUID()).update({
      key: FieldValue.delete(),
    });
  }
}
