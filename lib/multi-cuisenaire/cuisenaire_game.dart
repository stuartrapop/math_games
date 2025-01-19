import 'dart:async';

import 'package:first_math/multi-cuisenaire/bloc/cuisenaire_bloc.dart';
import 'package:first_math/multi-cuisenaire/cuisenaire_component.dart';
import 'package:first_math/multi-cuisenaire/cuisenaire_world.dart';
import 'package:first_math/multi-cuisenaire/game_over.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' as fl_game;
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

//
//
// The game class
class Cuisenaire extends fl_game.FlameGame
    with
        DoubleTapDetector,
        TapDetector,
        HasGameRef,
        HasCollisionDetection,
        LongPressDetector {
  static const description = '''
        La méthode Cuisenaire est une méthode inventée par Georges Cuisenaire en 1945, qui permet d’aborder les quantités et d’apprendre à calculer (de l’addition aux multiplications, divisions, fractions, puissances !) en s’appuyant sur des réglettes de couleurs et de longueurs différentes, de 1 à 10.
      ''';
  final Function returnHome;
  Cuisenaire({required this.returnHome}) : super();
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
    world = CuisenaireWorld();
    camera = CameraComponent.withFixedResolution(
      width: 1000,
      height: 900,
      world: world,
    )..moveTo(Vector2(500, 450));

    router = fl_game.RouterComponent(
      routes: {
        'cuisenaire-game': fl_game.Route(
          () => CuisenaireComponent(
              world: world, router: router, returnHome: returnHome),
        ),
        'game-over': fl_game.OverlayRoute(
          (context, game) {
            return GameOver(
              router: router,
              game: game as Cuisenaire,
              returnHome: returnHome,
            );
          },
        ),
      },
      initialRoute: 'game-over',
    );

    final provider = FlameBlocProvider<CuisenaireBloc, CuisenaireState>(
      create: () => CuisenaireBloc(),
      children: [
        router, // The existing world
      ],
    );
    world.add(provider);
  }

  @override
  void onRemove() {
    // Optional based on your game needs.
    // removeAll(children);
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
