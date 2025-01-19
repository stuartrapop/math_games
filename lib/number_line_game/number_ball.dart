import 'dart:math' as math;

import 'package:first_math/number_line_game/cannon.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:first_math/number_line_game/number_line_world.dart';
import 'package:first_math/number_line_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class NumberBall extends CircleComponent
    with HasGameRef<NumberLineGame>, HasVisibility {
  final int number;
  bool isMoving = false;
  Vector2 velocity = Vector2.zero();
  late TextComponent valueText;
  bool isNextBall;
  bool isPlaingHitorMiss = false;
  bool updateShaderFlag = true;

  NumberBall({required this.number, required this.isNextBall, Color? color})
      : super(
          paint: Paint()..color = color ?? _getColorForNumber(number),
        );
  static Color _getColorForNumber(int number) {
    return ballColors[number % 10];
  }

  void onHit({int number = 1}) {
    gameRef.hitAudioPool.play();
  }

  void onMiss() {
    gameRef.missAudioPool.play(); // Play miss sound
  }

  void updateShader() {
    if (!updateShaderFlag) {
      return;
    }
    print("updateing shader");
    final color = _getColorForNumber(number);
    double oppositeAngle = 0.0;
    // Calculate the opposite rotation for the gradient
    if (parent is Cannon) {
      Cannon cannon = parent as Cannon;
      oppositeAngle = -cannon.angle;
    } else {
      oppositeAngle = 0.0;
    }
    double radians = oppositeAngle;

    double centerX = 0.5 + math.cos(radians) * 0.5;
    double centerY = 0.5 + math.sin(radians) * 0.5;

    paint.shader = RadialGradient(
      center: Alignment(
          centerX * 2 - 1, centerY * 2 - 1), // Convert to Alignment coordinates
      focalRadius: 2,
      radius: 0.75,
      colors: [
        Colors.white,
        isNextBall ? color.withOpacity(0.2) : color,
      ],
    ).createShader(Rect.fromCircle(
        center: Offset(size.x / 2, size.y / 2), radius: radius));
    updateShaderFlag = false;
  }

  @override
  Future<void> onLoad() {
    // debugMode = true;

    size = Vector2(radius * 2, radius * 2);
    add(CircleHitbox()..collisionType = CollisionType.active);
    updateShader();
    valueText = TextComponent(
      text: "$number",
      position: size / 2, // Adjust position for alignment
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 46, 44, 44),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(valueText);
    return super.onLoad();
  }

  void showPopUpText(Vector2 position, String text) {
    final popUp = TextComponent(
      text: text,
      position: position,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    )..priority = 100;
    // Add move effect
    popUp.add(
      MoveEffect.by(
        onComplete: () => popUp.removeFromParent(),
        Vector2(20, 20),
        EffectController(
          duration: 0.5,
          curve: Curves.easeOut,
        ),
      ),
    );
    Future.delayed(Duration(seconds: 1), () {
      if (popUp.isMounted) {
        debugPrint('Fallback: Removing popUp to avoid memory leak');
        popUp.removeFromParent();
      }
    });
    game.world.add(popUp);
  }

  List<int> getIndexRange(int index) {
    int left = index;
    int right = index;
    int targetNumber = gameRef.balls[index].number;

    // Check both left and right simultaneously
    while (left >= 0 || right < gameRef.balls.length) {
      if (left >= 0 && gameRef.balls[left].number == targetNumber) {
        left--;
      }
      if (right < gameRef.balls.length &&
          gameRef.balls[right].number == targetNumber) {
        right++;
      }

      // Break the loop early if both sides are done
      if ((left < 0 || gameRef.balls[left].number != targetNumber) &&
          (right >= gameRef.balls.length ||
              gameRef.balls[right].number != targetNumber)) {
        break;
      }
    }

    return [left + 1, right - 1];
  }

  void treatCollision() {
    // print("treatCollision");
    final center = position.toOffset();
    final world = gameRef.world as NumberLineWorld;
    final distanceOnPathIfCollide = game.gamePath.getDistanceOnPath(center, 20);

    if (distanceOnPathIfCollide == null) {
      return;
    }
    int ballIndex = (distanceOnPathIfCollide / 40).floor();

    this.isMoving = false;
    if (ballIndex < game.balls.length) {
      final ballValue = game.balls[ballIndex].number;
      if (ballValue + number == 10) {
        List<int> range = getIndexRange(ballIndex);
        final ballsToRemove = game.balls.sublist(range[0], range[1] + 1);
        game.balls.removeRange(range[0], range[1] + 1);
        for (final ball in ballsToRemove) {
          ball.removeFromParent();
        }
        this.removeFromParent();
        game.score += ((range[1] - range[0] + 1) * 10);
        world.updateScore();
        onHit(number: range[1] - range[0] + 1);
        showPopUpText(
          position,
          "+ ${((range[1] - range[0] + 1) * 10).toString()}",
        );
      } else {
        onMiss();
        game.balls.insert(ballIndex, this);
      }
    } else {
      game.balls.add(this);
      onMiss();
    }
  }

  bool checkCollisionWithSpiralPath() {
    final world = gameRef.world as NumberLineWorld;
    final spiralHitbox = world.spiralPathHitbox;
    if (position.distanceTo(Vector2(400, 300)) <= 150) {
      return false;
    }
    final center = position.toOffset();
    if (center.dx < 0 || center.dx > 800 || center.dy < 0 || center.dy > 600) {
      this.removeFromParent();

      onMiss();
      return false;
    }

    for (final hitbox in spiralHitbox.children.whereType<CircleHitbox>()) {
      if (position.distanceTo(hitbox.position) <= (radius + hitbox.radius)) {
        return true;
      }
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateShader();

    if (isMoving) {
      position += velocity * dt;

      if (checkCollisionWithSpiralPath()) {
        treatCollision();
      }
    }
  }

  @override
  void onRemove() {
    paint.shader = null; // Clean up shader to release resources

    super.onRemove();
  }
}
