import 'package:material_ui/material_ui.dart';
import 'package:news_app/ui/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildSearchBar(BuildContext context) {
  return SliverPadding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
    sliver: SliverList(
      delegate: SliverChildListDelegate([
        Card(
          color: Colors.transparent,
          elevation: 8,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Theme.of(context).colorScheme.secondary,
              child: TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  hintText: 'Search news',
                ),
                textInputAction: TextInputAction.search,
                cursorColor: Colors.black54,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
                onSubmitted: (text) => searchLogic(context, text),
              ),
            ),
          ),
        ),
      ]),
    ),
  );
}

Future<void> searchLogic(BuildContext context, String text) async {
  final navigator = Navigator.of(context);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('priorityTheme', text);
  navigator.popUntil((route) => route.isFirst);
  navigator.push(
    MaterialPageRoute<void>(builder: (_) => SearchScreen(title: text)),
  );
}
