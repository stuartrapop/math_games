import 'dart:async';

import 'package:first_math/geometric_suite/common/components/frame/frame.dart';
import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/match_polygon/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/match_polygon/components/clickable_polygon.dart';
import 'package:first_math/geometric_suite/match_polygon/data/questions.dart';
import 'package:first_math/geometric_suite/match_polygon/match_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geobase/geobase.dart';

class MatchWorld extends World with HasGameRef<MatchGame> {
  final Function returnHome;
  late final GameBloc gameBloc;
  late final GridComponent questionGrid;

  MatchWorld({required this.returnHome}) : super() {
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
  int activePolygonIndex = -1;
  void updateActivePolygonIndex(int index) {
    activePolygonIndex = index;
    print("Active Polygon Index: $activePolygonIndex");
    List<ClickablePolygon> components =
        questionGrid.children.whereType<ClickablePolygon>().toList();
    for (var component in components) {
      print("Component Index: ${component.polygonIndex}");
      if (component.polygonIndex == activePolygonIndex) {
        component.toggleColor();
      } else if (component.polygonIndex != -1) {
        component.resetColor();
      }
    }
  }

  @override
  FutureOr<void> onLoad() async {
    worldCenter = gameRef.size / 2;

    gameBloc = gameRef.gameBloc; // Get the Bloc from the game
    print("Loading Suite World: ${gameBloc.state}");

    double borderWidth = 30;

    void overrideReturnHome() {
      print("Overriding return home");
      gameRef.router.pushReplacementOverlay('menu');
    }

    List<double> convertVector2ToDoubles(List<Vector2> vectors) {
      return vectors.expand((v) => [v.x, v.y]).toList();
    }

    void giveHint() async {
      print("Give Hint");
      List<ClickablePolygon> components =
          questionGrid.children.whereType<ClickablePolygon>().toList();
      ClickablePolygon component = components.firstWhere(
          (element) => element.polygonIndex == question1.targetPolygonIndex);
      List<Vector2> points = component.adjustedVertices;
      Polygon componentPolygon =
          Polygon.build([convertVector2ToDoubles(points)]);
      Vector2 labelPosition = Vector2(componentPolygon.polylabel2D().position.x,
          componentPolygon.polylabel2D().position.y);
      component.demoClick(labelPosition: labelPosition);
    }

    final frame = Frame<MatchGame>(
      borderWidth: borderWidth,
      returnHome: overrideReturnHome,
      giveHint: giveHint,
      previous: () {
        print("Previous Question");
      },
      validate: () {
        print("Validate Answer");
        List<ClickablePolygon> components =
            questionGrid.children.whereType<ClickablePolygon>().toList();
        if (components[question1.targetPolygonIndex].isTapped == true) {
          print("Correct Answer");
        } else {
          print("Incorrect Answer");
        }
      },
    )
      ..position = Vector2(borderWidth, borderWidth)
      ..anchor = Anchor.topLeft;
    add(frame);
    add(questionGrid);
    QuestionPolygons question1Polygons = getQuestionPolygonsFromQuestionData(
      questionData: question1,
      updateActivePolygonIndex: updateActivePolygonIndex,
    );

    questionGrid.add(question1Polygons.target);
    questionGrid.addAll(question1Polygons.allPolygons);

    gameBloc.stream.listen((state) async {
      print("state updated: $state");

      return super.onLoad();
    });

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
}
