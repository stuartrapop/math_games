import 'dart:math';

import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

List<int> generatePartAValues({int number = 5}) {
  Random random = Random();
  final leftValues = List.generate(
    number,
    (index) => index + 1,
  );
  return leftValues..shuffle(random);
}

List<int> generatePartBValues({required List<int> leftValues}) {
  if (leftValues.length < 2) {
    throw ArgumentError("List must have at least 2 elements");
  }

  List<int> rightValues = List.from(leftValues);
  Random random = Random();

  bool isValid(List<int> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == leftValues[i]) {
        return false;
      }
    }
    return true;
  }

  do {
    rightValues.shuffle(random);
  } while (!isValid(rightValues));

  return rightValues;
}

void drawStems(
    {required CeriseBloc ceriseBloc,
    required int number,
    required Canvas canvas,
    required Vector2 size,
    double offset = 0}) {
  Paint stemPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round;
  double circleRadius = 30; // Radius of cherries
  double spacing = 10; // Space between cherries
  int count =
      ceriseBloc.state.partA[number]; // Number of stems (same as cherries)

  // Calculate total width occupied by cherries
  double totalWidth = (count - 1) * (2 * circleRadius + spacing);
  double startX = (size.x - totalWidth) / 2; // Start from the center

  // Define the top point where all stems converge
  Offset topPoint = Offset(
      size.x / 2, size.y / 2 - 25 - offset); // Adjust height above cherries

  for (int i = 0; i < count; i++) {
    Offset bottomPoint = Offset(
      startX + i * (2 * circleRadius + spacing), // X position of cherry
      size.y - offset, // Align at top of the cherry
    );

    // Draw the stem from bottomPoint to topPoint
    canvas.drawLine(bottomPoint, topPoint, stemPaint);
  }
}
