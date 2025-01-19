import 'dart:async';

import 'package:first_math/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/diceMatch.dart';
import 'package:first_math/match_game/game_over.dart';
import 'package:first_math/match_game/match_world.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class MatchGame extends fl_game.FlameGame
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
  final MatchStatsBloc matchStatsBloc;
  final Function returnHome;

  MatchGame({
    required this.matchStatsBloc,
    required this.returnHome,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 1000,
            height: 800,
            viewfinder: Viewfinder(),
          )
            ..moveTo(Vector2(500, 400))
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

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set up the initial screen layout
    world = MatchWorld();
    camera = CameraComponent.withFixedResolution(
      width: 1000,
      height: 800,
      viewfinder: Viewfinder(),
    )..moveTo(Vector2(500, 400));

    router = fl_game.RouterComponent(
      routes: {
        'match-game': fl_game.Route(
          () => DiceMatch(
              world: world, matchStatsBloc: matchStatsBloc, router: router),
        ),
        'game-over': fl_game.OverlayRoute(
          (context, game) {
            return GameOver(
              router: router,
              matchStatsBloc: matchStatsBloc,
              game: game as MatchGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'game-over',
    );

    add(router);

    print(
        "MatchGame added to MatchWorld. Children of MatchWorld: ${world.children.toList()}");
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
