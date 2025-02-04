import 'dart:ui';

import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:first_math/cerise_game/cerise_game.dart';
import 'package:first_math/cerise_game/components/fire.dart';
import 'package:first_math/cerise_game/components/stems.dart';
import 'package:first_math/cerise_game/helpers/constants.dart';
import 'package:first_math/cerise_game/helpers/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Cerises extends PositionComponent
    with
        TapCallbacks,
        CollisionCallbacks,
        HasPaint,
        HasGameRef<CeriseGame>,
        HasVisibility {
  final int number;
  Cerises({required this.number}) : super();

  late final CeriseBloc ceriseBloc;
  late final Paint cherryPaint;
  Stems? attachedStems; // Stores reference to the attached Stems
  bool isCorrect = false;
  int stemNumber = 0;
  RectangleHitbox? hitbox;

  late Vector2 initialSize;
  @override
  // runnig in debug mode
  bool debugMode = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialSize = size.clone();
    ceriseBloc = gameRef.ceriseBloc; // Get the Bloc from the game
    cherryPaint = Paint()..color = const Color(0xFFC21807); // Cherry Red
    hitbox = RectangleHitbox(
      size: size, // Centered hitbox
      anchor: Anchor.topLeft,
    );
    add(
      hitbox!,
    );
    add(FireAnimation()
      ..position = Vector2(size.x / 2 - 50, size.y / 2 + 50)
      ..size = Vector2(100, 100));
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    if (other is Stems) {
      print(
          "Cerise ${ceriseBloc.state.partB[number]} collided with Stems at distance: ${ceriseBloc.state.partA[other.number]}");

      if (ceriseBloc.state.partB[number] ==
          ceriseBloc.state.partA[other.number]) {
        print("Correct match!");
        ceriseBloc.add(CorrectMatch(number));

        // ✅ Remove stems from parent
        other.removeFromParent();
        isCorrect = true;

        // add(attachedStems!);
        stemNumber = other.number;
      } else {
        print("Incorrect match!");
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the expanded cherry container
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, isCorrect ? -initialSize.y / 2 : 0, size.x,
            isCorrect ? initialSize.y * 3 / 2 : initialSize.y),
        Radius.circular(20), // Adjust the radius for roundness
      ),
      outlinePaint,
    );

    if (isCorrect) {
      drawStems(
        ceriseBloc: ceriseBloc,
        number: stemNumber,
        canvas: canvas,
        size: size,
        offset: initialSize.y * 3 / 4 - 14,
      );
    }

    // Draw the cherries
    double circleRadius = 30; // Adjust size as needed
    double spacing = 10; // Space between circles
    int count = ceriseBloc.state.partB[number]; // Number of cherries

    // Calculate total width occupied by cherries
    double totalWidth = (count - 1) * (2 * circleRadius + spacing);

    // Start drawing from the center
    double startX = (size.x - totalWidth) / 2;
    for (int i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(startX + i * (2 * circleRadius + spacing),
            initialSize.y / 2), // Adjust Y position
        circleRadius,
        cherryPaint,
      );
    }
  }
}
