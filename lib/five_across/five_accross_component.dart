import 'dart:async';

import 'package:first_math/components/home_position_component.dart';
import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/five_across/board.dart';
import 'package:first_math/five_across/five_accross_game.dart';
import 'package:first_math/five_across/left_box.dart';
import 'package:first_math/five_across/utils/helper.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class FiveAccrossComponent extends PositionComponent
    with HasGameRef<FiveAcrossGame> {
  OperationsBloc operationsBloc;
  final Function returnHome;

  FiveAccrossComponent({
    required this.operationsBloc,
    required this.returnHome,
  }) : super() {}
  late LeftBox leftBox;
  late Board board;
  late int questionIndex;

  @override
  FutureOr<void> onLoad() {
    print("FiveAccrossComponent onLoad");
    TextComponent text = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text: "Reponds aux questions pour faire 5 en ligne",
    )
      ..anchor = Anchor.topCenter // Anchor set to the top center
      ..position =
          Vector2(325, 50); // Position centered horizontally at the top

    add(text);
    add(HomePositionComponent(game: game, returnHome: returnHome)
      ..position = Vector2(50, 50)
      ..size = Vector2(50, 50));

    add(FlameBlocListener<OperationsBloc, OperationsState>(
      bloc: operationsBloc,
      onInitialState: (state) {
        updateComponent();
        print("initial ");
      },
      onNewState: (state) {
        print("new state ");
        updateComponent();
      },
    ));

    return super.onLoad();
  }

  void updateComponent() {
    List<Question> unansweredQuestions = getFilteredUnansweredQuestions(
      operationsBloc.state.questions,
      operationsBloc.state.boardValues,
    );
    unansweredQuestions.shuffle();
    children.whereType<LeftBox>().forEach(remove);
    if (unansweredQuestions.isEmpty) {
      gameRef.router.pushOverlay('game-over');
    }
    if (hasWon(boardValues: operationsBloc.state.boardValues)) {
      gameRef.router.pushOverlay('game-over');
    }

    leftBox = LeftBox(
      operationsBloc: operationsBloc,
      questionIndex: unansweredQuestions.isEmpty
          ? -1
          : unansweredQuestions[0].questionNumber,
    )
      ..position = Vector2(50, 150)
      ..size = Vector2(200, 200);
    add(leftBox);
    children.whereType<Board>().forEach(remove);
    board = Board(
      operationsBloc: operationsBloc,
      questionIndex: unansweredQuestions.isEmpty
          ? -1
          : unansweredQuestions[0].questionNumber,
    )
      ..position = Vector2(75, 400)
      ..size = Vector2(400, 400);
    add(board);
  }

  // Bounds check
}
