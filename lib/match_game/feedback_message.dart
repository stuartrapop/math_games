import 'dart:async';

import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FeedbackMessage extends PositionComponent {
  final String message;

  FeedbackMessage({required this.message});

  @override
  FutureOr<void> onLoad() {
    final feedbackText = TextComponent(
      priority: 50,
      text: message,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
      ..position = Vector2(size.x / 2, size.y / 2)
      ..anchor = Anchor.center;
    add(feedbackText);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      fill75TransparentBlack,
    );
    super.render(canvas);
  }
}
