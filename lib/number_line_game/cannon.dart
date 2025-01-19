import 'dart:math' as math;
import 'dart:math';

import 'package:first_math/number_line_game/game_path.dart';
import 'package:first_math/number_line_game/number_ball.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Cannon extends CircleComponent with HasGameRef<NumberLineGame> {
  Cannon({required this.gamePath}) : super();
  Paint backgroundColor = Paint();
  Paint cannonColor = Paint();

  final Paint outlineColor = Paint()
    ..color = const Color.fromARGB(255, 207, 25, 12)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0; // Set the stroke width for the outline

  late RectangleComponent cannon;
  late NumberBall currentBall;
  late NumberBall nextBall;
  final GamePath gamePath;
  bool isPlaying = false;
  bool isPlayingShoot = false;

  void _updateShader() {
    final color = Color.fromARGB(255, 183, 63, 42);
    double oppositeAngle = -angle;
    double centerX = 0.5 + math.cos(oppositeAngle) * 0.5;
    double centerY = 0.5 + math.sin(oppositeAngle) * 0.5;
    backgroundColor.shader = RadialGradient(
      center: Alignment(
          centerX * 2 - 1, centerY * 2 - 1), // Convert to Alignment coordinates
      focalRadius: 2,
      radius: 0.5,
      colors: [
        Colors.white,
        color,
      ],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    cannonColor.shader = LinearGradient(
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment(
          math.cos(oppositeAngle), // Perpendicular to the cannon
          math.sin(oppositeAngle)),
      end: Alignment(
          math.cos(oppositeAngle +
              math.pi), // Perpendicular in the opposite direction
          math.sin(oppositeAngle + math.pi)),
      colors: [
        Colors.white,
        color,
        color,
      ],
    ).createShader(const Rect.fromLTWH(0, 0, 60, 30));
  }

  @override
  Future<void> onLoad() {
    // _updateShader();
    CircleBackgroundComponent turret = CircleBackgroundComponent(
      backgroundColor,
      outlineColor,
      35,
    )..priority = 3;
    add(turret);

    cannon = RectangleComponent()
      ..size = Vector2(60, 30)
      ..anchor = Anchor.centerLeft
      ..position = Vector2(0, 0)
      ..paint = cannonColor
      ..priority = 1;
    add(cannon);
    currentBall = NumberBall(
      number: Random().nextInt(9) + 1,
      isNextBall: false,
    )
      ..anchor = Anchor.center
      ..radius = 20
      ..position = Vector2(60, 0)
      ..priority = 4;

    add(currentBall);
    nextBall = NumberBall(
      isNextBall: true,
      number: Random().nextInt(9) + 1,
    )
      ..anchor = Anchor.center
      ..radius = 20
      ..position = Vector2(0, 0)
      ..priority = 4;
    add(nextBall);

    return super.onLoad();
  }

  void onShoot() async {
    gameRef.shootAudioPool.play();
  }

  void startbgm() async {
    await gameRef.bgmAudioPlayer.stop();
    await gameRef.bgmAudioPlayer.seek(Duration.zero);
    await gameRef.bgmAudioPlayer.setLoopMode(LoopMode.one);
    await gameRef.bgmAudioPlayer.play();
    gameRef.hasVolume = true;
  }

  void shoot(Vector2 direction, double speed) {
    // Set the ball's moving flag and velocity
    if (!isPlaying) {
      startbgm();
      isPlaying = true;
    }
    currentBall.removeFromParent();
    gameRef.world.add(currentBall
      ..position = Vector2(400, 300) + direction * 60
      ..isMoving = true
      ..priority = 40
      ..velocity = direction * speed);
    currentBall.updateShaderFlag = true;
    onShoot();
    NumberBall newBall = NumberBall(
      isNextBall: true,
      number: Random().nextInt(9) + 1,
    )
      ..anchor = Anchor.center
      ..radius = 20
      ..position = Vector2(0, 0)
      ..priority = 40;

    currentBall = nextBall;
    currentBall
      ..position = Vector2(60, 0)
      ..radius = 20
      ..isNextBall = false
      ..priority = 40;

    nextBall = newBall;
    add(nextBall);
    newBall.updateShaderFlag = true;
    currentBall.updateShaderFlag = true;
    nextBall.updateShaderFlag = true;
  }

  @override
  void update(double dt) {
    _updateShader();
    super.update(dt);
  }

  @override
  void onRemove() {
    paint.shader = null; // Clean up shader to release resources
    cannonColor.shader = null;
    backgroundColor.shader = null;
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {}
}

class CircleBackgroundComponent extends CircleComponent {
  final Paint backgroundColor;
  final Paint outlineColor;

  CircleBackgroundComponent(
      this.backgroundColor, this.outlineColor, double radius)
      : super(radius: radius, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    final center = Vector2.zero().toOffset();
    canvas.drawCircle(center, radius, backgroundColor);
    canvas.drawCircle(center, radius, outlineColor);
  }
}
