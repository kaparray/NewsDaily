import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/views/item_build.dart';
import 'package:news_app/ui/theme.dart';
import 'package:news_app/ui/views/states.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _host(Widget sliver, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: buildTheme(brightness, Colors.red),
      home: Scaffold(body: CustomScrollView(slivers: [sliver])),
    );

Articles _article({String url = 'https://example.com/a'}) => Articles(
  title: 'Flutter hits a new milestone',
  url: url,
  source: Source(id: 'ex', name: 'Example News'),
  publishedAt: DateTime.now()
      .subtract(const Duration(hours: 3))
      .toUtc()
      .toIso8601String(),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('stream builder shows a skeleton while waiting', (tester) async {
    final controller = StreamController<NewsModel>();
    addTearDown(controller.close);

    await tester.pumpWidget(_host(streamBuilder(controller.stream)));

    expect(find.byType(SkeletonList), findsOneWidget);
    expect(find.bySemanticsLabel('Loading news'), findsOneWidget);
  });

  testWidgets('stream builder shows an error message on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(streamBuilder(Stream<NewsModel>.error(Exception('boom')))),
    );
    await tester.pump();

    expect(find.text('Oops! Server error'), findsOneWidget);
    expect(find.byType(SkeletonList), findsNothing);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('error state offers a retry button', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _host(
        streamBuilder(
          Stream<NewsModel>.error(Exception('boom')),
          onRetry: () => retries++,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('empty list shows a generic empty message by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(streamBuilder(Stream.value(NewsModel(articles: [])))),
    );
    await tester.pump();

    expect(find.text('No news found'), findsOneWidget);
    expect(find.text("You didn't like anything"), findsNothing);
  });

  testWidgets('empty list shows a custom empty message', (tester) async {
    await tester.pumpWidget(
      _host(
        streamBuilder(
          Stream.value(NewsModel(articles: [])),
          emptyMessage: "You didn't like anything",
        ),
      ),
    );
    await tester.pump();

    expect(find.text("You didn't like anything"), findsOneWidget);
  });

  testWidgets('article card shows source, title, age and like state', (
    tester,
  ) async {
    final article = _article();
    SharedPreferences.setMockInitialValues({
      'liked': [article.url],
    });

    await tester.pumpWidget(
      _host(buildListSliver(NewsModel(articles: [article]), _FakeContext())),
    );
    await tester.pump();

    expect(find.byType(ListItemBuild), findsOneWidget);
    expect(find.byType(SourceChip), findsOneWidget);
    expect(find.text('Example News'), findsOneWidget);
    expect(find.text('Flutter hits a new milestone'), findsOneWidget);
    expect(find.text('3 hours ago'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });

  testWidgets('first story is a hero card, the rest are compact', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    addTearDown(tester.view.reset);
    final articles = [
      _article(url: 'https://example.com/1')
        ..urlToImage = 'https://example.com/broken.png'
        ..description = 'Lead paragraph',
      _article(url: 'https://example.com/2'),
    ];
    await tester.pumpWidget(
      _host(buildListSliver(NewsModel(articles: articles), _FakeContext())),
    );
    await tester.pump();

    final cards = tester
        .widgetList<ListItemBuild>(find.byType(ListItemBuild))
        .toList();
    expect(cards.map((c) => c.hero), [true, false]);
    expect(find.text('Lead paragraph'), findsOneWidget);
    // Loading and missing images show a placeholder icon.
    expect(find.byIcon(Icons.image_outlined), findsNWidgets(2));
  });

  testWidgets('like button toggles favorite state', (tester) async {
    await tester.pumpWidget(
      _host(buildListSliver(NewsModel(articles: [_article()]), _FakeContext())),
    );
    await tester.pump();
    expect(find.byTooltip('Add to favorites'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('liked'), ['https://example.com/a']);
  });

  testWidgets('action buttons meet the 48dp tap target guideline', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        buildListSliver(NewsModel(articles: [_article()]), _FakeContext()),
        brightness: Brightness.dark,
      ),
    );
    await tester.pump();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });

  testWidgets('cards survive large text scaling', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: _host(
          buildListSliver(
            NewsModel(
              articles: [
                _article(url: 'https://example.com/1'),
                _article(url: 'https://example.com/2'),
              ],
            ),
            _FakeContext(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme uses seeded color scheme in light and dark', (
    tester,
  ) async {
    for (final b in Brightness.values) {
      final theme = buildTheme(b, Colors.red);
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, b);
      expect(theme.appBarTheme.backgroundColor, theme.colorScheme.surface);
      expect(theme.appBarTheme.foregroundColor, theme.colorScheme.onSurface);
    }
  });
}

/// buildListSliver only needs a context for the empty state; a non-empty model
/// never touches it.
class _FakeContext extends Fake implements BuildContext {}
