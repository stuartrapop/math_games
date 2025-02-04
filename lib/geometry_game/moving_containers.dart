import 'dart:async';

import 'package:first_math/components/frame.dart';
import 'package:first_math/geometry_game/bottomLineContainer.dart';
import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:first_math/geometry_game/roundPhysicsContainer.dart';
import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:first_math/utils/constants.dart';
import 'package:first_math/utils/create_shapes.dart';
import 'package:first_math/utils/shapes.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart' as fl_comp;
import 'package:flame/game.dart' as fl_game;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MovingContainers extends fl_comp.Component
    with fl_comp.HasGameRef<GeometryGame> {
  Color backgroundColor() => const Color.fromARGB(255, 218, 107, 107);
  double radius = 60.0;
  double borderWidth = 15.0;
  Forge2DWorld myWorld;
  Function returnHome;
  MovingContainers({
    required this.returnHome,
    required this.router,
    required this.myWorld,
  }) : super();
  final Vector2 worldSize = Vector2(600, 900);
  List<fl_comp.Component> components = [];
  final fl_game.RouterComponent router;
  Future<void> setupScreen() async {
    components.clear();
    final frame = Frame(
      borderWidth: borderWidth,
      router: router,
      returnHome: returnHome,
    )..position = Vector2(400, 300);
    components.add(frame);
    for (int i = 3; i < 7; i++) {
      final newGeometry = RoundPhysicsContainer(
        positionSeries: polygonShapes[i]!,
        label: (i).toString(),
        rotateSpeed: 2,
        radius: radius,
        yAxisRotateSpeed: 0,
        initialPosition: Vector2((i - 3) * (radius * 2 - 5) + radius, 200),
      );

      components.add(newGeometry);
    }
    components.add(
      BottomLineContainer(label: 'Bottom', height: 5, width: 600),
    );
    final lShapeGeometry = RoundPhysicsContainer(
      positionSeries: polygonShapes['lShape']!,
      label: 'L',
      rotateSpeed: 0,
      radius: radius,
      yAxisRotateSpeed: 0,
      initialPosition: Vector2(400, 400),
    );
    components.add(lShapeGeometry);

    final fivePointStart = RoundPhysicsContainer(
      positionSeries: pointedStar(sides: 5, outerSize: 1, innerSize: 0.65),
      label: 'S',
      rotateSpeed: 3,
      yAxisRotateSpeed: 0,
      radius: radius,
      initialPosition: Vector2(400, 400),
    );
    components.add(fivePointStart);
    final asteroid = RoundPhysicsContainer(
      positionSeries: polygonShapes['asteroid']!,
      label: 'A',
      rotateSpeed: 0.5,
      yAxisRotateSpeed: 0,
      radius: radius,
      initialPosition: Vector2(400, 400),
    );
    components.add(asteroid);
    await myWorld.add(
      FlameBlocProvider<MatchStatsBloc, MatchStatsState>(
        create: () => MatchStatsBloc(),
        children: components,
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    // Set up the initial screen layout
    print("gameRef $gameRef");
    // Add a red background
    maxTranslation = 20.0; // Adjust this to your requirement
    await setupScreen();
    printComponentTree(this);
    print("Current Route: ${router.currentRoute}");
    print("Active Overlays: ${gameRef.overlays.activeOverlays}");
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    canvas.drawRect(
      Rect.fromLTWH(
        0, // Align with camera's center
        0, // Align with camera's center
        worldSize.x,
        worldSize.y,
      ),
      fillBlack,
    );

    super.render(canvas);
  }
}
