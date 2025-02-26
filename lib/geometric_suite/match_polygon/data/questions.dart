import 'package:first_math/geometric_suite/match_polygon/components/clickable_circle.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/match_polygon/data/shapes.dart';
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
  target: octogon.copyWith()
    ..scaleHeight = 1
    ..scaleWidth = 1
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    octogon.copyWith()..rotation = 15,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8)],
  targetPolygonIndices: [2],
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
    ClickableCircle().copyWith(),
    square.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 4,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [1],
);

final question3 = QuestionData(
  target: square.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 2
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 25,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 45,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 10,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [3],
);
final question4 = QuestionData(
  target: triangle.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 2
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 25,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 45,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 2
      ..rotation = 10,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [3],
);
final question5 = QuestionData(
  target: lShape.copyWith()..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    lShape.copyWith()..rotation = 90,
    lShape.copyWith()..flipHorizontal = true,
    lShape.copyWith()..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);
final question6 = QuestionData(
  target: triangle.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 3
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 90,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 45,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);
final question7 = QuestionData(
  target: square.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 3
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 90,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 45,
    lShape.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);
final question8 = QuestionData(
  target: square.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 3
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 90,
    octogon.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..rotation = 45,
    hexagon.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);
final question9 = QuestionData(
  target: octogon.copyWith()
    ..scaleHeight = 1
    ..scaleWidth = 1
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    polygon5.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..rotation = 90,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 45,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);
final question10 = QuestionData(
  target: square.copyWith()
    ..scaleHeight = 3
    ..scaleWidth = 3
    ..color = Colors.yellow,
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 90,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 45,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(14, 8), V(14, 2)],
  targetPolygonIndices: [0],
);

final question11 = QuestionData(
  target: ClickableCircle().copyWith(color: Colors.yellow),
  targetPosition: V(2, 3),
  otherPolygons: [
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 90,
    square.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..rotation = 45,
    triangle.copyWith()
      ..scaleHeight = 3
      ..scaleWidth = 3
      ..flipVertical = true,
  ],
  otherPositions: [Vector2(4, 8), V(9, 8), V(9, 2), V(14, 8), V(14, 2)],
  targetPolygonIndices: [2, 3],
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
  for (int i = 0;
      i <
          (questionData.otherPolygons.length) +
              questionData.targetPolygonIndices.length;
      i++) {
    if (questionData.targetPolygonIndices.contains(i)) {
      allPolygons.add(questionData.target.copyWith(
        pixelToUnitRatio: 35,
        upperLeftPosition: questionData.otherPositions[i],
        updateActivePolygonIndex: updateActivePolygonIndex,
        color: questionData.target.color,
        borderWidth: 4,
        polygonIndex: i,
      ));
    } else {
      int numTargetAdded =
          questionData.targetPolygonIndices.where((x) => x <= i).length;
      allPolygons.add(questionData.otherPolygons[i - numTargetAdded].copyWith(
        pixelToUnitRatio: 35,
        color: questionData.target.color,
        upperLeftPosition: questionData.otherPositions[i],
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
