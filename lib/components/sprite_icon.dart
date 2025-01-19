import 'dart:ui';

import 'package:flame/components.dart';

class SpriteIcon extends SpriteComponent with HasGameRef {
  int number = 1;
  String spriteName;
  Paint iconColor;

  SpriteIcon({
    this.number = 1,
    required this.spriteName,
    required this.iconColor,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load the sprite
    sprite = await gameRef.loadSprite(spriteName);

    // Set the size and position
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(
        canvas,
        position: Vector2.zero(),
        size: size,
        overridePaint: iconColor,
      );
    }
  }
}
