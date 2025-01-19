import 'dart:async';
import 'dart:math';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/shape_match_game.dart/shape_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flutter/material.dart';

class ShapeMatchGameComponent extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  final Function returnHome;
  final OperationsBloc operationsBloc;
  ShapeMatchGameComponent({
    required this.operationsBloc,
    required this.returnHome,
  }) : super();

  late ShapeComponent targetShape;
  late List<ShapeComponent> optionShapes;
  int score = 0;
  int attempts = 0;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create target shape
    targetShape =
        generateRandomShape(position: Vector2(size.x / 2, 100), isTarget: true);
    add(targetShape);

    // Create option shapes
    optionShapes = List.generate(
        3,
        (index) => generateRandomShape(
            position: Vector2(size.x * (0.25 * (index + 1)), size.y - 200),
            // position: Vector2(200, 200),
            isTarget: false));
    optionShapes.forEach((shape) => add(shape));
  }

  ShapeComponent generateRandomShape(
      {required Vector2 position, required bool isTarget}) {
    ShapeType type = ShapeType.values[random.nextInt(ShapeType.values.length)];
    Color color = isTarget
        ? Colors.black
        : Colors.primaries[random.nextInt(Colors.primaries.length)];

    return ShapeComponent(
        type: type, color: color, position: position, isTarget: isTarget);
  }

  void checkMatch(ShapeComponent selectedShape) {
    attempts++;

    if (selectedShape.type == targetShape.type) {
      score++;
      removeAll([targetShape, ...optionShapes]);

      // Regenerate shapes
      targetShape = generateRandomShape(
          position: Vector2(size.x / 2, 100), isTarget: true);
      add(targetShape);

      optionShapes = List.generate(
          3,
          (index) => generateRandomShape(
              position: Vector2(size.x * (0.25 * (index + 1)), size.y - 200),
              isTarget: false));
      optionShapes.forEach((shape) => add(shape));
    } else {
      // Highlight incorrect shape
      selectedShape.highlight();
    }
  }
}

enum ShapeType { circle, triangle, square, hexagon }

class ShapeComponent extends PositionComponent
    with TapCallbacks, HasGameRef<ShapeMatchGame> {
  final ShapeType type;
  final Color color;
  final bool isTarget;
  bool _isHighlighted = false;

  ShapeComponent(
      {required this.type,
      required this.color,
      required Vector2 position,
      required this.isTarget}) {
    this.position = position;
    size = Vector2.all(100);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final touchPosition = event.canvasPosition;
    print("onTapDown  $type $isTarget $touchPosition");
    if (isTarget) {
      return;
    }
    try {
      final target = parent?.children.firstWhere((element) {
        return element is ShapeComponent && element.isTarget;
      }) as ShapeComponent;
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
      case ShapeType.circle:
        canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.x / 2, 0)
          ..lineTo(0, size.y)
          ..lineTo(size.x, size.y)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.square:
        canvas.drawRect(Offset.zero & size.toSize(), paint);
        break;
      case ShapeType.hexagon:
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
        case ShapeType.circle:
          canvas.drawCircle(
              Offset(size.x / 2, size.y / 2), size.x / 2, borderPaint);
          break;
        case ShapeType.triangle:
          final path = Path()
            ..moveTo(size.x / 2, 0)
            ..lineTo(0, size.y)
            ..lineTo(size.x, size.y)
            ..close();
          canvas.drawPath(path, borderPaint);
          break;
        case ShapeType.square:
          canvas.drawRect(Offset.zero & size.toSize(), borderPaint);
          break;
        case ShapeType.hexagon:
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
