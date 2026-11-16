import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/views/item_build.dart';

Widget streamBuilder(
  Stream<NewsModel> stream, {
  String emptyMessage = 'No news found',
}) {
  return StreamBuilder<NewsModel>(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildListSliver(
          snapshot.data!,
          context,
          emptyMessage: emptyMessage,
        );
      } else if (snapshot.hasError) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('Oops! Server error')),
          ),
        );
      }
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    },
  );
}
