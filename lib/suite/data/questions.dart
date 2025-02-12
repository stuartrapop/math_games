import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/shapes.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

class QuestionData {
  final List<SnappablePolygon> objects;
  final List<V> questionPositions;
  final List<V> answerPositions;

  QuestionData({
    required this.objects,
    required this.questionPositions,
    required this.answerPositions,
  });
}

final question1 = QuestionData(
  objects: [
    square.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.red,
    triangle.copyWith()..color = Colors.blue,
    yellowParralelogram.copyWith()..color = Colors.yellow,
  ],
  questionPositions: [V(1, 4), V(1, 1), V(1, 5)],
  answerPositions: [V(6, 5), V(7, 2), V(6, 3)],
);
final question2 = QuestionData(
  objects: [
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.red,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.black
      ..rotation = 90,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.orange
      ..rotation = 180,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.yellow
      ..rotation = 270,
  ],
  questionPositions: [V(1, 0), V(1, 6), V(4, 4), V(1, 4)],
  answerPositions: [V(6, 1), V(8, 1), V(8, 3), V(6, 3)],
);
final question3 = QuestionData(
  objects: [
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.red,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.black
      ..rotation = 90,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.orange
      ..rotation = 180,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.yellow
      ..rotation = 270,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 5
      ..color = Colors.green,
  ],
  questionPositions: [V(1, 0), V(1, 6), V(4, 4), V(1, 4), V(6, 0)],
  answerPositions: [V(5, 3), V(7, 3), V(7, 1), V(5, 1), V(5, 5)],
);
final question4 = QuestionData(
  objects: [
    lShape.copyWith()..color = Colors.green,
    lShape.copyWith()
      ..rotation = 90
      ..color = Colors.red,
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 4
      ..scaleWidth = 3
      ..color = Colors.black,
    lShape.copyWith()
      ..rotation = 270
      ..color = Colors.purple,
    lShape.copyWith()..color = Colors.orange,
  ],
  questionPositions: [V(1, 0), V(10, 1), V(4, 4), V(1, 4), V(6, 0)],
  answerPositions: [V(1, 0), V(2, 1), V(9, 0), V(4, 1), V(6, 0)],
);
final question5 = QuestionData(
  objects: [
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 4
      ..scaleWidth = 3
      ..color = Colors.pinkAccent,
    lShape.copyWith()
      ..rotation = 90
      ..color = Colors.red,
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 4
      ..scaleWidth = 3
      ..color = Colors.black,
    lShape.copyWith()
      ..rotation = 270
      ..color = Colors.purple,
    polygonWithHole.copyWith()
      ..scaleHeight = 0.2
      ..scaleWidth = 0.2
      ..color = Colors.orange,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.green
      ..rotation = 180,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.yellow
      ..rotation = 0,
  ],
  questionPositions: [
    V(0, 0),
    V(8, 5),
    V(0, 4),
    V(10, 5),
    V(10, 0),
    V(7, 6),
    V(4, 6)
  ],
  answerPositions: [
    V(7, 4),
    V(8, 0),
    V(4, 4),
    V(8, 1),
    V(4, 0),
    V(5, 1),
    V(5, 1)
  ],
);
final question6 = QuestionData(
  objects: [
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 4
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    square.copyWith()
      ..rotation = 90
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    lShape.copyWith()
      ..rotation = 90
      ..color = Colors.pinkAccent,
    lShape.copyWith()
      ..rotation = 270
      ..color = Colors.pinkAccent,
  ],
  questionPositions: [
    V(0, 0),
    V(2, 2),
    V(7, 4),
    V(8, 0),
    V(4, 4),
  ],
  answerPositions: [V(1, 1), V(5, 3), V(5, 1), V(9, 1), V(9, 2)],
);

List<QuestionData> questionData = [
  question1,
  question2,
  question3,
  question4,
  question5,
  question6,
];

List<SnappablePolygon> getSnappablePolygonsFromQuestion({
  required QuestionData questionData,
  required List<Vector2> positions,
  required int questionIndex,
  required GridComponent grid,
}) {
  return questionData.objects.map((sp) {
    return sp.copyWith(
      questionIndex: questionIndex,
      polygonIndex: questionData.objects.indexOf(sp),
      upperLeftPosition: positions[questionData.objects.indexOf(sp)],
      isDraggable: true,
    )..grid = grid;
  }).toList();
}
