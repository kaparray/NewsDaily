import 'package:material_ui/material_ui.dart';

Future<void> backToStart(ScrollController? scrollController) async {
  if (scrollController != null && scrollController.hasClients) {
    await scrollController.animateTo(
      0,
      curve: Curves.ease,
      duration: const Duration(seconds: 2),
    );
  }
}
