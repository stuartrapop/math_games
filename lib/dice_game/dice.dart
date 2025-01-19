import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/dice_game/receptors.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';

class Dice extends PositionComponent
    with
        DragCallbacks,
        CollisionCallbacks,
        FlameBlocReader<GameStatsBloc, GameStatsState>,
        HasPaint {
  int number;
  late DiceSprite diceSprite;
  bool _isDragged = false;
  Vector2 initialPosition;

  Dice({required this.initialPosition, this.number = 1, int priority = 10}) {
    // Create DiceSprite and pass the number to it
    diceSprite = DiceSprite(number: number);
    this.priority = priority;
  }
  // Define a threshold for how close the Dice needs to be to the center of Receptors
  final double collisionThreshold = 60.0; // Adjust this as needed
  // Example function to update score
  void updateScore() {
    bloc.add(ScoreEventAdded(number));
  }

  final effectSize = SequenceEffect([
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

  final effectGlow = SequenceEffect(infinite: true, [
    ScaleEffect.by(
      Vector2.all(1.04),
      EffectController(
        duration: 0.2,
        alternate: true,
      ),
    ),
    ScaleEffect.by(
      Vector2.all(0.96),
      EffectController(
        duration: 0.2,
        alternate: true,
      ),
    ),
  ])
    ..removeOnFinish = false;

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      print("Dice collided with ScreenHitbox");
    } else if (other is Receptors) {
      final distance = (position - other.position).length;
      if (distance < collisionThreshold) {
        print("Dice collided with Receptors");
        animateBackToOriginalPosition();
        position = initialPosition;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox) {
      //...
    } else if (other is Receptors) {
      // FlameAudio.play('random.wav', volume: 1);
      animateBackToOriginalPosition();
      position = initialPosition;
      updateScore();
      _isDragged = false;
      priority = 10;
    }
  }

  void animateBackToOriginalPosition() {
    // Remove any existing effects to avoid conflicts

    // effectSize.reset();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Set size and anchor for Dice
    anchor = Anchor.center;

    diceSprite = DiceSprite(number: number)
      ..size = size // Inherit size from Dice
      ..position = size / 2 // Center DiceSprite within Dice
      ..anchor = Anchor.center;

    // Add DiceSprite as a child
    add(diceSprite);
    add(RectangleHitbox()
      ..size = Vector2(10, 10)
      ..anchor = Anchor.center
      ..priority = 1);
    add(effectGlow);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _isDragged = true;
    effectGlow.reset();
  }

  // Implement dragging logic for Dice
  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragged) return;
    priority = 11;
    position.add(event.delta); // Update position with drag delta
  }

  @override
  void render(Canvas canvas) {
    // Draw a solid black background
    final paint = Paint()..color = const Color(0xFF000000); // Opaque black
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    super.render(canvas);
  }
}

class DiceSprite extends SpriteComponent with HasGameRef {
  int number = 1;
  DiceSprite({this.number = 1});
  @override
  Sprite? sprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('inverted-dice-${number.toString()}.png');

    anchor = Anchor.center;

    // Apply the color tint using the paint property
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 247, 249, 247); // Change this color to your desired tint
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
//     // }