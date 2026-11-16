import 'package:material_ui/material_ui.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/ui/screens/web_view.dart';
import 'package:news_app/ui/utils/favorites.dart';
import 'package:news_app/utils/news_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _fallbackImage =
    'https://avatars1.githubusercontent.com/u/31259204?s=40&v=1';

Widget buildListSliver(
  NewsModel values,
  BuildContext context, {
  String emptyMessage = 'No news found',
}) {
  if (values.articles.isEmpty) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) => ListItemBuild(values.articles[index]),
      childCount: values.articles.length,
    ),
  );
}

class ListItemBuild extends StatefulWidget {
  final Articles model;
  const ListItemBuild(this.model, {super.key});

  @override
  State<ListItemBuild> createState() => ListItemState();
}

class ListItemState extends State<ListItemBuild> with TickerProviderStateMixin {
  late final AnimationController colorAnimationController;
  late final Animation<double> colorAnimation;
  late final ImageProvider image;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener;

  bool _liked = false;
  double height = 150;
  int maxline = 2;

  @override
  void initState() {
    super.initState();
    _initLiked();
    _initHeight();
    colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    colorAnimation = Tween(
      begin: 1.0,
      end: .5,
    ).animate(colorAnimationController);
    image = NetworkImage(widget.model.urlToImage ?? _fallbackImage);
    _imageListener = ImageStreamListener(
      (_, _) => colorAnimationController.forward(),
      onError: (_, _) {},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageStream?.removeListener(_imageListener);
    _imageStream = image.resolve(createLocalImageConfiguration(context))
      ..addListener(_imageListener);
  }

  Future<void> _initLiked() async {
    final liked = await Favorites.isLiked(widget.model.url);
    if (mounted) setState(() => _liked = liked);
  }

  void _initHeight() {
    if (widget.model.title.length >= 90) {
      height += 10;
      maxline++;
    }
    if (widget.model.title.length >= 110) {
      height += 15;
      maxline++;
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, _) => _buildItem(context),
    );
  }

  Widget _buildItem(BuildContext context) {
    return SizedBox(
      height: height,
      child: InkWell(
        onTap: () => logicWeb(widget.model, context),
        child: Card(
          color: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black54.withValues(alpha: colorAnimation.value),
                    BlendMode.hardLight,
                  ),
                  fit: BoxFit.cover,
                  image: image,
                  onError: (_, _) {},
                ),
              ),
              child: Column(
                children: <Widget>[
                  _headerItemBuild(),
                  _textItemBuild(),
                  _dateItemBuild(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerItemBuild() {
    final accent = Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            widget.model.source?.name ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: accent),
              onPressed: () =>
                  SharePlus.instance.share(ShareParams(text: widget.model.url)),
            ),
            IconButton(
              icon: Icon(
                _liked ? Icons.favorite : Icons.favorite_border,
                color: accent,
              ),
              onPressed: _toggleLike,
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateItemBuild() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        timeAgo(widget.model.publishedAt),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _toggleLike() async {
    final liked = await Favorites.toggle(widget.model);
    if (mounted) setState(() => _liked = liked);
  }

  Future<void> logicWeb(Articles values, BuildContext context) async {
    final navigator = Navigator.of(context);
    final prefs = await SharedPreferences.getInstance();
    final openInBrowser = prefs.getBool('browser') ?? false;
    if (openInBrowser) {
      final uri = Uri.parse(values.url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${values.url}');
      }
    } else {
      navigator.push(
        MaterialPageRoute<void>(builder: (_) => WebViewScreen(model: values)),
      );
    }
  }

  Widget _textItemBuild() {
    return Flexible(
      child: Text(
        widget.model.title,
        maxLines: maxline,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
