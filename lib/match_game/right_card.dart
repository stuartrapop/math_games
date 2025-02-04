import 'dart:async';

import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/display_dice.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class RightCard extends PositionComponent
    with
        CollisionCallbacks,
        FlameBlocReader<MatchStatsBloc, MatchStatsState>,
        HasPaint,
        HasGameRef,
        HasVisibility {
  int number;
  late final StreamSubscription<MatchStatsState> _blocSubscription;

  RightCard({
    this.number = 1,
    int priority = 10,
  }) : super(
          priority: priority,
        );
  int value = 0;
  late DisplayDice dice;

  // Original and Dragging colors
  final Paint fillPaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center);
    value = bloc.state.rightValues[number];
    dice = DisplayDice(number: value)
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(size.x / 2, size.y / 2)
      ..anchor = Anchor.centerLeft;
    add(dice);
    anchor = Anchor.centerLeft;
  }

  @override
  void onMount() {
    super.onMount();
    // Subscribe to the bloc's state changes
    _blocSubscription = bloc.stream.listen((state) {
      // Update visibility whenever the bloc's leftVisible changes
      if (state.rightValues[number] != value) {
        value = state.rightValues[number];
        remove(dice);
        dice = DisplayDice(number: value)
          ..size = Vector2(size.x, size.y)
          ..position = Vector2(size.x / 2, size.y / 2)
          ..anchor = Anchor.centerLeft;
        add(dice);
      }
      isVisible = state.rightVisible[number];
    });
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.x, size.y),
    //   fillPaint,
    // );

    super.render(canvas);
  }
}
