import 'dart:math';

import 'package:first_math/number_line_game/cannon.dart';
import 'package:first_math/number_line_game/number_ball.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:first_math/number_line_game/number_line_world.dart';
import 'package:first_math/number_line_game/volume.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart' as fl_events;
import 'package:flutter/material.dart';

class NumberLineComponent extends PositionComponent
    with
        fl_events.TapCallbacks,
        fl_events.HoverCallbacks,
        fl_events.PointerMoveCallbacks,
        fl_events.DragCallbacks,
        HasGameRef<NumberLineGame> {
  final Function returnHome;
  NumberLineComponent({required this.returnHome}) : super();

  final List<Offset> ballPositions = [];
  final double ballSpacing = 40.0;
  bool isPlaying = false;

  late Cannon cannon;

  bool hasInteracted = false;
  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 50, 50, 52);

  @override
  Future<void> onLoad() async {
    print("NumberLineComponent onLoad");
    final game = gameRef;
    final world = game.world as NumberLineWorld;

    // Start near the end
    game.resetGame();

    cannon = Cannon(gamePath: gameRef.gamePath)
      ..anchor = Anchor.topLeft
      ..radius = 35
      ..position = Vector2(400, 300);
    world.add(cannon);

    world.add(TextComponent(
      text: "Combine balls to make 10!",
      position: Vector2(400, 200), // Adjust position for alignment
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 214, 193, 193),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    add(VolumeDisplay()..position = Vector2(700, 70));

    print("isMounted: $isMounted");

    super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    print("onMount called for NumberLineComponent");
  }

  @override
  void onDragUpdate(fl_events.DragUpdateEvent event) {
    _rotateCannonTo(
        Vector2(event.localEndPosition.x, event.localEndPosition.y));
    super.onDragUpdate(event);
  }

  void moveBalls(double dt) {
    game.totalDistance += dt * 6; // Accumulate the total distance moved
    if (game.totalDistance > game.numberOfBallsAdded * ballSpacing) {
      // Add a new ball
      final ball =
          NumberBall(number: Random().nextInt(9) + 1, isNextBall: false)
            ..anchor = Anchor.center
            ..radius = 20
            ..position = Vector2(50, 50)
            ..isVisible = false;
      game.world.add(ball);
      game.balls.insert(0, ball);
      ball.isVisible = false;
      game.numberOfBallsAdded++;
    }
    for (int i = 0; i < game.balls.length; i++) {
      Offset? ballPosition = game.gamePath.getPositionAtDistance(
          ((i - game.numberOfBallsAdded + 1) * ballSpacing) +
              game.totalDistance);
      if (ballPosition == null) {
        game.world.remove(game.balls[i]);
        game.balls.removeAt(i);
        game.router.pushNamed('game-over');
        game.paused = true;
        continue;
      }
      game.balls[i].position = Vector2(ballPosition.dx, ballPosition.dy);
      game.balls[i].isVisible = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    moveBalls(dt);
  }

  @override
  void onPointerMove(fl_events.PointerMoveEvent event) {
    super.onPointerMove(event);
    _rotateCannonTo(Vector2(event.localPosition.x, event.localPosition.y));
  }

  void _rotateCannonTo(Vector2 targetPosition) {
    final direction = targetPosition - cannon.position;

    double angleRadians = atan2(direction.y, direction.x);
    cannon.angle = angleRadians;
  }

  @override
  void onTapUp(fl_events.TapUpEvent event) {
    super.onTapUp(event);
    _rotateCannonTo(Vector2(event.localPosition.x, event.localPosition.y));
    _shoot(Vector2(cos(cannon.angle), sin(cannon.angle)));
  }

  void _shoot(Vector2 direction) {
    cannon.shoot(direction, 100); // Call cannon's shoot method
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.x, size.y),
    //   Paint()..color = const Color.fromARGB(255, 218, 107, 107),
    // );
    super.render(canvas);
  }
}
