import 'dart:async';
import 'dart:ui';

import 'package:first_math/components/control_button.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;

class Frame extends PositionComponent with HasGameRef<SuiteGame> {
  double borderWidth;
  Function returnHome;
  Function validate;
  Frame(
      {required this.borderWidth,
      required this.returnHome,
      required this.validate}) {
    anchor = Anchor.center;
  }
  @override
  FutureOr<void> onLoad() {
    // Set the size of the frame to match the game screen size
    print('gameRef.size.x: ${gameRef.size.x}');
    double width = gameRef.size.x - 2 * borderWidth;
    double height = gameRef.size.y - 2 * borderWidth;
    double distanceFromEdge = 50;
    size.setValues(width, height);
    add(
      ControlButton(
        position: Vector2(distanceFromEdge, distanceFromEdge),
        size: 100,
        spriteName: 'home100.png',
        callback: () {
          // Add the 'home' overlay

          returnHome();
          ;
          // router.pop();
        },
      ),
    );
    add(
      ControlButton(
        position: Vector2(distanceFromEdge, height - distanceFromEdge),
        size: 100,
        spriteName: 'return64.png',
        callback: () {
          // Add the 'home' overlay

          game.router.pushReplacementNamed('menu');
          // router.pop();
        },
      ),
    );
    add(
      ControlButton(
        position: Vector2(width - distanceFromEdge, height - distanceFromEdge),
        size: 100,
        spriteName: 'check48.png',
        callback: () {
          // Add the 'home' overlay

          validate();
        },
      ),
    );
    add(
      ControlButton(
        position: Vector2(width - distanceFromEdge, distanceFromEdge),
        size: 100,
        spriteName: 'question48.png',
      ),
    );

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final outerPaint = Paint()..color = const Color(0xFF8E79DE); // Solid color
    final transparentPaint = Paint()
      ..color =
          const Color.fromARGB(255, 99, 98, 103); // Solid color // Transparent

    // Outer rectangle dimensions
    final outerRect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(60),
    );

    // Inner rectangle dimensions (smaller by borderWidth on all sides)
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        borderWidth,
        borderWidth,
        size.x - borderWidth,
        size.y - borderWidth,
      ),
      const Radius.circular(40),
    );

    // Draw the outer rectangle (solid border)
    canvas.drawRRect(outerRect, outerPaint);

    // Draw the transparent inner rectangle to create the frame effect
    canvas.drawRRect(innerRect, transparentPaint);
  }
}
