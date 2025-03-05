import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/rotate_polygon/data/shapes.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

class QuestionData {
  final InterfaceClickableShape target;
  final Vector2 targetPosition;
  final List<InterfaceClickableShape> otherPolygons;
  final List<Vector2> otherPositions;
  final List<int> targetPolygonIndices;

  QuestionData({
    required this.target,
    required this.targetPosition,
    required this.otherPolygons,
    required this.otherPositions,
    required this.targetPolygonIndices,
  });
}

final question1 = QuestionData(
  target: triangle.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 3
    ..color = Colors.yellow,
  targetPosition: V(1, 2),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..color = Colors.yellow
      ..rotation = 90,
  ],
  otherPositions: [Vector2(8, 6)],
  targetPolygonIndices: [],
);

List<QuestionData> questionData = [
  question1,
];

class QuestionPolygons {
  final InterfaceClickableShape target;
  final List<InterfaceClickableShape> allPolygons;

  QuestionPolygons({
    required this.target,
    required this.allPolygons,
  });
}

QuestionPolygons getQuestionPolygonsFromQuestionData({
  required QuestionData questionData,
  required Function(int) updateActivePolygonIndex,
}) {
  InterfaceClickableShape target = questionData.target.copyWith(
    pixelToUnitRatio: 35,
    upperLeftPosition: questionData.targetPosition,
    borderWidth: 4,
    polygonIndex: -1,
  );
  List<InterfaceClickableShape> allPolygons = [];

  allPolygons.add(questionData.otherPolygons[0].copyWith(
    pixelToUnitRatio: 35,
    color: questionData.target.color,
    upperLeftPosition: questionData.otherPositions[0],
    updateActivePolygonIndex: updateActivePolygonIndex,
    borderWidth: 4,
    polygonIndex: 0,
  ));
  return QuestionPolygons(
    target: target,
    allPolygons: allPolygons,
  );
}
