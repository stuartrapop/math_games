import 'dart:async';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/five_across/five_accross_world.dart';
import 'package:first_math/five_across/game_over.dart';
import 'package:first_math/five_across/menu.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiveAccrossContainer extends StatelessWidget {
  final Function returnHome;
  const FiveAccrossContainer({super.key, required this.returnHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OperationsBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: FiveAcrossGame(
              operationsBloc: BlocProvider.of<OperationsBloc>(context),
              returnHome: returnHome,
            ),
          );
        },
      ),
    );
  }
}

//
// The game class
class FiveAcrossGame extends fl_game.FlameGame
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
  final OperationsBloc operationsBloc;
  final Function returnHome;

  FiveAcrossGame({
    required this.operationsBloc,
    required this.returnHome,
  }) : super();
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
    camera = CameraComponent.withFixedResolution(
      width: 600,
      height: 900,
      world: world,
    )..moveTo(Vector2(300, 450));

    router = fl_game.RouterComponent(
      routes: {
        'five-accross-game': fl_game.WorldRoute(
          () {
            return FiveAccrossWorld(
              operationsBloc: operationsBloc,
              returnHome: returnHome,
            );
          },
        ),
        'game-over': fl_game.OverlayRoute(
          (context, game) {
            return GameOver(
              router: router,
              operationsBloc: operationsBloc,
              game: game as FiveAcrossGame,
              returnHome: returnHome,
            );
          },
        ),
        'menu': fl_game.OverlayRoute(
          (context, game) {
            return Menu(
              router: router,
              operationsBloc: operationsBloc,
              game: game as FiveAcrossGame,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'menu',
    );

    add(router);

    print(
        "MatchGame added to MatchWorld. Children of MatchWorld: ${world.children.toList()}");
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
}
