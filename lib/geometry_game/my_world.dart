import 'dart:async';

import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:flame/components.dart' as fl_comp;
import 'package:flame/game.dart' as fl_game;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MyWorld extends Forge2DWorld
    with fl_game.HasCollisionDetection, fl_comp.HasGameRef<GeometryGame> {
  final MatchStatsBloc matchStatsBloc;
  MyWorld({required this.matchStatsBloc});
  double borderWidth = 10.0;

  @override
  Future<void> onLoad() async {
    maxTranslation = 20.0; // Adjust this to your requirement

    print("camera ${gameRef.camera.viewport.position}");
    //   final boundaries = createBoundaries(
    //     iconSide: 90,
    //     borderWidth: borderWidth,
    //   );
    //   await addAll(boundaries);
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    final screenSize = gameRef.camera.viewport.size;
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, screenSize.x, screenSize.y),
    //   Paint()..color = const Color.fromARGB(255, 218, 107, 107),
    // );

    super.render(canvas);
  }
}
