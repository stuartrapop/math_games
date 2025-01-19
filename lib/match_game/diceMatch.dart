import 'package:first_math/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/left_card.dart';
import 'package:first_math/match_game/right_card.dart';
import 'package:first_math/stack_game/dividingLine.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class DiceMatch extends PositionComponent {
  final World world;
  final MatchStatsBloc matchStatsBloc;
  RouterComponent router;

  DiceMatch({
    required this.world,
    required this.matchStatsBloc,
    required this.router,
  }) : super() {
    this.router = router;
  }

  final worldSize = Vector2(600, 900);

  bool running = true;
  bool hasFinished = false;
  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
  @override
  // runnig in debug mode
  bool debugMode = true;
  //
  List<PositionComponent> components = [];
  final List<LeftCard> leftCards = [];
  final List<RightCard> rightCards = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    double yMargin = 80;
    double squareSize = worldSize.y * 0.12;

    leftCards.clear();
    rightCards.clear();

    components.clear();
    for (int i = 0; i <= 4; i++) {
      final leftCard = LeftCard(
        number: i,
        router: router,
      )
        ..position =
            Vector2(worldSize.x * 0.15, yMargin + i * worldSize.y * 0.15)
        ..size = Vector2(squareSize, squareSize)
        ..anchor = Anchor.topLeft;
      leftCards.add(leftCard);
      components.add(leftCard);
      final rightCard = RightCard(
        number: i,
        priority: 15,
      )
        ..position =
            Vector2(worldSize.x * 0.40, yMargin + i * worldSize.y * 0.15)
        ..size = Vector2(worldSize.y * 1, squareSize)
        ..anchor = Anchor.topLeft
        ..isVisible = true;
      rightCards.add(rightCard);
      components.add(rightCard);
    }

    components.add(Dividingline()
      ..position = Vector2(worldSize.x * 0.35, 0)
      ..size = Vector2(10, worldSize.y));

    // Clear and re-add components to the screen window on each resize
    await world.add(
      FlameBlocProvider<MatchStatsBloc, MatchStatsState>.value(
        value: matchStatsBloc,
        children: components,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
