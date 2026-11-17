import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/resources/news_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('favorites are saved, listed and removed locally', () async {
    final provider = NewsApiProvider();
    expect((await provider.getFavoriteNews()).articles, isEmpty);

    await provider.addFavorite({'url': 'https://a', 'title': 'A'});
    await provider.addFavorite({'url': 'https://b', 'title': 'B'});
    await provider.addFavorite({'url': 'https://a', 'title': 'A'});

    var articles = (await provider.getFavoriteNews()).articles;
    expect(articles.map((a) => a.url), ['https://a', 'https://b']);

    await provider.deleteFavorite({'url': 'https://a'});
    articles = (await provider.getFavoriteNews()).articles;
    expect(articles.map((a) => a.title), ['B']);
  });
}
