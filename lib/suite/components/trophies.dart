import 'package:first_math/suite/suite_game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class TrophyComponent extends PositionComponent with HasGameRef<SuiteGame> {
  late Sprite trophySprite;
  final double trophySize;
  final double borderRadius = 20;
  final double padding = 30;
  final Paint backgroundPaint = Paint()..color = Colors.white;
  final Paint borderPaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20;

  TrophyComponent({this.trophySize = 50});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load trophy sprite
    final image = await Flame.images.load('trophy-cup.png');
    trophySprite = Sprite(image);

    // Set component size with padding
    size =
        Vector2((trophySize * 3) + (padding * 4), trophySize + (padding * 2));

    // Center the component
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);

    // Create three trophies
    for (int i = 0; i < 3; i++) {
      add(
        SpriteComponent(
          sprite: trophySprite,
          size: Vector2(trophySize, trophySize),
          position: Vector2(
              (i * (trophySize + padding)) + padding, padding), // Even spacing
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw rounded white background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, backgroundPaint);

    // Draw green border
    canvas.drawRRect(rrect, borderPaint);

    super.render(canvas);
  }
}
