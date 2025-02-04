import 'dart:ui';

import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:first_math/cerise_game/cerise_game.dart';
import 'package:first_math/cerise_game/helpers/constants.dart';
import 'package:first_math/cerise_game/helpers/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Stems extends PositionComponent
    with
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks,
        HasPaint,
        HasGameRef<CeriseGame>,
        HasVisibility {
  final int number;
  Stems({required this.number}) : super();

  late final CeriseBloc ceriseBloc;
  late final Paint stemPaint;
  late RectangleHitbox rectangleHitbox;
  bool hasOutline = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    ceriseBloc = gameRef.ceriseBloc; // Get the Bloc from the game
    stemPaint = Paint()
      ..color = const Color(0xFF228B22) // Forest Green
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    rectangleHitbox = RectangleHitbox(size: size, anchor: Anchor.topLeft);
    add(rectangleHitbox);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isMounted) return; // ✅ Ensure component exists before updating

    // Safe check for displacement
    if (event.localPosition != null && event.localDelta != null) {
      position += event.delta;
    }
    position += event.delta;
    super.onDragUpdate(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (hasOutline) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, size.y),
          Radius.circular(20), // Adjust the radius for roundness
        ),
        outlinePaint,
      );
    }

    drawStems(
      ceriseBloc: ceriseBloc,
      number: number,
      canvas: canvas,
      size: size,
    );
  }
}
