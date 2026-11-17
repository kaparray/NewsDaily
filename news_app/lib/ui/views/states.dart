import 'package:material_ui/material_ui.dart';
import 'package:news_app/ui/theme.dart';

/// Centered icon + message + optional action, used for empty and error states.
class MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onRetry;

  const MessageState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.xxl,
        vertical: Insets.xxl * 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Insets.xl),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: scheme.onSecondaryContainer),
          ),
          const SizedBox(height: Insets.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          if (message != null) ...[
            const SizedBox(height: Insets.sm),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: Insets.xl),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pulsing placeholder list shown while news are loading.
class SkeletonList extends StatefulWidget {
  final int itemCount;
  const SkeletonList({super.key, this.itemCount = 4});

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget box({double? width, required double height, double radius = 6}) =>
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return Semantics(
      label: 'Loading news',
      liveRegion: true,
      child: ExcludeSemantics(
        child: FadeTransition(
          opacity: Tween(begin: 0.45, end: 1.0).animate(_controller),
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: box(height: 0, radius: Radii.lg),
                ),
                const SizedBox(height: Insets.md),
                box(width: 90, height: 14),
                const SizedBox(height: Insets.sm),
                box(height: 20),
                const SizedBox(height: Insets.sm),
                box(width: 220, height: 20),
                for (var i = 1; i < widget.itemCount; i++) ...[
                  const SizedBox(height: Insets.xl),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            box(width: 70, height: 12),
                            const SizedBox(height: Insets.sm),
                            box(height: 16),
                            const SizedBox(height: Insets.xs),
                            box(width: 160, height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.lg),
                      box(width: 96, height: 96, radius: Radii.md),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
