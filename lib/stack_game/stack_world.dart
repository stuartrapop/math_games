import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StackWorld extends World {
  StackWorld();
  double borderWidth = 10.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, screenSize.x, screenSize.y),
    //   Paint()..color = const Color.fromARGB(255, 218, 107, 107),
    // );

    super.render(canvas);
  }
}
