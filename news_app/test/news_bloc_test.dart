import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/resources/repository.dart';

class FakeRepository extends Fake implements Repository {
  NewsModel headlines = NewsModel(articles: [Articles(title: 'Top')]);
  Object? error;
  final added = <Map<String, dynamic>>[];

  @override
  Future<NewsModel> fetchAllNews() async {
    if (error != null) throw error!;
    return headlines;
  }

  @override
  Future<NewsModel> fetchSearchNews() async =>
      NewsModel(articles: [Articles(title: 'Found')]);

  @override
  Future<NewsModel> fetchLikedNews() async => NewsModel();

  @override
  Future<void> addFavorite(Map<String, dynamic> val) async => added.add(val);
}

void main() {
  late FakeRepository repo;
  late NewsBloc bloc;

  setUp(() {
    repo = FakeRepository();
    bloc = NewsBloc(repository: repo);
  });

  tearDown(() => bloc.dispose());

  test('fetchAllNews emits headlines', () async {
    final next = bloc.allNews.first;
    await bloc.fetchAllNews();
    expect((await next).articles.single.title, 'Top');
  });

  test(
    'fetchSearchNews and fetchLikedNews emit on their own streams',
    () async {
      final search = bloc.searchNews.first;
      final liked = bloc.likeNews.first;
      await bloc.fetchSearchNews();
      await bloc.fetchLikedNews();
      expect((await search).articles.single.title, 'Found');
      expect((await liked).articles, isEmpty);
    },
  );

  test('repository errors are forwarded to the stream', () async {
    repo.error = Exception('offline');
    final next = bloc.allNews.first;
    await bloc.fetchAllNews();
    await expectLater(next, throwsException);
  });

  test('addFavorite delegates to the repository', () async {
    await bloc.addFavorite({'url': 'u'});
    expect(repo.added, [
      {'url': 'u'},
    ]);
  });

  test('fetching after dispose does not throw', () async {
    bloc.dispose();
    await bloc.fetchAllNews();
  });
}
