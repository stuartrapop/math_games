import 'dart:async';
import 'dart:ui';

import 'package:first_math/components/control_button.dart';
import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;

class Frame extends PositionComponent with HasGameRef<GeometryGame> {
  double borderWidth;
  final fl_game.RouterComponent router;
  Function returnHome;
  Frame({
    required this.borderWidth,
    required this.router,
    required this.returnHome,
  }) {
    anchor = Anchor.center;
  }
  @override
  FutureOr<void> onLoad() {
    // Set the size of the frame to match the game screen size
    size.setValues(gameRef.size.x, gameRef.size.y);
    add(
      ControlButton(
        position: Vector2(50, 50),
        size: 100,
        spriteName: 'home100.png',
        callback: () {
          // Add the 'home' overlay
          print('Navigating to home... ${router.children}');

          returnHome();
          ;
          // router.pop();
        },
      ),
    );
    add(
      ControlButton(
        position: Vector2(50, 550),
        size: 100,
        spriteName: 'return64.png',
        callback: () {
          // Add the 'home' overlay
          print('Navigating to navigation3... ${router.children}');

          game.router.pushReplacementNamed('moving-containers3');
          // router.pop();
        },
      ),
    );
    add(
      ControlButton(
        position: Vector2(750, 550),
        size: 100,
        spriteName: 'check48.png',
      ),
    );
    add(
      ControlButton(
        position: Vector2(750, 50),
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
      ..blendMode = BlendMode.clear; // Transparent

    // Outer rectangle dimensions
    final outerRect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(40),
    );

    // Inner rectangle dimensions (smaller by borderWidth on all sides)
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        borderWidth,
        borderWidth,
        size.x - borderWidth,
        size.y - borderWidth,
      ),
      const Radius.circular(20),
    );

    // Draw the outer rectangle (solid border)
    canvas.drawRRect(outerRect, outerPaint);

    // Draw the transparent inner rectangle to create the frame effect
    canvas.drawRRect(innerRect, transparentPaint);
  }
}
