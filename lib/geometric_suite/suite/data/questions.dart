import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/suite/components/interface_snappable_shape.dart';
import 'package:first_math/geometric_suite/suite/data/shapes.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

class QuestionData {
  final List<InterfaceSnappableShape> objects;
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
    // triangle.copyWith()
    //   ..scaleHeight = 2
    //   ..scaleWidth = 2
    //   ..color = Colors.blue,
    // yellowParralelogram.copyWith()..color = Colors.yellow,
  ],
  // questionPositions: [V(1, 4), V(1, 1), V(1, 5)],
  // answerPositions: [V(6, 5), V(7, 1), V(6, 3)],
  questionPositions: [V(1, 4)],
  answerPositions: [V(6, 5)],
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
      // ..rotation = 90
      ..scaleHeight = 4
      ..scaleWidth = 3
      ..color = Colors.pinkAccent,
    lShape.copyWith()
      ..rotation = 90
      ..color = Colors.red,
    square.copyWith()
      // ..rotation = 90
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
      ..scaleHeight = 4
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    triangle.copyWith()
      ..rotation = 270
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    triangle.copyWith()
      ..rotation = 90
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.pinkAccent,
    triangle.copyWith()
      ..rotation = 270
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.yellow,
    triangle.copyWith()
      ..rotation = 90
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.yellow,
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
    V(9, 1),
    V(5, 1),
    V(9, 5),
    V(9, 5),
    V(5, 1),
    V(5, 4),
    V(1, 1),
    V(1, 2)
  ],
  answerPositions: [
    V(1, 1),
    V(5, 1),
    V(9, 5),
    V(9, 5),
    V(5, 1),
    V(5, 3),
    V(9, 1),
    V(9, 2)
  ],
);
final question7 = QuestionData(
  objects: [
    hexagon.copyWith()..color = Colors.pinkAccent,
    hexagon.copyWith()..color = Colors.green,
    hexagon.copyWith()..color = Colors.yellow,
    hexagon.copyWith()..color = Colors.red,
    hexagon.copyWith()..color = Colors.pinkAccent,
    hexagon.copyWith()..color = Colors.green,
    hexagon.copyWith()..color = Colors.yellow,
    hexagon.copyWith()..color = Colors.red,
    hexagon.copyWith()..color = Colors.pinkAccent,
    hexagon.copyWith()..color = Colors.green,
    hexagon.copyWith()..color = Colors.yellow,
    hexagon.copyWith()..color = Colors.red,
    hexagon.copyWith()..color = Colors.blue,
    hexagon.copyWith()..color = Colors.blue,
    hexagon.copyWith()..color = Colors.blue,
  ],
  questionPositions: [
    V(4, 0),
    V(4, 2),
    V(2, 5),
    V(6, 1),
    V(10, 1),
    V(6, 3),
    V(4, 6),
    V(8, 2),
    V(8, 0),
    V(8, 4),
    V(0, 4),
    V(10, 3),
    V(4, 4),
    V(6, 5),
    V(2, 3)
  ],
  answerPositions: [
    V(11, 5),
    V(5, 2),
    V(3, 3),
    V(7, 1),
    V(11, 3),
    V(5, 4),
    V(3, 5),
    V(7, 3),
    V(11, 1),
    V(5, 6),
    V(3, 1),
    V(7, 5),
    V(9, 4),
    V(9, 6),
    V(9, 2)
  ],
);
final question8 = QuestionData(
  objects: [
    polygon5.copyWith()..color = Colors.pinkAccent,
    polygon5.copyWith()
      ..color = Colors.pinkAccent
      ..rotation = 90,
    polygon5.copyWith()
      ..color = Colors.pinkAccent
      ..rotation = 180,
    polygon5.copyWith()
      ..color = Colors.pinkAccent
      ..rotation = 270,
    polygon5.copyWith()..color = Colors.green,
    polygon5.copyWith()
      ..color = Colors.green
      ..rotation = 90,
    polygon5.copyWith()
      ..color = Colors.green
      ..rotation = 180,
    polygon5.copyWith()
      ..color = Colors.green
      ..rotation = 270,
    polygon5.copyWith()..color = Colors.yellow,
    polygon5.copyWith()
      ..color = Colors.yellow
      ..rotation = 90,
    polygon5.copyWith()
      ..color = Colors.yellow
      ..rotation = 180,
    polygon5.copyWith()
      ..color = Colors.yellow
      ..rotation = 270,
    polygon5.copyWith()..color = Colors.blue,
    polygon5.copyWith()
      ..color = Colors.blue
      ..rotation = 90,
    polygon5.copyWith()
      ..color = Colors.blue
      ..rotation = 180,
    polygon5.copyWith()
      ..color = Colors.blue
      ..rotation = 270,
    square.copyWith()..color = Colors.pinkAccent,
    square.copyWith()..color = Colors.pinkAccent,
    square.copyWith()..color = Colors.pinkAccent,
    square.copyWith()..color = Colors.pinkAccent,
    square.copyWith()..color = Colors.yellow,
    square.copyWith()..color = Colors.yellow,
    square.copyWith()..color = Colors.yellow,
    square.copyWith()..color = Colors.yellow,
    square.copyWith()..color = Colors.green,
    square.copyWith()..color = Colors.green,
    square.copyWith()..color = Colors.green,
    square.copyWith()..color = Colors.green,
    square.copyWith()..color = Colors.blue,
    square.copyWith()..color = Colors.blue,
    square.copyWith()..color = Colors.blue,
    square.copyWith()..color = Colors.blue,
  ],
  questionPositions: [
    V(7, 1),
    V(6, 2),
    V(5, 1),
    V(6, 0),
    V(7, 5),
    V(6, 6),
    V(5, 5),
    V(6, 4),
    V(12, 1),
    V(11, 2),
    V(10, 1),
    V(11, 0),
    V(2, 1),
    V(1, 2),
    V(0, 1),
    V(1, 0),
    V(8, 3),
    V(5, 3),
    V(8, 0),
    V(5, 0),
    V(10, 3),
    V(13, 3),
    V(13, 0),
    V(10, 0),
    V(8, 7),
    V(5, 7),
    V(8, 4),
    V(5, 4),
    V(3, 3),
    V(0, 3),
    V(3, 0),
    V(0, 0)
  ],
  answerPositions: [
    V(11, 1),
    V(6, 2),
    V(9, 5),
    V(6, 4),
    V(7, 5),
    V(10, 2),
    V(5, 1),
    V(10, 4),
    V(11, 5),
    V(6, 6),
    V(9, 1),
    V(6, 0),
    V(7, 1),
    V(10, 6),
    V(5, 5),
    V(10, 0),
    V(5, 0),
    V(9, 3),
    V(12, 4),
    V(8, 7),
    V(8, 3),
    V(5, 4),
    V(9, 7),
    V(12, 0),
    V(12, 7),
    V(9, 0),
    V(5, 7),
    V(8, 0),
    V(5, 3),
    V(9, 4),
    V(8, 4),
    V(12, 3)
  ],
);
final question9 = QuestionData(
  objects: [
    lShape.copyWith()..color = Colors.pinkAccent,
    lShape.copyWith(flipHorizontal: true)..color = Colors.pinkAccent,
    lShape.copyWith(flipVertical: true)..color = Colors.pinkAccent,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.pinkAccent,
    lShape.copyWith()..color = Colors.green,
    lShape.copyWith(flipHorizontal: true)..color = Colors.green,
    lShape.copyWith(flipVertical: true)..color = Colors.green,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.green,
    lShape.copyWith()..color = Colors.blue,
    lShape.copyWith(flipHorizontal: true)..color = Colors.blue,
    lShape.copyWith(flipVertical: true)..color = Colors.blue,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.blue,
    lShape.copyWith()..color = Colors.yellow,
    lShape.copyWith(flipHorizontal: true)..color = Colors.yellow,
    lShape.copyWith(flipVertical: true)..color = Colors.yellow,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.yellow,
  ],
  questionPositions: [
    V(2, 2),
    V(5, 5),
    V(10, 2),
    V(8, 4),
    V(9, 1),
    V(3, 3),
    V(8, 0),
    V(10, 6),
    V(6, 2),
    V(4, 4),
    V(9, 5),
    V(6, 6),
    V(11, 3),
    V(7, 3),
    V(5, 1),
    V(4, 0)
  ],
  answerPositions: [
    V(2, 2),
    V(5, 5),
    V(10, 2),
    V(8, 4),
    V(9, 1),
    V(3, 3),
    V(4, 0),
    V(10, 6),
    V(6, 2),
    V(4, 4),
    V(9, 5),
    V(6, 6),
    V(11, 3),
    V(7, 3),
    V(5, 1),
    V(8, 0)
  ],
);
final question10 = QuestionData(
  objects: [
    lShape.copyWith()..color = Colors.blue,
    lShape.copyWith(flipHorizontal: true)..color = Colors.blue,
    lShape.copyWith(flipVertical: true)..color = Colors.blue,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.blue,
    lShape.copyWith()..color = Colors.green,
    lShape.copyWith(flipHorizontal: true)..color = Colors.green,
    lShape.copyWith(flipVertical: true)..color = Colors.green,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.green,
    lShape.copyWith()..color = Colors.red,
    lShape.copyWith(flipHorizontal: true)..color = Colors.red,
    lShape.copyWith(flipVertical: true)..color = Colors.red,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.red,
    lShape.copyWith()..color = Colors.yellow,
    lShape.copyWith(flipHorizontal: true)..color = Colors.yellow,
    lShape.copyWith(flipVertical: true)..color = Colors.yellow,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.yellow,
    lShape.copyWith()..color = Colors.orange,
    lShape.copyWith(flipHorizontal: true)..color = Colors.orange,
    lShape.copyWith(flipVertical: true)..color = Colors.orange,
    lShape.copyWith(flipVertical: true, flipHorizontal: true)
      ..color = Colors.orange,
  ],
  questionPositions: [
    V(6, 6),
    V(7, 4),
    V(6, 4),
    V(7, 6),
    V(10, 4),
    V(11, 6),
    V(10, 6),
    V(11, 4),
    V(6, 0),
    V(7, 2),
    V(6, 2),
    V(7, 0),
    V(10, 2),
    V(11, 0),
    V(10, 0),
    V(11, 2),
    V(2, 2),
    V(3, 0),
    V(2, 0),
    V(3, 2)
  ],
  answerPositions: [
    V(0, 0),
    V(5, 6),
    V(0, 4),
    V(5, 2),
    V(4, 2),
    V(1, 6),
    V(8, 2),
    V(5, 0),
    V(8, 0),
    V(1, 4),
    V(4, 6),
    V(1, 0),
    V(4, 0),
    V(9, 2),
    V(4, 4),
    V(1, 2),
    V(0, 2),
    V(5, 4),
    V(0, 6),
    V(9, 0)
  ],
);

final question11 = QuestionData(
  objects: [
    polygonWithLShapeHole.copyWith()
      ..color = Colors.yellow
      ..rotation = 0,
    lShape.copyWith()
      ..color = Colors.red
      ..rotation = -90,
    circle.copyWith()
      ..color = Colors.green
      ..radius = 2
      ..priority = 25
      ..rotation = 0,
    polygonWithCircularHole.copyWith()
      ..color = Colors.blue
      ..rotation = 0,
  ],
  questionPositions: [V(4, 0), V(7, 5), V(0, 4), V(8, 0)],
  answerPositions: [V(2, 1), V(3, 2), V(9, 2), V(8, 1)],
);
final question12 = QuestionData(
  objects: [
    circle.copyWith()
      ..radius = 1
      ..color = Colors.red,
    circle.copyWith()
      ..radius = 1
      ..color = Colors.green,
    square.copyWith()
      ..rotation = 22
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..color = Colors.green,
    square.copyWith()
      ..rotation = 22
      ..scaleHeight = 3
      ..scaleWidth = 1.5
      ..color = Colors.blue,
    lShape.copyWith()
      ..scaleHeight = 1
      ..scaleWidth = 1
      ..rotation = 12
      ..color = Colors.brown,
    triangle.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 4
      ..rotation = 22
      ..color = Colors.purple,
    pentagon.copyWith()
      ..scaleHeight = 0.5
      ..scaleWidth = 0.5
      ..rotation = -5
      ..color = Colors.yellow,
  ],
  questionPositions: [
    V(6, 0),
    V(6, 2),
    V(11, 3),
    V(9, 3),
    V(4, 6),
    V(5, 4),
    V(4, 5)
  ],
  answerPositions: [
    V(6, 0),
    V(6, 2),
    V(11, 3),
    V(9, 3),
    V(4, 6),
    V(5, 4),
    V(4, 5)
  ],
);
final question13 = QuestionData(
  objects: [
    polygonWithCircularHole.copyWith()
      ..color = Colors.yellow
      ..rotation = 0,
    square.copyWith()
      ..color = Colors.red
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..rotation = 0,
    circle.copyWith()
      ..color = Colors.green
      ..radius = 2
      ..priority = 25
      ..rotation = 0,
    circle.copyWith()
      ..color = Colors.blue
      ..radius = 1
      ..priority = 25
      ..rotation = 0,
  ],
  questionPositions: [V(0, 2), V(8, 6), V(9, 1), V(11, 6)],
  answerPositions: [V(8, 2), V(2, 6), V(1, 1), V(10, 4)],
);

List<QuestionData> questionData = [
  question1,
  question2,
  question3,
  question4,
  question5,
  question6,
  question7,
  question8,
  question9,
  question10,
  question11,
  question12,
  question13
];

List<InterfaceSnappableShape> getSnappablePolygonsFromQuestion({
  required QuestionData questionData,
  required List<Vector2> positions,
  required int questionIndex,
  required GridComponent grid,
  required bool isDraggable,
}) {
  return questionData.objects.map((sp) {
    return sp.copyWith(
      questionIndex: questionIndex,
      polygonIndex: questionData.objects.indexOf(sp),
      upperLeftPosition: positions[questionData.objects.indexOf(sp)],
      isDraggable: isDraggable,
      grid: grid,
    )..grid = grid;
  }).toList();
}
