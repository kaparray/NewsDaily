import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/news_model.dart';

class NewsBloc {
  final _repository = Repository();
  final _newsFetcher = PublishSubject<NewsModel>();

  Observable<NewsModel> get allNews => _newsFetcher.stream;

  fetchAllNews() async{
    NewsModel newsModel = await _repository.fetchAllNews();
    _newsFetcher.sink.add(newsModel);
  }

  dispose() {
    _newsFetcher.close();
  }
}


final bloc = NewsBloc();
