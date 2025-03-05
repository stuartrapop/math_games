import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class SpriteDisplay extends PositionComponent with HasPaint {
  final double spriteSize;
  final String spriteName;
  @override
  Anchor anchor = Anchor.center;

  SpriteDisplay({
    required this.spriteName,
    this.spriteSize = 50,
    this.anchor = Anchor.center,
  });

  @override
  Future<void> onLoad() async {
    debugMode = true;
    debugColor = const Color(0xFFFF00FF);
    final image = await Flame.images.load(spriteName);
    final spriteComponent = SpriteComponent.fromImage(image,
        size: Vector2.all(spriteSize), anchor: anchor);
    add(spriteComponent);
  }
}
