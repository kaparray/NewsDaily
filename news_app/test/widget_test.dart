import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/views/item_build.dart';
import 'package:news_app/ui/views/stream_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _host(Widget sliver) => MaterialApp(
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

  testWidgets('stream builder shows a spinner while waiting', (tester) async {
    final controller = StreamController<NewsModel>();
    addTearDown(controller.close);

    await tester.pumpWidget(_host(streamBuilder(controller.stream)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('stream builder shows an error message on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(streamBuilder(Stream<NewsModel>.error(Exception('boom')))),
    );
    await tester.pump();

    expect(find.text('Oops! Server error'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
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
    expect(find.text('Example News'), findsOneWidget);
    expect(find.text('Flutter hits a new milestone'), findsOneWidget);
    expect(find.text('3 hours ago'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });
}

/// buildListSliver only needs a context for the empty state; a non-empty model
/// never touches it.
class _FakeContext extends Fake implements BuildContext {}
