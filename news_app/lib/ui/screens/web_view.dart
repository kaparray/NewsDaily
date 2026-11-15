import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/utils/favorites.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.model.url));
    Favorites.isLiked(widget.model.url).then((liked) {
      if (mounted) setState(() => _liked = liked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.model.source?.name ?? ''),
        actions: <Widget>[
          IconButton(
            icon: Icon(_liked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<void> _toggleLike() async {
    final liked = await Favorites.toggle(widget.model);
    if (mounted) setState(() => _liked = liked);
  }
}
