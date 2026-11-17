import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/news_model.dart';
import '../resources/repository.dart';

class NewsBloc {
  NewsBloc({Repository? repository}) : _repositoryOverride = repository;

  final Repository? _repositoryOverride;
  late final Repository _repository = _repositoryOverride ?? Repository();

  final _newsFetcher = PublishSubject<NewsModel>();
  final _newsSearchFetcher = PublishSubject<NewsModel>();
  final _newsLikeFetcher = PublishSubject<NewsModel>();

  Stream<NewsModel> get allNews => _newsFetcher.stream;
  Stream<NewsModel> get searchNews => _newsSearchFetcher.stream;
  Stream<NewsModel> get likeNews => _newsLikeFetcher.stream;

  Future<void> _load(
    Subject<NewsModel> subject,
    Future<NewsModel> Function() fetch,
  ) async {
    try {
      final model = await fetch();
      if (!subject.isClosed) subject.add(model);
    } catch (e, st) {
      debugPrint('NewsBloc: failed to load news: $e');
      if (!subject.isClosed) subject.addError(e, st);
    }
  }

  Future<void> fetchLikedNews() =>
      _load(_newsLikeFetcher, _repository.fetchLikedNews);

  Future<void> fetchAllNews() => _load(_newsFetcher, _repository.fetchAllNews);

  Future<void> fetchSearchNews() =>
      _load(_newsSearchFetcher, _repository.fetchSearchNews);

  Future<void> addFavorite(Map<String, dynamic> val) =>
      _repository.addFavorite(val);
  Future<void> deleteFavorite(Map<String, dynamic> val) =>
      _repository.deleteFavorite(val);

  void dispose() {
    _newsLikeFetcher.close();
    _newsFetcher.close();
    _newsSearchFetcher.close();
  }
}

final bloc = NewsBloc();
