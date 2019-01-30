import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/news_model.dart';

class NewsBloc {
  final _repository = Repository();
  final _newsFetcher = PublishSubject<NewsModel>();
  final _newsSearchFetcher = PublishSubject<NewsModel>();
  final _newsLikeFetcher = PublishSubject<NewsModel>();

  Observable<NewsModel> get allNews => _newsFetcher.stream;
  Observable<NewsModel> get searchNews => _newsSearchFetcher.stream;
  Observable<NewsModel> get likeNews => _newsLikeFetcher.stream;

  fetchLikedNews() async {
    NewsModel newsModel = await _repository.fetchLikedNews();
    _newsLikeFetcher.sink.add(newsModel);
  }

  fetchAllNews() async {
    NewsModel newsModel = await _repository.fetchAllNews();
    _newsFetcher.sink.add(newsModel);
  }

  fetchSearchNews() async {
    NewsModel newsModel = await _repository.fetchSearchNews();
    _newsSearchFetcher.sink.add(newsModel);
  }

  // Set and dellite from Firestore liked
  addFavorit(val) async => _repository.addFavorit(val);
  deliteFavorit(val) async => _repository.deliteFavorit(val);

  dispose() {
    _newsLikeFetcher.close();
    _newsFetcher.close();
    _newsSearchFetcher.close();
  }
}

final bloc = NewsBloc();
