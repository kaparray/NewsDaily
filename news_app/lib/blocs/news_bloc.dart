import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/news_model.dart';

class NewsBloc {
  final _repository = Repository();
  final _newsFetcher = PublishSubject<NewsModel>();
  final _newsSearchFetcher = PublishSubject<NewsModel>();



  Observable<NewsModel> get allNews => _newsFetcher.stream;
  Observable<NewsModel> get searchNews =>  _newsSearchFetcher.stream;


  fetchAllNews() async {
    NewsModel newsModel = await _repository.fetchAllNews();
    _newsFetcher.sink.add(newsModel);
  }

  fetchSearchNews() async {
    NewsModel newsModel = await _repository.fetchSearchNews();
    _newsSearchFetcher.sink.add(newsModel);
  }

  dispose() {
    _newsFetcher.close();
    _newsSearchFetcher.close();
  }
}


final bloc = NewsBloc();
