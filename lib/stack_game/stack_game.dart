import 'dart:async';

import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/stack_game/mathColumn.dart';
import 'package:first_math/stack_game/stack_game_component.dart';
import 'package:first_math/stack_game/stack_game_over.dart';
import 'package:first_math/stack_game/stack_world.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class StackGame extends fl_game.FlameGame
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
  final GameStatsBloc gameStatsBloc;
  final Function returnHome;

  StackGame({
    required this.gameStatsBloc,
    required this.returnHome,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 900,
            viewfinder: Viewfinder(),
          )
            ..moveTo(Vector2(300, 450))
            ..viewfinder.zoom = 1.0,
        );
  bool running = true;
  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
  @override
  // runnig in debug mode
  bool debugMode = false;
  //
  late final fl_game.RouterComponent router;
  List<PositionComponent> components = [];
  final List<MathColumn> columns = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set up the initial screen layout
    world = StackWorld();
    camera = CameraComponent.withFixedResolution(
      width: 600,
      height: 900,
      world: world,
    )..moveTo(Vector2(400, 300));

    router = fl_game.RouterComponent(
      routes: {
        'stack-game': fl_game.Route(
          () => StackGameComponent(
              world: world, gameStatsBloc: gameStatsBloc, router: router),
        ),
        'game-over': fl_game.OverlayRoute(
          (context, game) {
            return StackGameOver(
              router: router,
              gameStatsBloc: gameStatsBloc,
              game: game as StackGame,
            );
          },
        ),
      },
      initialRoute: 'game-over',
    );

    add(router);

    print(
        "StackGame added to StackWorld. Children of StackWorld: ${world.children.toList()}");
  }

  @override
  void onRemove() {
    // Optional based on your game needs.
    removeAll(children);
    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();
    // Any other code that you want to run when the game is removed.
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
