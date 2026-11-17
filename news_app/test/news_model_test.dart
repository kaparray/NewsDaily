import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/news_model.dart';

void main() {
  const json = {
    'status': 'ok',
    'totalResults': 2,
    'articles': [
      {
        'source': {'id': 'bbc', 'name': 'BBC'},
        'author': 'Jane',
        'title': 'Title 1',
        'url': 'https://bbc.co.uk/1',
        'urlToImage': null,
        'publishedAt': '2024-01-01T10:00:00Z',
      },
      {'title': null, 'url': null},
    ],
  };

  test('parses a newsapi.org response', () {
    final model = NewsModel.fromJson(json);

    expect(model.status, 'ok');
    expect(model.totalResults, 2);
    expect(model.articles, hasLength(2));
    final first = model.articles.first;
    expect(first.source?.name, 'BBC');
    expect(first.author, 'Jane');
    expect(first.url, 'https://bbc.co.uk/1');
    expect(first.urlToImage, isNull);
  });

  test('missing fields get safe defaults', () {
    final model = NewsModel.fromJson({'status': 'error'});
    expect(model.articles, isEmpty);

    final article = NewsModel.fromJson(json).articles.last;
    expect(article.title, '');
    expect(article.url, '');
    expect(article.source, isNull);
  });

  test('toJson round-trips', () {
    final model = NewsModel.fromJson(json);
    final again = NewsModel.fromJson(model.toJson());
    expect(again.toJson(), model.toJson());
  });

  test('favorite json contains the fields saved for favorites', () {
    final article = NewsModel.fromJson(json).articles.first;
    expect(article.toFavoriteJson(), {
      'url': 'https://bbc.co.uk/1',
      'urlToImage': null,
      'title': 'Title 1',
      'author': 'Jane',
      'publishedAt': '2024-01-01T10:00:00Z',
      'source': {'id': 'bbc', 'name': 'BBC'},
    });
  });
}
