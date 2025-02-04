import 'dart:async';

import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:first_math/cerise_game/cerise_world.dart';
import 'package:first_math/cerise_game/menu.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class CeriseGame extends fl_game.FlameGame
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
  final CeriseBloc ceriseBloc;
  final Function returnHome;

  CeriseGame({
    required this.ceriseBloc,
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
    world = CeriseWorld(
      returnHome: returnHome,
    );
    camera = CameraComponent.withFixedResolution(
      width: 1000,
      height: 800,
      viewfinder: Viewfinder(),
    )..moveTo(Vector2(500, 400));

    router = fl_game.RouterComponent(
      routes: {
        'cerise-game': fl_game.WorldRoute(
          () => CeriseWorld(returnHome: returnHome),
        ),
        'menu': fl_game.OverlayRoute(
          (context, game) {
            return Menu(
              router: router,
              ceriseBloc: ceriseBloc,
              game: game as CeriseGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'menu',
    );

    add(router);
    add(FpsTextComponent());

    print(
        "CeriseGame added to CeriseWord. Children of CeriseWord: ${world.children.toList()}");
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
