/// Countries the user can pick in settings, mapped to newsapi.org codes.
const Map<String, String> countryCodes = {
  'Russia': 'ru',
  'US': 'us',
  'United Kingdom': 'gb',
  'Germany': 'de',
  'France': 'fr',
};

/// Returns the newsapi.org country code for [country], defaulting to `us`.
String countryCode(String? country) => countryCodes[country] ?? 'us';

/// Human readable age of an article, e.g. "3 hours ago" or "2 days ago".
String timeAgo(String? publishedAt, {DateTime? now}) {
  if (publishedAt == null) return '';
  final date = DateTime.tryParse(publishedAt);
  if (date == null) return '';
  final difference = (now ?? DateTime.now()).difference(date).abs();
  return difference.inHours < 12
      ? '${difference.inHours} hours ago'
      : '${difference.inDays} days ago';
}
