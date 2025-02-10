import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

GridComponent answerGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = V(250, 100);

GridComponent questionGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = V(250, 400);

SnappablePolygon square = SnappablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
    V(0, 1),
  ],
)..grid = answerGrid;

SnappablePolygon triangle = SnappablePolygon(
  // Initial top-left position
  vertices: [
    V(0, 1), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
  ],
)..grid = answerGrid;
SnappablePolygon yellowParralelogram = SnappablePolygon(
  vertices: [
    V(1, 0), // Top-left (snap reference)
    V(4, 0),
    V(3, 2),
    V(0, 2),
  ],
)..grid = answerGrid;
SnappablePolygon lShape = SnappablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(3, 0),
    V(3, 1),
    V(1, 1),
    V(1, 2),
    V(0, 2),
  ],
)..grid = answerGrid;

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

List<QuestionData> questionData = [question1, question2, question3, question4];
List<List<SnappablePolygon>> questions = questionData
    .map((e) => List.generate(
          e.objects.length,
          (index) => e.objects[index].copyWith(grid: questionGrid)
            ..initialPosition = e.questionPositions[index],
        ))
    .toList();
List<List<SnappablePolygon>> answers = questionData
    .map((e) => List.generate(
          e.objects.length,
          (index) =>
              e.objects[index].copyWith(grid: answerGrid, isDraggable: false)
                ..initialPosition = e.answerPositions[index],
        ))
    .toList();
