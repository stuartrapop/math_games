import 'package:first_math/components/sprite_icon.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ControlButton extends PositionComponent with TapCallbacks {
  ControlButton({
    required Vector2 position,
    required double size,
    required this.spriteName,
    this.callback = _defaultCallback,
  }) {
    this.position = position;
    this.size = Vector2.all(size);
    anchor = Anchor.center;
  }
  static void _defaultCallback() {}
  final Function callback;
  final String spriteName;
  late SpriteIcon sprite;
  late SpriteIcon backgroundSprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    backgroundSprite = SpriteIcon(
      spriteName: 'circleClaws.png',
      iconColor: Paint()
        ..colorFilter = const ColorFilter.mode(
          Color.fromARGB(255, 52, 52, 192), // White tint
          BlendMode.srcATop, // Ensures the original color is preserved
        ),
    )
      ..size = size * 0.75 // Inherit size from Dice
      ..position = size / 2 // Center DiceSprite within Dice
      ..anchor = Anchor.center;

    // Add DiceSprite as a childC
    add(backgroundSprite);
    final iconColor = Paint()
      ..colorFilter = const ColorFilter.mode(
        Color(0xFFFFFFFF), // White tint
        BlendMode.srcATop, // Ensures the original color is preserved
      );
    sprite = SpriteIcon(
      spriteName: spriteName,
      iconColor: iconColor,
    )
      ..size = size / 2 // Inherit size from Dice
      ..position = size / 2 // Center DiceSprite within Dice
      ..anchor = Anchor.center;

    // Add DiceSprite as a child
    add(sprite);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // Call the callback function
    callback();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double outerRadius = size.x / 2;
    final double innerRadius = outerRadius * 0.8;

    // Outer Circle
    final Paint outerPaint = Paint()
      ..color = const Color(0xFF8E79DE); // Light purple
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), outerRadius, outerPaint);

    // Inner Circle
    final Paint innerPaint = Paint()
      ..color = const Color(0xFF5749A5); // Dark purple
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), innerRadius, innerPaint);
  }
}
