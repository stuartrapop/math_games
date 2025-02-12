import 'dart:async';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/components/animated_sprite.dart';
import 'package:first_math/suite/components/frame/frame.dart';
import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:first_math/suite/utils/sprite_utils.dart';
import 'package:first_math/suite/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class SuiteWorld extends World with HasGameRef<SuiteGame> {
  final Function returnHome;
  late final SuiteBloc suiteBloc;
  SuiteWorld({required this.returnHome}) : super();
  bool showReplay = false;
  late StreamSubscription suiteSubscription;
  GridComponent answerGrid = GridComponent(
    gridSize: 35,
    rows: 8,
    cols: 14,
    lineWidth: 2,
  )..position = Vector2(250, 100);

  GridComponent questionGrid = GridComponent(
    gridSize: 35,
    rows: 8,
    cols: 14,
    lineWidth: 2,
  )..position = Vector2(250, 400);

  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 12, 12, 211);

  late TextComponent valueText;
  late Vector2 worldCenter;

  @override
  FutureOr<void> onLoad() async {
    worldCenter = gameRef.size / 2;

    suiteBloc = gameRef.suiteBloc; // Get the Bloc from the game
    print("Loading Suite World: ${suiteBloc.state}");

    double borderWidth = 30;

    final frame = Frame(
      borderWidth: borderWidth,
      returnHome: returnHome,
      validate: () {
        bool isSolution = comparePolygons(
          questions: questionData[suiteBloc.state.currentQuestionIndex].objects,
          answerPositions: suiteBloc
              .state.answerPositions[suiteBloc.state.currentQuestionIndex],
          questionPositions: suiteBloc.state
              .currentQuestionPositions[suiteBloc.state.currentQuestionIndex],
        );
        print("isSolution: $isSolution");
        if (isSolution) {
          AnimatedSprite hearts = AnimatedSprite(spriteName: SpriteName.hearts)
            ..size = Vector2(400, 400)
            ..position = Vector2(300, 200);

          add(hearts);
          suiteBloc.add(QuestionAnswered(
            questionIndex: suiteBloc.state.currentQuestionIndex,
            isCorrect: true,
          ));
        } else {
          AnimatedSprite frogs = AnimatedSprite(spriteName: SpriteName.frogs)
            ..size = Vector2(400, 400)
            ..position = Vector2(300, 200);
          suiteBloc.add(QuestionAnswered(
            questionIndex: suiteBloc.state.currentQuestionIndex,
            isCorrect: false,
          ));
          add(frogs);
        }
      },
    )
      ..position = Vector2(borderWidth, borderWidth)
      ..anchor = Anchor.topLeft;
    add(frame);

    add(answerGrid);

    add(questionGrid);

    // print("Setting up initial game state");
    // await setupInitialState();

    updatePolygons();

    return super.onLoad();
  }

  bool allTrue(List<bool> list) {
    return list.every((element) => element);
  }

  void onStateChange(SuiteState state) {
    print("State Updated: $state");
    // removePolygons();
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, 1000, 800),
    //   fillBlue,
    // );
    super.render(canvas);
  }

  void removePolygons() {
    for (final child in children.toList()) {
      if (child is SnappablePolygon) {
        remove(child);
      }
    }
  }

  void updatePolygons() {
    removePolygons();

    questionGrid.addAll(getSnappablePolygonsFromQuestion(
      questionData: questionData[suiteBloc.state.currentQuestionIndex],
      positions: suiteBloc
          .state.currentQuestionPositions[suiteBloc.state.currentQuestionIndex],
      questionIndex: suiteBloc.state.currentQuestionIndex,
      grid: questionGrid,
    ));
    answerGrid.addAll(getSnappablePolygonsFromQuestion(
      questionData: questionData[suiteBloc.state.currentQuestionIndex],
      positions:
          suiteBloc.state.answerPositions[suiteBloc.state.currentQuestionIndex],
      questionIndex: suiteBloc.state.currentQuestionIndex,
      grid: answerGrid,
    ));
  }

  void gameReset() {
    removePolygons();
  }

  @override
  void onRemove() {
    suiteSubscription.cancel();
    super.onRemove();
  }
}
