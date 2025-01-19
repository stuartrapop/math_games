import 'dart:async';

import 'package:first_math/components/home_position_component.dart';
import 'package:first_math/multi-cuisenaire/bloc/cuisenaire_bloc.dart';
import 'package:first_math/multi-cuisenaire/board.dart';
import 'package:first_math/multi-cuisenaire/refactor_button.dart';
import 'package:first_math/multi-cuisenaire/reglette.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class CuisenaireComponent extends PositionComponent
    with
        DragCallbacks,
        HasGameRef,
        FlameBlocReader<CuisenaireBloc, CuisenaireState> {
  final World world;
  RouterComponent router;
  late Board leftBoard;
  late Board rightBoard;
  final Function returnHome;

  CuisenaireComponent({
    required this.world,
    required this.router,
    required this.returnHome,
  }) : super() {
    router = router;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(HomePositionComponent(game: game, returnHome: returnHome)
      ..position = Vector2(50, 50)
      ..size = Vector2(50, 50));
    for (int i = 1; i <= 10; i++) {
      final reglette =
          Reglette(value: i, startRow: -1, startColumn: -1, isHorizontal: true)
            ..position = Vector2(100, 13 + i * 37.0)
            ..size = Vector2(i * 35.0, 35);
      add(reglette);
    }

    leftBoard = Board(isLeft: true)
      ..position = Vector2(100, 475)
      ..size = Vector2(350, 350);
    add(leftBoard);
    rightBoard = Board(isLeft: false)
      ..position = Vector2(600, 475)
      ..size = Vector2(350, 350);
    add(rightBoard);
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF000000),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    add(TextComponent(
      text: "Refactoriser horizontalement",
      position: Vector2(545, 80), // Adjust position for alignment
      anchor: Anchor.centerLeft,
      textRenderer: textPaint,
    ));
    for (int i = 1; i <= 10; i++) {
      add(RefactorButton(value: i, isHorizontal: true)
        ..position = Vector2(500 + i * 45, 100)
        ..size = Vector2(40, 40));
    }
    add(TextComponent(
      text: "Refactoriser verticalement",
      position: Vector2(545, 180), // Adjust position for alignment
      anchor: Anchor.centerLeft,
      textRenderer: textPaint,
    ));
    for (int i = 1; i <= 10; i++) {
      add(RefactorButton(value: i, isHorizontal: false)
        ..position = Vector2(500 + i * 45, 200)
        ..size = Vector2(40, 40));
    }

    return super.onLoad();
  }
}
