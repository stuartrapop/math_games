import 'dart:async';

import 'package:first_math/geometric_suite/common/components/animated_sprite.dart';
import 'package:first_math/geometric_suite/common/components/frame/frame.dart';
import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/common/components/frame/next_button.dart';
import 'package:first_math/geometric_suite/common/components/trophies.dart';
import 'package:first_math/geometric_suite/common/utils/sprite_utils.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/rotate_polygon/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/rotate_polygon/components/frame_circle.dart';
import 'package:first_math/geometric_suite/rotate_polygon/data/questions.dart';
import 'package:first_math/geometric_suite/rotate_polygon/rotate_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class RotateWorld extends World with HasGameRef<RotateGame> {
  final Function returnHome;
  late final GameBloc gameBloc;
  late final GridComponent questionGrid;
  int targetPolygonIndices = -1;
  int activePolygonIndex = -1;

  RotateWorld({required this.returnHome}) : super() {
    questionGrid =
        GridComponent(gridSize: 35, rows: 16, cols: 20, lineWidth: 0.2)
          ..position = Vector2(150, 125);
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
    print("Loading Rotate World: ${gameBloc.state}");

    double borderWidth = 30;

    void overrideReturnHome() {
      print("Overriding return home");
      gameRef.router.pushReplacementOverlay('menu');
    }

    void giveHint() async {
      print("Give Hint");
    }

    final frame = Frame<RotateGame>(
      borderWidth: borderWidth,
      returnHome: overrideReturnHome,
      giveHint: giveHint,
      previous: () {
        print("Previous Question");
        gameBloc.add(
          NextQuestion(nextIndex: gameBloc.state.currentQuestionIndex - 1),
        );
        for (final child in children.whereType<TrophyComponent>().toList()) {
          remove(child);
        }
      },
      validate: () {
        bool isSolution = true;
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

          add(frogs);
        }
      },
    )
      ..position = Vector2(borderWidth, borderWidth)
      ..anchor = Anchor.topLeft;
    add(frame);
    add(questionGrid);

    updateQuestion(gameBloc.state);
    int? lastQuestionIndex;
    gameBloc.stream.listen((state) async {
      print("state updated: $state");
      if (lastQuestionIndex == state.currentQuestionIndex) {
        print("No change in question index, skipping update.");
        return;
      }
      lastQuestionIndex = state.currentQuestionIndex; // Update last seen index

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

      return super.onLoad();
    });
  }

  void removePolygons() {
    print("🗑 Removing existing polygons...");

    final questionPolygons =
        questionGrid.children.whereType<InterfaceClickableShape>().toList();

    for (final poly in questionPolygons) {
      questionGrid.remove(poly);
    }

    print("✅ Removed ${questionPolygons.length} from Question Grid");
  }

  void updateQuestion(GameState state) {
    removePolygons();
    activePolygonIndex = -1;
    void updateActivePolygonIndex(int index) {
      activePolygonIndex = index;
      print("Active Polygon Index: $activePolygonIndex clicked index: $index ");
      print("number of children: ${questionGrid.children.length}");
      List<InterfaceClickableShape> components =
          questionGrid.children.whereType<InterfaceClickableShape>().toList();
      for (var component in components) {
        if (component.polygonIndex == activePolygonIndex) {
          component.toggleColor();
        } else if (component.polygonIndex != -1) {
          // component.resetColor();
        }
      }
    }

    QuestionData question = state.questionList[state.currentQuestionIndex];
    QuestionPolygons questionPolygons = getQuestionPolygonsFromQuestionData(
      questionData: question,
      updateActivePolygonIndex: updateActivePolygonIndex,
    );

    questionGrid.add(questionPolygons.target);
    InterfaceClickableShape questionShape = questionPolygons.allPolygons[0];

    FrameCircle frameCircle =
        FrameCircle(radius: 200, questionShape: questionShape)
          ..position = Vector2(150, 100);

    questionGrid.add(frameCircle);
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
