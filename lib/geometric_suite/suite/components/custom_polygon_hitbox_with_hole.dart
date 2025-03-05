import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CustomPolygonWithHole extends PolygonHitbox {
  final Vector2 holeCenter;
  final double holeRadius;

  CustomPolygonWithHole({
    required List<Vector2> vertices,
    required this.holeCenter,
    required this.holeRadius,
  }) : super(vertices);

  @override
  bool containsLocalPoint(Vector2 point) {
    // First check if point is in the polygon
    if (!super.containsLocalPoint(point)) {
      return false;
    }

    // Then check if it's in the hole
    final dx = point.x - holeCenter.x;
    final dy = point.y - holeCenter.y;
    final distanceSquared = dx * dx + dy * dy;

    // If distance is less than radius squared, point is in hole
    return distanceSquared >= holeRadius * holeRadius;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the hole in debug mode
    if (debugMode) {
      final paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(
        Offset(holeCenter.x, holeCenter.y),
        holeRadius,
        paint,
      );
    }
  }
}
