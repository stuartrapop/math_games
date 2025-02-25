import 'package:first_math/geometric_suite/match_polygon/components/clickable_polygon.dart';
import 'package:first_math/geometric_suite/match_polygon/data/shapes.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

class QuestionData {
  final ClickablePolygon target;
  final Vector2 targetPosition;
  final List<ClickablePolygon> otherPolygons;
  final List<Vector2> otherPositions;
  final int targetPolygonIndex;

  QuestionData({
    required this.target,
    required this.targetPosition,
    required this.otherPolygons,
    required this.otherPositions,
    required this.targetPolygonIndex,
  });
}

final question1 = QuestionData(
  target: octogon.copyWith()
    ..scaleHeight = 1
    ..scaleWidth = 1
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    octogon.copyWith(),
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8)],
  targetPolygonIndex: 1,
);
final question2 = QuestionData(
  target: square.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 2
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3,
    square.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8)],
  targetPolygonIndex: 1,
);

List<QuestionData> questionData = [
  question1,
  question2,
];

class QuestionPolygons {
  final ClickablePolygon target;
  final List<ClickablePolygon> allPolygons;

  QuestionPolygons({
    required this.target,
    required this.allPolygons,
  });
}

QuestionPolygons getQuestionPolygonsFromQuestionData({
  required QuestionData questionData,
  required Function(int) updateActivePolygonIndex,
}) {
  ClickablePolygon target = questionData.target.copyWith(
    pixelToUnitRatio: 35,
    upperLeftPosition: questionData.targetPosition,
    borderWidth: 4,
  );
  List<ClickablePolygon> allPolygons = [];
  for (int i = 0; i <= (questionData.otherPolygons.length); i++) {
    if (i == questionData.targetPolygonIndex) {
      allPolygons.add(questionData.target.copyWith(
        pixelToUnitRatio: 35,
        upperLeftPosition: questionData.otherPositions[i],
        updateActivePolygonIndex: updateActivePolygonIndex,
        color: Colors.transparent,
        borderWidth: 4,
        polygonIndex: i,
      ));
    } else {
      allPolygons.add(questionData
          .otherPolygons[i > question1.targetPolygonIndex ? i - 1 : i]
          .copyWith(
        pixelToUnitRatio: 35,
        color: Colors.transparent,
        upperLeftPosition: question1.otherPositions[i],
        updateActivePolygonIndex: updateActivePolygonIndex,
        borderWidth: 4,
        polygonIndex: i,
      ));
    }
  }
  return QuestionPolygons(
    target: target,
    allPolygons: allPolygons,
  );
}
