import 'dart:ui';

import 'package:first_math/dice_game/dice.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';

class Receptors extends PositionComponent with CollisionCallbacks {
  String name;
  late ReceptorSprite receptorSprite;

  Receptors({this.name = 'cauldron', int priority = 12}) {
    receptorSprite = ReceptorSprite(name: name);
    this.priority = priority;
  }

  final effect = SequenceEffect([
    ScaleEffect.by(
      Vector2.all(1.3),
      EffectController(
        duration: 0.2,
        alternate: true,
      ),
    ),
    ScaleEffect.by(
      Vector2.all(0.8),
      EffectController(
        duration: 0.2,
        alternate: true,
      ),
    ),
    ScaleEffect.to(
      Vector2.all(1),
      EffectController(
        duration: 0.2,
      ),
    ),
  ])
    ..removeOnFinish = false;

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      print("Dice collided with ScreenHitbox");
    } else if (other is Dice) {
      print("Dice collided with Dice");
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox) {
      //...
    } else if (other is Dice) {
      effect.reset();
    }
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Set size and anchor for Dice
    anchor = Anchor.center;

    receptorSprite = ReceptorSprite(name: name)
      ..size = size
      ..position = size / 2
      ..anchor = Anchor.center;

    // Add DiceSprite as a child
    add(receptorSprite);
    add(RectangleHitbox()
      ..size = Vector2(10, 10)
      ..anchor = Anchor.center);
    add(effect);
  }

  // Implement dragging logic for Dice
  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.add(event.delta); // Update position with drag delta
  }

  @override
  void render(Canvas canvas) {
    // Draw a solid black background
    // final paint = Paint()..color = const Color(0xFF000000); // Opaque black
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    super.render(canvas);
  }
}

class ReceptorSprite extends SpriteComponent with HasGameRef {
  String name;
  ReceptorSprite({this.name = 'cauldron'});
  @override
  Sprite? sprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('$name.png');

    anchor = Anchor.center;

    // Apply the color tint using the paint property
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 247, 249, 247); // Change this color to your desired tint
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF000000); // Opaque black
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    super.render(canvas);
  }
}
//     // }