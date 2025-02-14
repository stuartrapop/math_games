import 'dart:async';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/menu.dart';
import 'package:first_math/suite/suite_world.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide OverlayRoute, Route;

//
//
// The game class
class SuiteGame extends FlameGame
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
  final SuiteBloc suiteBloc;
  final Function returnHome;
  late final SuiteWorld suiteWorld;

  SuiteGame({
    required this.suiteBloc,
    required this.returnHome,
  }) : super() {
    suiteWorld =
        SuiteWorld(returnHome: returnHome); // ✅ Only create one instance
  }
  bool running = true;
  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
  @override
  // runnig in debug mode
  bool debugMode = false;
  //
  late final RouterComponent router;
  List<PositionComponent> components = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set up the initial screen layout
    // suiteWorld = SuiteWorld(returnHome: returnHome);
    world = suiteWorld;

    // ✅ Make sure it's visible
    // add(suiteWorld);

    camera = CameraComponent.withFixedResolution(
      width: 1000,
      height: 800,
      world: world,
      viewfinder: Viewfinder(),
    )
      ..moveTo(
        Vector2(500, 400),
      )
      ..viewfinder.zoom = 1.0;

    router = RouterComponent(
      routes: {
        'suite-game': WorldRoute(
          () => suiteWorld,
        ),
        'menu': OverlayRoute(
          (context, game) {
            return Menu(
              router: router,
              bloc: suiteBloc,
              game: game as SuiteGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'suite-game',
    );

    add(router);

    world.add(FpsTextComponent());
    camera.viewfinder.zoom = 1.0;

    print(
        "SuiteGame added to CeriseWord. Children of CeriseWord: ${children.toList()}");
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);

  //   // ✅ Check Camera Position
  //   print("Camera position: ${camera.viewfinder.position}");

  //   // ✅ Check World Position
  //   if (world != null) {
  //     print("World position: ${world.toString()}");
  //   }
  // }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.x, size.y),
    //   fillRed,
    // );
    super.render(canvas);
  }
}
