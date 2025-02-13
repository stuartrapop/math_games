import 'dart:async';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/components/animated_sprite.dart';
import 'package:first_math/suite/components/frame/frame.dart';
import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/next_button.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/components/trophies.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:first_math/suite/utils/check_collision_polygon.dart';
import 'package:first_math/suite/utils/merge_polygons.dart';
import 'package:first_math/suite/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class SuiteWorld extends World with HasGameRef<SuiteGame> {
  final Function returnHome;
  late final SuiteBloc suiteBloc;
  late final GridComponent answerGrid;
  late final GridComponent questionGrid;
  SuiteWorld({required this.returnHome}) : super() {
    // 🔹 Initialize grids ONCE and reuse them
    answerGrid = GridComponent(gridSize: 35, rows: 8, cols: 14, lineWidth: 2)
      ..position = Vector2(250, 100);
    questionGrid = GridComponent(gridSize: 35, rows: 8, cols: 14, lineWidth: 2)
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

    suiteBloc = gameRef.suiteBloc; // Get the Bloc from the game
    print("Loading Suite World: ${suiteBloc.state}");

    double borderWidth = 30;

    void overrideReturnHome() {
      print("Overriding return home");
      gameRef.router.pushReplacementOverlay('menu');
    }

    void giveHint() async {
      print("Give Hint");
      bool moveShown = false;

      for (var component in questionGrid.children) {
        if (component is SnappablePolygon) {
          Vector2 testGridPoint = suiteBloc
                  .state.answerPositions[suiteBloc.state.currentQuestionIndex]
              [component.polygonIndex];
          print("Test Grid Point:  $testGridPoint");
          print(
              "Component Upper Left Position:  ${component.upperLeftPosition}");
          final List<SnappablePolygon> polygonList =
              questionGrid.children.whereType<SnappablePolygon>().toList();
          SnappablePolygon testPolygon =
              component.copyWith(upperLeftPosition: testGridPoint);
          bool canMove = true;
          for (var polygon in polygonList) {
            if (polygon != component) {
              if (checkOverlap(testPolygon, polygon)) {
                canMove = false;
                break;
              }
            }
          }
          if (canMove) {
            await Future.delayed(Duration.zero);

            await component.demoMoveTo(gridPoint: testGridPoint);

            moveShown = true;
          }
        }
      }
      print("Move shown: $moveShown");
    }

    final frame = Frame(
      borderWidth: borderWidth,
      returnHome: overrideReturnHome,
      giveHint: giveHint,
      previous: () {
        print("Previous Question");
        suiteBloc.add(
          NextQuestion(nextIndex: suiteBloc.state.currentQuestionIndex - 1),
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
        final allPolygons =
            questionGrid.children.whereType<SnappablePolygon>().toList();

        bool isSolution = compareGrids(
          grid: questionGrid,
          questions: allPolygons,
          questionPositions: suiteBloc.state
              .currentQuestionPositions[suiteBloc.state.currentQuestionIndex],
          answerPositions: suiteBloc
              .state.answerPositions[suiteBloc.state.currentQuestionIndex],
          tolerance: 0.05,
        );

        if (isSolution) {
          AnimatedSprite hearts = AnimatedSprite(spriteName: SpriteName.hearts)
            ..size = Vector2(175, 175)
            ..position = Vector2(75, 200);
          NextButtonComponent nextButton = NextButtonComponent(
            onNextPressed: () {
              print("Next Question");
              suiteBloc.add(
                NextQuestion(
                    nextIndex: suiteBloc.state.currentQuestionIndex + 1),
              );
            },
          )
            ..size = Vector2(75, 75)
            ..isVisible = true;
          add(hearts);

          suiteBloc.add(QuestionAnswered(
            questionIndex: suiteBloc.state.currentQuestionIndex,
            isCorrect: true,
          ));
          if (suiteBloc.state.currentQuestionIndex == questionData.length - 1) {
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
    suiteBloc.stream.listen((state) async {
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
        updatePolygons(state);
      });
    });
    await updatePolygons(suiteBloc.state);
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
    print("🗑 Removing existing polygons...");

    final questionPolygons =
        questionGrid.children.whereType<SnappablePolygon>().toList();
    final answerPolygons =
        answerGrid.children.whereType<SnappablePolygon>().toList();

    for (final poly in questionPolygons) {
      questionGrid.remove(poly);
    }

    for (final poly in answerPolygons) {
      answerGrid.remove(poly);
    }

    print("✅ Removed ${questionPolygons.length} from Question Grid");
    print("✅ Removed ${answerPolygons.length} from Answer Grid");
  }

  Future<void> updatePolygons(SuiteState state) async {
    removePolygons();
    // await Future.delayed(const Duration(milliseconds: 10));
    print(
        "🔍 Before Adding: Question Grid has ${questionGrid.children.whereType<SnappablePolygon>().length} polygons");
    print(
        "🔍 Before Adding: Answer Grid has ${answerGrid.children.whereType<SnappablePolygon>().length} polygons");
    print(
        "polygons questions ${state.currentQuestionPositions[state.currentQuestionIndex]}");

    questionGrid.addAll(getSnappablePolygonsFromQuestion(
      questionData: questionData[state.currentQuestionIndex],
      positions: state.currentQuestionPositions[state.currentQuestionIndex],
      questionIndex: state.currentQuestionIndex,
      grid: questionGrid,
    ));
    print(
        "polygons answers ${state.answerPositions[state.currentQuestionIndex]}");

    answerGrid.addAll(getSnappablePolygonsFromQuestion(
      questionData: questionData[state.currentQuestionIndex],
      positions: state.answerPositions[state.currentQuestionIndex],
      questionIndex: state.currentQuestionIndex,
      grid: answerGrid,
    ));

    print(
        "🔍 After Adding: Question Grid has ${questionGrid.children.whereType<SnappablePolygon>().length} polygons");
    print(
        "🔍 After Adding: Answer Grid has ${answerGrid.children.whereType<SnappablePolygon>().length} polygons");
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
