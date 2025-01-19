import 'dart:async';

import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/dice_game/dice.dart';
import 'package:first_math/dice_game/dividingLine.dart';
import 'package:first_math/dice_game/receptors.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class DiceGame extends FlameGame
    with DoubleTapDetector, TapDetector, HasGameRef, HasCollisionDetection {
  static const description = '''
        Creation of a simple game where there are six piles of dice and the goal is to keep adding dice until the
        target number is acheieved. There are two target areas, one to add the value of the dice and the other to subtract the value of the dice.
      ''';

  //
  // controls if the engine is paused or not
  final GameStatsBloc gameStatsBloc;
  final _imageNames = [
    ParallaxImageData('background_1.png'),
    ParallaxImageData('background_2.png'),
    ParallaxImageData('background_3.png'),
    ParallaxImageData('background_4.png'),
  ];

  DiceGame({required this.gameStatsBloc});
  bool running = true;
  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
  @override
  // runnig in debug mode
  bool debugMode = false;
  //

  double yMargin = 100;
  double xMargin = 100;
  List<PositionComponent> components = [];
  @override
  FutureOr<void> onLoad() async {
    // FlameAudio.bgm.initialize();
    // FlameAudio.bgm.play('battle-of-the-dragons-8037.mp3');
    final parallax = await loadParallaxComponent(
      _imageNames,
      baseVelocity: Vector2(4.0, 2.0),
      velocityMultiplierDelta: Vector2(1.8, -1.5),
      repeat: ImageRepeat.repeat,
    );

    for (int i = 1; i < 7; i++) {
      final originalPosition = Vector2(
        75 + 90 * ((i - 1) % 2),
        15 + (i / 2).round() * 100,
      );
      components.add(Dice(initialPosition: originalPosition.clone(), number: i)
        ..position = originalPosition
        ..size = Vector2(75, 75));
    }
    var yPosition = (gameRef.size.y - 300) / 2 + 15;
    components.add(Dividingline()..position = Vector2(220, yPosition));
    components.add(Receptors(name: 'cauldron')
      ..position = Vector2(550, 270)
      ..size = Vector2(140, 140));
    components.add(parallax);

    await add(
      FlameBlocProvider<GameStatsBloc, GameStatsState>.value(
        value: gameStatsBloc,
        children: components,
      ),
    );

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpInfo info) {
    // location of user's tap
    final touchPoint = info.eventPosition.global;

    print("<user tap> touchpoint: $touchPoint");
    final gameSize = gameRef.size;
    print("width ${gameSize.x} height ${gameSize.y}");
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
