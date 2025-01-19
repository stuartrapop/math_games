import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CuisenaireWorld extends World {
  CuisenaireWorld();
  double borderWidth = 10.0;
  late Paint backgroundColor;

  @override
  Future<void> onLoad() async {
    backgroundColor = Paint()..color = const Color.fromARGB(255, 197, 197, 206);
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 1000, 900),
      backgroundColor,
    );

    super.render(canvas);
  }
}
