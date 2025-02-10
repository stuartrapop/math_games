import 'dart:async';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/components/fire.dart';
import 'package:first_math/suite/components/frame.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:first_math/suite/utils/constants.dart';
import 'package:first_math/suite/utils/utils.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class SuiteWorld extends World with HasGameRef<SuiteGame> {
  final Function returnHome;
  late final SuiteBloc suiteBloc;
  SuiteWorld({required this.returnHome}) : super();
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
    print("Using suiteBloc: ${suiteBloc.state}");
    double borderWidth = 30;

    final frame = Frame(
      borderWidth: borderWidth,
      returnHome: returnHome,
      validate: () {
        List<SnappablePolygon> questionPolygons =
            getPolygonsOnGrid(questionGrid, this);
        List<SnappablePolygon> solutionPolygons =
            getPolygonsOnGrid(answerGrid, this);

        bool isSolution = comparePolygons(
          questions: questionPolygons,
          questionGrid: questionGrid,
          answers: solutionPolygons,
          answerGrid: answerGrid,
        );
        print("isSolution: $isSolution");
        if (isSolution) {
          AnimatedSprite fire = AnimatedSprite(spriteName: SpriteName.hearts)
            ..size = Vector2(400, 400)
            ..position = Vector2(300, 200);

          add(fire);
        } else {
          AnimatedSprite fire = AnimatedSprite(spriteName: SpriteName.frogs)
            ..size = Vector2(400, 400)
            ..position = Vector2(300, 200);

          add(fire);
        }
      },
    )
      ..position = Vector2(borderWidth, borderWidth)
      ..anchor = Anchor.topLeft;
    add(frame);

    suiteSubscription = suiteBloc.stream.listen((state) {
      onStateChange(state);
    });

    gameReset();

    return super.onLoad();
  }

  bool allTrue(List<bool> list) {
    return list.every((element) => element);
  }

  void onStateChange(SuiteState state) {
    print("State Updated: $state");
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 1000, 800),
      fillBlue,
    );
    super.render(canvas);
  }

  void gameReset() {
    suiteBloc.add(GameReset());

    add(answerGrid);

    add(questionGrid);

    addAll(questions[4]);
    addAll(answers[4]);
  }

  // @override
  // void onRemove() {
  //   for (final child in children.toList()) {
  //     if (child.parent != null) {
  //       remove(child);
  //     }
  //   }
  //   super.onRemove();
  // }
}
