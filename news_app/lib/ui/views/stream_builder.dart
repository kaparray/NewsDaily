import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/views/item_build.dart';
import 'package:news_app/ui/views/states.dart';

Widget streamBuilder(
  Stream<NewsModel> stream, {
  String emptyMessage = 'No news found',
  String? emptyHint,
  IconData emptyIcon = Icons.newspaper_outlined,
  VoidCallback? onRetry,
}) {
  return StreamBuilder<NewsModel>(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildListSliver(
          snapshot.data!,
          context,
          emptyMessage: emptyMessage,
          emptyHint: emptyHint,
          emptyIcon: emptyIcon,
          onRetry: onRetry,
        );
      } else if (snapshot.hasError) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: MessageState(
              icon: Icons.cloud_off_outlined,
              title: 'Oops! Server error',
              message: 'Check your connection and try again.',
              onRetry: onRetry,
            ),
          ),
        );
      }
      return const SliverToBoxAdapter(child: SkeletonList());
    },
  );
}
