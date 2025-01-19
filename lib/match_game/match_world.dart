import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MatchWorld extends World {
  MatchWorld();
  double borderWidth = 10.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, 900, 800),
    //   Paint()..color = const Color.fromARGB(255, 39, 39, 115),
    // );

    super.render(canvas);
  }
}
