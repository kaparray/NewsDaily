import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/utils/news_utils.dart';

void main() {
  test('countryCode maps settings names to newsapi codes', () {
    expect(countryCode('Russia'), 'ru');
    expect(countryCode('United Kingdom'), 'gb');
    expect(countryCode('Germany'), 'de');
    expect(countryCode('France'), 'fr');
    expect(countryCode('US'), 'us');
    expect(countryCode(null), 'us');
    expect(countryCode('Atlantis'), 'us');
  });

  test('firestoreKeyForUrl strips slashes and dots', () {
    expect(firestoreKeyForUrl('https://a.b/c.d'), 'https:abcd');
  });

  group('timeAgo', () {
    final now = DateTime.utc(2024, 1, 10, 12);

    test('uses hours below 12 hours', () {
      expect(timeAgo('2024-01-10T07:00:00Z', now: now), '5 hours ago');
    });

    test('uses days from 12 hours on', () {
      expect(timeAgo('2024-01-07T12:00:00Z', now: now), '3 days ago');
    });

    test('handles missing or invalid dates', () {
      expect(timeAgo(null, now: now), '');
      expect(timeAgo('not a date', now: now), '');
    });
  });
}
