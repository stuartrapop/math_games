import 'dart:async';

import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:first_math/cerise_game/cerise_game.dart';
import 'package:first_math/cerise_game/components/cerises.dart';
import 'package:first_math/cerise_game/components/replay.dart';
import 'package:first_math/cerise_game/components/stems.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CeriseWorld extends World with HasGameRef<CeriseGame> {
  final Function returnHome;
  late final CeriseBloc ceriseBloc;
  CeriseWorld({required this.returnHome}) : super();
  bool showReplay = false;
  late StreamSubscription ceriseSubscription;

  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 50, 50, 52);

  late TextComponent valueText;
  late Replay replay;

  @override
  FutureOr<void> onLoad() async {
    ceriseBloc = gameRef.ceriseBloc; // Get the Bloc from the game
    print("Using CeriseBloc: ${ceriseBloc.state}");
    valueText = TextComponent(
      text: "Jeux de Cerises ",
      position: Vector2(50, 50), // Adjust position for alignment
      anchor: Anchor.centerLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 214, 193, 193),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(valueText);
    replay = Replay(gameReset: gameReset)
      ..position = Vector2(50, 100)
      ..size = Vector2(100, 100)
      ..isVisible = false;
    add(replay);

    ceriseSubscription = ceriseBloc.stream.listen((state) {
      onStateChange(state);
    });

    gameReset();

    return super.onLoad();
  }

  bool allTrue(List<bool> list) {
    return list.every((element) => element);
  }

  void onStateChange(CeriseState state) {
    print("State Updated: $state");
    if (allTrue(state.matchStatus)) {
      replay.isVisible = true;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 1000, 800),
      fill75TransparentBlack,
    );
    super.render(canvas);
  }

  // Call this periodically or in response to an event
  @override
  void update(double dt) {
    super.update(dt);
    // logChildren();
  }

  void gameReset() {
    ceriseBloc.add(GameReset());
    replay.isVisible = false;
    for (final child in children.toList()) {
      if (child.parent != null) {
        if (child is Stems || child is Cerises) remove(child);
      }
    }
    for (int i = 0; i < ceriseBloc.state.partA.length; i++) {
      add(Stems(number: i)
        ..position = Vector2(300.0 * i, 125.0)
        ..size = Vector2(250, 175));
    }

    for (int i = 0; i < ceriseBloc.state.partB.length; i++) {
      add(
        Cerises(number: i)
          ..position = Vector2(300.0 * i, 450.0)
          ..size = Vector2(250, 175)
          ..anchor = Anchor.topLeft,
      );
    }
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
