import 'dart:math';

import 'package:first_math/suite/suite_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum GeoType { circle, triangle, square, hexagon }

class GeometricShape extends PositionComponent
    with TapCallbacks, HasGameRef<SuiteGame> {
  final GeoType type;
  final Color color;
  final bool isTarget;
  bool _isHighlighted = false;

  GeometricShape(
      {required this.type, required this.color, required this.isTarget});

  @override
  void onTapDown(TapDownEvent event) {
    final touchPosition = event.canvasPosition;
    print("onTapDown  $type $isTarget $touchPosition");
    if (isTarget) {
      return;
    }
    try {
      final target = parent?.children.firstWhere((element) {
        return element is GeometricShape && element.isTarget;
      }) as GeometricShape;
      print("target type ${target.type}");
      if (target.type == type) {
        print("Match");
      } else {
        print("No Match");
      }
    } catch (e) {
      print("onTapDown error $e");
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = _isHighlighted ? Colors.red : color
      ..style = PaintingStyle.fill;

    switch (type) {
      case GeoType.circle:
        canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
        break;
      case GeoType.triangle:
        final path = Path()
          ..moveTo(size.x / 2, 0)
          ..lineTo(0, size.y)
          ..lineTo(size.x, size.y)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case GeoType.square:
        canvas.drawRect(Offset.zero & size.toSize(), paint);
        break;
      case GeoType.hexagon:
        final path = Path();
        final centerX = size.x / 2;
        final centerY = size.y / 2;
        final radius = size.x / 2;

        for (int i = 0; i < 6; i++) {
          final angle = (pi / 3) * i - pi / 2;
          final x = centerX + radius * cos(angle);
          final y = centerY + radius * sin(angle);

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
    }

    // Draw black border for target shape
    if (isTarget) {
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      switch (type) {
        case GeoType.circle:
          canvas.drawCircle(
              Offset(size.x / 2, size.y / 2), size.x / 2, borderPaint);
          break;
        case GeoType.triangle:
          final path = Path()
            ..moveTo(size.x / 2, 0)
            ..lineTo(0, size.y)
            ..lineTo(size.x, size.y)
            ..close();
          canvas.drawPath(path, borderPaint);
          break;
        case GeoType.square:
          canvas.drawRect(Offset.zero & size.toSize(), borderPaint);
          break;
        case GeoType.hexagon:
          final path = Path();
          final centerX = size.x / 2;
          final centerY = size.y / 2;
          final radius = size.x / 2;

          for (int i = 0; i < 6; i++) {
            final angle = (pi / 3) * i - pi / 2;
            final x = centerX + radius * cos(angle);
            final y = centerY + radius * sin(angle);

            if (i == 0) {
              path.moveTo(x, y);
            } else {
              path.lineTo(x, y);
            }
          }
          path.close();
          canvas.drawPath(path, borderPaint);
          break;
      }
    }
  }

  void highlight() {
    _isHighlighted = true;
    Future.delayed(Duration(milliseconds: 500), () {
      _isHighlighted = false;
    });
  }
}
