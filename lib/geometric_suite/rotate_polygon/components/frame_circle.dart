import 'package:first_math/geometric_suite/common/types/AbstractFlameGameClass.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class FrameCircle extends CircleComponent
    with TapCallbacks, HasGameRef<GameWithFrameFeatures> {
  late final Paint borderPaint;
  Color color;
  double rotateIncrement;
  InterfaceClickableShape questionShape;

  FrameCircle({
    this.color = Colors.white,
    Color borderColor = Colors.white54,
    double borderWidth = 4,
    double radius = 300,
    this.rotateIncrement = 10,
    required this.questionShape,
  }) : super(
          radius: radius,
        ) {
    borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
  }

  @override
  Future<void> onLoad() {
    debugMode = false;
    size = Vector2(radius * 2, radius * 2);
    print("radius: $radius");

    add(questionShape
      ..position = Vector2(
          radius - questionShape.width / 2, radius - questionShape.height / 2));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the circle border
    canvas.drawCircle(
        Offset(radius, radius), radius, Paint()..color = Colors.red);
  }
}
