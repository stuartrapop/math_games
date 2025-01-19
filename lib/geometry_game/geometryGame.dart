import 'dart:async';

import 'package:first_math/bloc/match_stats_bloc.dart';
import 'package:first_math/geometry_game/menu.dart';
import 'package:first_math/geometry_game/moving_containers.dart';
import 'package:first_math/geometry_game/my_world.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GeometryGame extends Forge2DGame
    with DoubleTapDetector, TapDetector, LongPressDetector {
  static const description = '''
        Creation of set of stacked blocks where the number of blocks in each stack represent the number of digits in a number.
      ''';

  //
  // controls if the engine is paused or not
  final MatchStatsBloc matchStatsBloc;

  GeometryGame({
    required this.matchStatsBloc,
    required this.returnHome,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 900,
            viewfinder: Viewfinder(),
          )
            ..moveTo(Vector2(300, 450))
            ..viewfinder.zoom = 1.0,
          gravity: Vector2(0, 9.8),
        );
  Function returnHome;

  late final fl_game.RouterComponent router;
  bool running = true;
  @override
  // runnig in debug mode
  bool debugMode = false;

  // Add initial loading and sizing
  @override
  Future<void> onLoad() async {
    // Set up the initial screen layout
    world = MyWorld(matchStatsBloc: matchStatsBloc);
    super.onLoad();
    camera = CameraComponent.withFixedResolution(
      width: 600,
      height: 900,
      world: world,
    )
      ..moveTo(Vector2(300, 450))
      ..viewfinder.zoom = 1.0;

    router = fl_game.RouterComponent(
      routes: {
        'moving-containers': fl_game.Route(
          () => MovingContainers(
            router: router,
            myWorld: world,
            returnHome: returnHome,
          ),
        ),
        'home': fl_game.OverlayRoute(
          (context, game) {
            return Menu(
              router: router,
              game: game as GeometryGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'home',
    );

    add(router);

    printComponentTree(this);
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
