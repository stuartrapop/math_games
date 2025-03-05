import 'dart:async';

import 'package:first_math/geometric_suite/common/components/animated_sprite.dart';
import 'package:first_math/geometric_suite/common/components/frame/frame.dart';
import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/common/components/frame/next_button.dart';
import 'package:first_math/geometric_suite/common/components/trophies.dart';
import 'package:first_math/geometric_suite/common/utils/sprite_utils.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/shape_tracer/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/shape_tracer/components/draggable_grid_component.dart';
import 'package:first_math/geometric_suite/shape_tracer/data/questions.dart';
import 'package:first_math/geometric_suite/shape_tracer/shape_tracer_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class ShapeTracerWorld extends World with HasGameRef<ShapeTracerGame> {
  final Function returnHome;
  late final GameBloc gameBloc;
  late final GridComponent questionGrid;
  late final GridComponent answerGrid;
  int targetPolygonIndices = -1;
  int activePolygonIndex = -1;
  late List<InterfaceClickableShape> polygons;
  late List<Vector2> positions;

  ShapeTracerWorld({required this.returnHome}) : super() {
    answerGrid = GridComponent(gridSize: 35, rows: 8, cols: 14, lineWidth: 2)
      ..position = Vector2(250, 100);
    questionGrid =
        DraggableGridComponent(gridSize: 35, rows: 8, cols: 14, lineWidth: 2)
          ..position = Vector2(250, 400);
  }
  bool showReplay = false;
  late StreamSubscription suiteSubscription;

  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 12, 12, 211);

  late TextComponent valueText;
  late Vector2 worldCenter;

  @override
  FutureOr<void> onLoad() async {
    worldCenter = gameRef.size / 2;

    gameBloc = gameRef.gameBloc; // Get the Bloc from the game
    print("Loading ShapeTracer World: ${gameBloc.state}");

    double borderWidth = 30;

    updateQuestion(gameBloc.state);
    void overrideReturnHome() {
      print("Overriding return home");
      gameRef.router.pushReplacementOverlay('menu');
    }

    void giveHint() async {
      print("Give Hint");

      (questionGrid as DraggableGridComponent).demoMoveTo();
    }

    final frame = Frame<ShapeTracerGame>(
      borderWidth: borderWidth,
      returnHome: overrideReturnHome,
      giveHint: giveHint,
      previous: () {
        gameBloc.add(
          NextQuestion(nextIndex: gameBloc.state.currentQuestionIndex - 1),
        );
        for (final child in children.whereType<TrophyComponent>().toList()) {
          remove(child);
        }
      },
      validate: () {
        for (final child in children.toList()) {
          if (child is AnimatedSprite) {
            remove(child);
          }
        }
        bool isSolution = (questionGrid as DraggableGridComponent).isSolution();
        if (isSolution) {
          AnimatedSprite hearts =
              AnimatedSprite(spriteName: SpriteName.blueCoin)
                ..size = Vector2(175, 175)
                ..position = Vector2(75, 200);
          NextButtonComponent nextButton = NextButtonComponent(
            onNextPressed: () {
              print("Next Question");
              gameBloc.add(
                NextQuestion(
                    nextIndex: gameBloc.state.currentQuestionIndex + 1),
              );
            },
          )
            ..size = Vector2(75, 75)
            ..isVisible = true;
          add(hearts);
          gameBloc.add(QuestionAnswered(
            questionIndex: gameBloc.state.currentQuestionIndex,
            isCorrect: true,
          ));
          if (gameBloc.state.currentQuestionIndex == questionData.length - 1) {
            add(TrophyComponent(trophySize: 150));
            print("Game Over");
            return;
          } else {
            add(nextButton);
          }
        } else {
          AnimatedSprite frogs = AnimatedSprite(spriteName: SpriteName.frogs)
            ..size = Vector2(175, 175)
            ..position = Vector2(75, 200);
          gameBloc.add(QuestionAnswered(
            questionIndex: gameBloc.state.currentQuestionIndex,
            isCorrect: false,
          ));
          add(frogs);
        }
      },
    )
      ..position = Vector2(borderWidth, borderWidth)
      ..anchor = Anchor.topLeft;
    add(frame);
    add(questionGrid);
    add(answerGrid);

    int? lastQuestionIndex = gameBloc.state.currentQuestionIndex;
    gameBloc.stream.listen((state) async {
      print("state updated: $state");
      if (lastQuestionIndex == state.currentQuestionIndex) {
        print("No change in question index, skipping update.");
        return;
      }
      lastQuestionIndex = state.currentQuestionIndex; // Update last seen index

      if (state.currentQuestionIndex == questionData.length) {
        add(TrophyComponent(trophySize: 150));
        print("Game Over");
        return;
      } else {
        for (final child in children.whereType<TrophyComponent>().toList()) {
          remove(child);
        }
      }
      print("state updated: $state");

      for (final child in children.whereType<AnimatedSprite>().toList()) {
        remove(child);
      }
      for (final child in children.whereType<NextButtonComponent>().toList()) {
        print("removing next button");
        remove(child);
      }
      Future.delayed(Duration(milliseconds: 10), () {
        updateQuestion(state);
      });
    });
    return super.onLoad();
  }

  void removePolygons() {
    print("🗑 Removing existing polygons...");
    gameRef.tracedLines = [];
    final questionPolygons =
        questionGrid.children.whereType<InterfaceClickableShape>().toList();
    final answerPolygons =
        answerGrid.children.whereType<InterfaceClickableShape>().toList();

    for (final poly in questionPolygons) {
      questionGrid.remove(poly);
    }

    for (final poly in answerPolygons) {
      answerGrid.remove(poly);
    }

    print("✅ Removed ${questionPolygons.length} from Question Grid");
    print("✅ Removed ${answerPolygons.length} from Answer Grid");
  }

  void updateQuestion(GameState state) {
    removePolygons();
    QuestionData questionData = state.questionList[state.currentQuestionIndex];

    polygons = questionData.polygons;
    positions = questionData.positions;

    for (int i = 0; i < polygons.length; i++) {
      InterfaceClickableShape poly = polygons[i].copyWith(
        pixelToUnitRatio: 35,
        upperLeftPosition: positions[i],
        updateActivePolygonIndex: null,
        borderWidth: 4,
        polygonIndex: i,
        color: polygons[i].color,
      )..isTapped = true;
      answerGrid.add(poly);
      InterfaceClickableShape poly2 = polygons[i].copyWith(
        pixelToUnitRatio: 35,
        upperLeftPosition: positions[i],
        updateActivePolygonIndex: null,
        borderWidth: 1,
        polygonIndex: i,
        color: polygons[i].color,
        isSolid: false,
      )..isTapped = true;
      answerGrid.add(poly);
      questionGrid.add(poly2);
    }
  }

  bool allTrue(List<bool> list) {
    return list.every((element) => element);
  }

  void onStateChange(GameState state) {
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

  void gameReset() {
    print("Game Reset");
  }

  @override
  void onRemove() {
    suiteSubscription.cancel();
    super.onRemove();
  }
}
