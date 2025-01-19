import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// class SpiralPathHitbox extends PositionComponent
//     with HasGameRef<NumberLineGame>, CollisionCallbacks {
//   final Path path;

//   SpiralPathHitbox({required this.path});

//   @override
//   Future<void> onMount() async {
//     print("arrive in spiral segment onLoad");
//     super.onMount();

//     final pathMetrics = path.computeMetrics().toList();
//     final points = <Vector2>[];

//     for (final metric in pathMetrics) {
//       final length = metric.length;

//       for (double distance = 0; distance <= length; distance += 30) {
//         final tangent = metric.getTangentForOffset(distance);
//         if (tangent != null) {
//           points.add(Vector2(tangent.position.dx, tangent.position.dy));
//         }
//       }
//     }

//     add(PolygonHitbox(points));
//     print("SpiralPathHitbox onLoad");
//   }
// }

class DebugCircleHitbox extends CircleHitbox {
  DebugCircleHitbox({required double radius}) : super(radius: radius);

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);

  //   // Draw the circle with a debug-friendly style
  //   final paint = Paint()
  //     ..color = Colors.green.withOpacity(0.3) // Green semi-transparent fill
  //     ..style = PaintingStyle.fill;

  //   canvas.drawCircle(Offset.zero, radius, paint);
  // }
}

class SpiralPathHitbox extends PositionComponent
    with HasGameRef<NumberLineGame> {
  final Path path;

  SpiralPathHitbox({required this.path});

  @override
  Future<void> onMount() async {
    super.onMount();
    print("arrive in spiral segment onLoad");

    final pathMetrics = path.computeMetrics().toList();

    for (final metric in pathMetrics) {
      final length = metric.length;

      for (double distance = 0; distance <= length; distance += 30) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          final position = Vector2(tangent.position.dx, tangent.position.dy);
          add(DebugCircleHitbox(radius: 17.0)
            ..collisionType = CollisionType.passive
            ..position = position);
          // add(CircleHitbox()
          //   ..size = Vector2.all(30)
          //   ..isSolid = true
          //   ..position = position
          //   ..radius = 15 // Adjust radius based on spacing
          //   ..collisionType = CollisionType.passive);
        }
      }
    }
  }
}
