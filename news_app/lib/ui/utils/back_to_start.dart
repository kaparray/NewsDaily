import 'package:flutter/material.dart';

backToStart(ScrollController scrollController) async {
  if (scrollController.positions.isNotEmpty) {
    await scrollController.animateTo(0,
        curve: Curves.ease, duration: Duration(seconds: 2));
  }
}
