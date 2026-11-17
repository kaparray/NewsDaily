import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/screens/web_view.dart';
import 'package:news_app/ui/theme.dart';
import 'package:news_app/ui/utils/favorites.dart';
import 'package:news_app/ui/views/states.dart';
import 'package:news_app/utils/news_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds the article list: the first story as a large hero card, the rest as
/// compact cards with a thumbnail.
Widget buildListSliver(
  NewsModel values,
  BuildContext context, {
  String emptyMessage = 'No news found',
  String? emptyHint,
  IconData emptyIcon = Icons.newspaper_outlined,
  VoidCallback? onRetry,
}) {
  if (values.articles.isEmpty) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: MessageState(
          icon: emptyIcon,
          title: emptyMessage,
          message: emptyHint,
          onRetry: onRetry,
        ),
      ),
    );
  }
  return SliverPadding(
    padding: const EdgeInsets.fromLTRB(
      Insets.lg,
      Insets.sm,
      Insets.lg,
      Insets.xl,
    ),
    sliver: SliverList.separated(
      itemCount: values.articles.length,
      separatorBuilder: (_, _) => const SizedBox(height: Insets.md),
      itemBuilder: (context, index) => ListItemBuild(
        values.articles[index],
        key: ValueKey(values.articles[index].url),
        hero: index == 0,
      ),
    ),
  );
}

/// Opens [article] in the external browser or the in-app web view, depending
/// on the "Open in browser" setting.
Future<void> openArticle(Articles article, BuildContext context) async {
  final navigator = Navigator.of(context);
  final prefs = await SharedPreferences.getInstance();
  final openInBrowser = prefs.getBool('browser') ?? false;
  if (openInBrowser) {
    final uri = Uri.parse(article.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${article.url}');
    }
  } else {
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => WebViewScreen(model: article)),
    );
  }
}

class ListItemBuild extends StatefulWidget {
  final Articles model;

  /// Whether to render the article as a large hero card.
  final bool hero;

  const ListItemBuild(this.model, {super.key, this.hero = false});

  @override
  State<ListItemBuild> createState() => ListItemState();
}

class ListItemState extends State<ListItemBuild> {
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _initLiked();
  }

  Future<void> _initLiked() async {
    final liked = await Favorites.isLiked(widget.model.url);
    if (mounted) setState(() => _liked = liked);
  }

  Future<void> _toggleLike() async {
    final liked = await Favorites.toggle(widget.model);
    if (mounted) setState(() => _liked = liked);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final theme = Theme.of(context);
    final age = timeAgo(model.publishedAt);
    final source = model.source?.name ?? '';

    final meta = Row(
      children: [
        if (source.isNotEmpty) Flexible(child: SourceChip(source)),
        if (source.isNotEmpty && age.isNotEmpty)
          const SizedBox(width: Insets.sm),
        if (age.isNotEmpty)
          Text(
            age,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Share',
          icon: const Icon(Icons.share),
          onPressed: () =>
              SharePlus.instance.share(ShareParams(text: model.url)),
        ),
        LikeButton(liked: _liked, onPressed: _toggleLike),
      ],
    );

    final Widget content;
    if (widget.hero) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ArticleImage(url: model.urlToImage),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              Insets.lg,
              Insets.lg,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                meta,
                const SizedBox(height: Insets.sm),
                Text(
                  model.title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
                if ((model.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: Insets.sm),
                  Text(
                    model.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Insets.xs),
            child: Align(alignment: Alignment.centerRight, child: actions),
          ),
        ],
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.fromLTRB(
          Insets.lg,
          Insets.lg,
          Insets.lg,
          Insets.xs,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      meta,
                      const SizedBox(height: Insets.sm),
                      Text(
                        model.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Insets.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.md),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: ArticleImage(url: model.urlToImage, iconSize: 32),
                  ),
                ),
              ],
            ),
            Align(alignment: Alignment.centerRight, child: actions),
          ],
        ),
      );
    }

    return Card(
      child: InkWell(onTap: () => openArticle(model, context), child: content),
    );
  }
}

/// Small pill showing the article source.
class SourceChip extends StatelessWidget {
  final String label;
  const SourceChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.sm,
        vertical: Insets.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: scheme.onSecondaryContainer),
      ),
    );
  }
}

/// Network image with a placeholder while loading and a fallback on error.
class ArticleImage extends StatelessWidget {
  final String? url;
  final double iconSize;
  const ArticleImage({super.key, this.url, this.iconSize = 48});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: iconSize,
          color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
    final src = url;
    if (src == null || src.isEmpty) return placeholder;
    return Image.network(
      src,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, wasSyncLoaded) {
        if (wasSyncLoaded) return child;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: frame == null ? placeholder : child,
        );
      },
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Favorite toggle with a small scale animation.
class LikeButton extends StatelessWidget {
  final bool liked;
  final VoidCallback onPressed;
  const LikeButton({super.key, required this.liked, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: liked ? 'Remove from favorites' : 'Add to favorites',
      isSelected: liked,
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
        child: Icon(
          liked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(liked),
          color: liked ? scheme.error : null,
        ),
      ),
    );
  }
}
