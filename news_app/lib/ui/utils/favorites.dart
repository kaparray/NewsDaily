import 'package:news_app/blocs/news_bloc.dart';
import 'package:news_app/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local cache of liked article URLs backed by shared preferences, with the full
/// article data saved locally through the bloc.
class Favorites {
  static const _key = 'liked';

  static Future<bool> isLiked(String url) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const []).contains(url);
  }

  /// Toggles the liked state of [article] and returns the new state.
  static Future<bool> toggle(Articles article) async {
    final prefs = await SharedPreferences.getInstance();
    final liked = List<String>.of(prefs.getStringList(_key) ?? const []);
    final nowLiked = !liked.contains(article.url);
    if (nowLiked) {
      liked.add(article.url);
    } else {
      liked.remove(article.url);
    }
    await prefs.setStringList(_key, liked);
    if (nowLiked) {
      await bloc.addFavorite(article.toFavoriteJson());
    } else {
      await bloc.deleteFavorite(article.toFavoriteJson());
    }
    return nowLiked;
  }
}
