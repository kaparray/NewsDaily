import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/utils/favorites.dart';
import 'package:news_app/ui/views/item_build.dart' show LikeButton;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final Articles model;

  const WebViewScreen({super.key, required this.model});

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _liked = false;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.model.url));
    Favorites.isLiked(widget.model.url).then((liked) {
      if (mounted) setState(() => _liked = liked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final host = Uri.tryParse(widget.model.url)?.host ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        leading: IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.model.source?.name ?? host,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (host.isNotEmpty)
              Text(
                host,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
          ],
        ),
        actions: <Widget>[
          LikeButton(liked: _liked, onPressed: _toggleLike),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share),
            onPressed: () =>
                SharePlus.instance.share(ShareParams(text: widget.model.url)),
          ),
          IconButton(
            tooltip: 'Open in browser',
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: _progress < 100
              ? LinearProgressIndicator(
                  value: _progress == 0 ? null : _progress / 100,
                  minHeight: 3,
                  semanticsLabel: 'Loading article',
                )
              : const SizedBox(height: 3),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<void> _openInBrowser() async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(
      Uri.parse(widget.model.url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the browser')),
      );
    }
  }

  Future<void> _toggleLike() async {
    final liked = await Favorites.toggle(widget.model);
    if (mounted) setState(() => _liked = liked);
  }
}
