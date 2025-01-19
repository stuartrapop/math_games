import 'dart:async';

import 'package:first_math/multi-cuisenaire/bloc/cuisenaire_bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class RefactorButton extends PositionComponent
    with
        TapCallbacks,
        HasGameRef,
        FlameBlocListenable<CuisenaireBloc, CuisenaireState> {
  int value;
  bool isHorizontal;
  Paint backgroundPaint = Paint()..color = const Color(0xFFAAAAAA);
  late TextComponent valueText;

  RefactorButton({
    required this.value,
    required this.isHorizontal,
  }) {}

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Access the bloc and verify it exists
    valueText = TextComponent(
      text: "$value",
      position: size / 2, // Adjust position for alignment
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 88, 81, 81),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(valueText);
    return super.onLoad();
  }

  @override
  void onNewState(CuisenaireState state) {
    final leftTableRectangleValue = getLeftTableRectangleValue();
    bool isFactorable = false;
    if (leftTableRectangleValue.isRectangle) {
      isFactorable = isHorizontal
          ? leftTableRectangleValue.size.x.floor() % value.floor() == 0
          : leftTableRectangleValue.size.y.floor() % value.floor() == 0;

      // Update the color based on factorable status
      backgroundPaint.color = isFactorable
          ? const Color(0xFF00FF00) // Bright color when factorable
          : const Color(0xFFAAAAAA); // Faded color when not factorable
    } else {
      backgroundPaint.color =
          const Color(0xFFAAAAAA); // Faded color when not a rectangle
    }
    children.whereType<TextComponent>().forEach(remove);
    valueText = TextComponent(
      text: "$value",
      position: size / 2, // Adjust position for alignment
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: isFactorable ? Colors.black : Color.fromARGB(255, 88, 81, 81),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(valueText);
  }

  @override
  void onTapDown(TapDownEvent event) {
    RectangleResult leftTableRectangleValue = getLeftTableRectangleValue();
    if (leftTableRectangleValue.isRectangle) {
      print("onTapDown refactored");
      print("lf: $leftTableRectangleValue");
      bool isFactorable = isHorizontal
          ? leftTableRectangleValue.size.x.floor() % value.floor() == 0
          : leftTableRectangleValue.size.y.floor() % value.floor() == 0;
      if (isFactorable) {
        bloc.add(RefactorFirstBoard(
            value: value,
            isHorizontal: isHorizontal,
            leftTableRectangleValue: leftTableRectangleValue));
      } else {
        print(
            "Not factorable ${leftTableRectangleValue.size.y.floor()} ${value.floor()}");
        bloc.add(const ClearRightBoard());
      }
    } else {
      print("Not a rectangle");
      bloc.add(const ClearRightBoard());
    }
  }

  RectangleResult getLeftTableRectangleValue() {
    // Count occupied cells
    List<RegletteBlock> reglettes = bloc.state.leftBoard;
    Vector2 upperLeft = Vector2(-1, -1);
    Vector2 lowerRight = Vector2(-1, -1);
    int totalCount = 0;
    for (final reglette in reglettes) {
      totalCount += reglette.value;
      if (upperLeft.x == -1 || reglette.startColumn < upperLeft.x) {
        upperLeft.x = reglette.startColumn.toDouble();
      }
      if (upperLeft.y == -1 || reglette.startRow < upperLeft.y) {
        upperLeft.y = reglette.startRow.toDouble();
      }
      if (lowerRight.x == -1 || reglette.getEndPosition().x > lowerRight.x) {
        lowerRight.x = reglette.getEndPosition().x;
      }
      if (lowerRight.y == -1 || reglette.getEndPosition().y > lowerRight.y) {
        lowerRight.y = reglette.getEndPosition().y;
      }
    }
    bool isRectangle =
        (lowerRight.x - upperLeft.x + 1) * (lowerRight.y - upperLeft.y + 1) ==
            totalCount;
    Vector2 size =
        Vector2(lowerRight.x - upperLeft.x + 1, lowerRight.y - upperLeft.y + 1);
    return RectangleResult(
        isRectangle: isRectangle, upperLeft: upperLeft, size: size);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      backgroundPaint,
    );
    // Adjust thickness of the outline

    super.render(canvas);
  }
}

class RectangleResult {
  final bool isRectangle;
  final Vector2 upperLeft;
  final Vector2 size;

  RectangleResult({
    required this.isRectangle,
    required this.upperLeft,
    required this.size,
  });

  @override
  String toString() =>
      'RectangleResult(isRectangle: $isRectangle, upperLeft: $upperLeft, size: $size)';
}
