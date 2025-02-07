import 'dart:async';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/components/fire.dart';
import 'package:first_math/suite/components/frame.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:first_math/suite/utils/constants.dart';
import 'package:first_math/suite/utils/utils.dart';
import 'package:first_math/utils/bounderies.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class SuiteWorld extends Forge2DWorld with HasGameRef<SuiteGame> {
  final Function returnHome;
  late final SuiteBloc suiteBloc;
  SuiteWorld({required this.returnHome}) : super(gravity: Vector2.zero());
  bool showReplay = false;
  late StreamSubscription suiteSubscription;

  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 12, 12, 211);

  late TextComponent valueText;
  late Vector2 worldCenter;

  @override
  FutureOr<void> onLoad() async {
    suiteBloc = gameRef.suiteBloc; // Get the Bloc from the game
    print("Using suiteBloc: ${suiteBloc.state}");
    double borderWidth = 30;

    final boundaries = createBoundaries(
      width: 1000,
      height: 800,
      borderWidth: borderWidth,
    );
    await addAll(boundaries);

    final frame = Frame(
      borderWidth: borderWidth,
      returnHome: returnHome,
      validate: () {
        List<SnappablePolygon> questionPolygons =
            getPolygonsOnGrid(targetGrid, this);
        List<SnappablePolygon> solutionPolygons =
            getPolygonsOnGrid(solutionGrid, this);

        bool isSolution = comparePolygons(
          questions: questionPolygons,
          questionGrid: targetGrid,
          answers: solutionPolygons,
          answerGrid: solutionGrid,
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
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, 1000, 800),
    //   fillBlue,
    // );
    // super.render(canvas);
  }

  // Call this periodically or in response to an event
  @override
  void update(double dt) {
    super.update(dt);
    // logChildren();
  }

  void gameReset() {
    suiteBloc.add(GameReset());

    add(solutionGrid);

    add(targetGrid);

    addAll(questions[2]);
    addAll(answers[2]);
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
