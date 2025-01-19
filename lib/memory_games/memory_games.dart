import 'dart:async';

import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/game_over.dart';
import 'package:first_math/stack_game/experiment_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class MemoryGames extends fl_game.FlameGame
    with
        DoubleTapDetector,
        TapDetector,
        HasGameRef,
        HasCollisionDetection,
        LongPressDetector {
  static const description = '''
        Creation of set of stacked blocks where the number of blocks in each stack represent the number of digits in a number.
      ''';

  //
  // controls if the engine is paused or not
  final MemoryMatchBloc memoryMatchBloc;
  final Function returnHome;

  MemoryGames({required this.memoryMatchBloc, required this.returnHome})
      : super();
  bool running = true;
  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
  @override
  // runnig in debug mode
  bool debugMode = false;
  //
  late final fl_game.RouterComponent router;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set up the initial screen layout

    camera = CameraComponent.withFixedResolution(
      width: 600,
      height: 900,
      world: world,
    )..moveTo(Vector2(300, 450));

    router = fl_game.RouterComponent(
      routes: {
        'match-game': fl_game.WorldRoute(() => ExperimentWorld(
              returnHome: returnHome,
              memoryMatchBloc: memoryMatchBloc,
            )),
        'game-over': fl_game.OverlayRoute(
          (context, game) {
            return GameOver(
              onGoGame: () {
                game.overlays.remove('game-over');
                router.pushNamed('match-game');
              },
              returnHome: returnHome,
              memoryMatchBloc: memoryMatchBloc,
              game: game as MemoryGames,
            );
          },
        ),
      },
      initialRoute: 'game-over',
    );

    add(router);
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.x, size.y),
    //   fillRed,
    // );
    super.render(canvas);
  }
}
