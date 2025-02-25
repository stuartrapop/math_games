import 'dart:async';

import 'package:first_math/geometric_suite/common/types/AbstractFlameGameClass.dart';
import 'package:first_math/geometric_suite/match_polygon/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/match_polygon/match_world.dart';
import 'package:first_math/geometric_suite/match_polygon/menu.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide OverlayRoute, Route;

//
//
// The game class
class MatchGame extends GameWithFrameFeatures {
  static const description = '''
        Creation of set of stacked blocks where the number of blocks in each stack represent the number of digits in a number.
      ''';

  //
  // controls if the engine is paused or not
  final GameBloc gameBloc;
  final Function returnHome;
  late final MatchWorld matchWorld;

  MatchGame({
    required this.gameBloc,
    required this.returnHome,
  }) : super() {
    matchWorld =
        MatchWorld(returnHome: returnHome); // ✅ Only create one instance
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
    world = matchWorld;

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
        'match-game': WorldRoute(
          () => matchWorld,
        ),
        'menu': OverlayRoute(
          (context, game) {
            return Menu(
              router: router,
              bloc: gameBloc,
              game: game as MatchGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'match-game',
    );

    add(router);

    world.add(FpsTextComponent());
    camera.viewfinder.zoom = 1.0;

    print(
        "MatchGame added to CeriseWord. Children of CeriseWord: ${children.toList()}");
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
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
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
