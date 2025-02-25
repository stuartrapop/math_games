import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class SpriteDisplay extends PositionComponent with HasPaint {
  final double spriteSize;
  final String spriteName;

  SpriteDisplay({
    required this.spriteName,
    this.spriteSize = 50,
  });

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(spriteName);
    final spriteComponent = SpriteComponent.fromImage(image,
        size: Vector2.all(spriteSize), anchor: Anchor.center);
    add(spriteComponent);
  }
}
