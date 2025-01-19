import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Cell extends PositionComponent with CollisionCallbacks {
  double radius;
  int row;
  int column;

  Cell({
    required this.row,
    required this.column,
    required this.radius,
    Vector2? position,
    Vector2? scale,
    double angle = 0.0,
    Anchor anchor = Anchor.center,
    List<Component> children = const [],
    Paint? paint,
    Key? key,
  }) : super(
          position: position,
          scale: scale,
          angle: angle,
          anchor: anchor,
          children: children,
        );
  late Paint backgroundPaint;
  late Paint outlinePaint;

  @override
  FutureOr<void> onLoad() {
    priority = 30;
    double borderWidth = 1; // Width of the white edge
    backgroundPaint = Paint()..color = Colors.grey[300]!;
    outlinePaint = Paint()
      ..color = const Color.fromARGB(255, 185, 188, 218) // White color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Add hitbox for collision detection
    add(
      RectangleHitbox()
        ..collisionType = CollisionType.passive
        ..size = size // Match cell size
        ..anchor = Anchor.topLeft,
    );
    TextComponent text = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w100,
          color: Color.fromARGB(255, 214, 197, 197),
        ),
      ),
      text: 'x',
    )
      ..anchor = Anchor.center
      ..position = size / 2;
    add(text);
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
      Radius.circular(radius),
    );

    canvas.drawRRect(roundedRect, outlinePaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.x,
          size.y,
        ),
        Radius.circular(radius), // Match corner radius
      ),
      backgroundPaint,
    );
    // If additional rendering is required, add it here
  }
}
