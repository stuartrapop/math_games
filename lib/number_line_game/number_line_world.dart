import 'dart:async';

import 'package:first_math/number_line_game/game_path_painter.dart';
import 'package:first_math/number_line_game/number_line_component.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:first_math/number_line_game/spiral_segment.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class NumberLineWorld extends World with HasGameRef<NumberLineGame> {
  final Function returnHome;
  NumberLineWorld({required this.returnHome}) : super();
  Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 50, 50, 52);

  late GamePathPainter pathPainter;

  late TextComponent valueText;
  late SpiralPathHitbox spiralPathHitbox;

  void updateScore() {
    valueText.text = "Score: ${game.score}";
  }

  @override
  FutureOr<void> onLoad() async {
    pathPainter = GamePathPainter(gamePath: game.gamePath);
    valueText = TextComponent(
      text: "Score: ${game.score}",
      position: Vector2(50, 50), // Adjust position for alignment
      anchor: Anchor.centerLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 214, 193, 193),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(valueText);
    add(NumberLineComponent(returnHome: returnHome)
      ..anchor = Anchor.topLeft
      ..size = Vector2(800, 600));
    spiralPathHitbox = SpiralPathHitbox(path: game.gamePath.path)
      ..position = Vector2(0, 0);
    add(spiralPathHitbox);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    pathPainter.paint(canvas, Vector2(800, 600).toSize());
    super.render(canvas);
  }

  void logChildren({Component? parent, int level = 0}) {
    final target = parent ??
        this; // Start from the current component if no parent is provided
    int count = 0;

    for (final child in target.children) {
      count++;
      logChildren(
          parent: child, level: level + 1); // Recursively log child components
    }

    if (level == 0) {
      debugPrint('Total children (including nested): $count');
    }
  }

  // Call this periodically or in response to an event
  @override
  void update(double dt) {
    super.update(dt);
    // logChildren();
  }

  @override
  void onRemove() {
    print("NumberLineWorld onRemove");
    removeAll(children);
    Flame.images.clearCache();
    Flame.assets.clearCache();
  }
}
