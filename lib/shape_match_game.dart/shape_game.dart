import 'dart:async';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/shape_match_game.dart/shape_match_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class ShapeMatchGame extends fl_game.FlameGame
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
  OperationsBloc operationsBloc;
  Function returnHome;

  ShapeMatchGame({required this.operationsBloc, required this.returnHome})
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
    )..moveTo(Vector2(400, 300));

    router = fl_game.RouterComponent(
      routes: {
        'shape-match-game': fl_game.WorldRoute(() => ShapeMatchWorld(
              operationsBloc: operationsBloc,
              returnHome: returnHome,
            )),
      },
      initialRoute: 'shape-match-game',
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
