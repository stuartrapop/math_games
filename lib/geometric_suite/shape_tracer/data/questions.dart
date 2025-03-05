import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/shape_tracer/data/shapes.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

class QuestionData {
  final List<InterfaceClickableShape> polygons;
  final List<Vector2> positions;

  QuestionData({
    required this.polygons,
    required this.positions,
  });
}

final question1 = QuestionData(
  polygons: [
    square.copyWith()
      ..scaleHeight = 5
      ..scaleWidth = 5,
  ],
  positions: [
    V(8, 1),
  ],
);
final question2 = QuestionData(
  polygons: [
    lShape.copyWith(color: Colors.yellow)
      ..scaleHeight = 2
      ..scaleWidth = 2
      ..rotation = 40
      ..isTapped = true,
  ],
  positions: [
    Vector2(1, 1),
  ],
);
final question3 = QuestionData(
  polygons: [
    square.copyWith()
      ..scaleHeight = 4
      ..scaleWidth = 3
      ..rotation = 45,
  ],
  positions: [
    V(5, 1),
  ],
);
final question4 = QuestionData(
  polygons: [
    hexagon.copyWith()
      ..scaleHeight = 2
      ..scaleWidth = 2,
  ],
  positions: [
    V(5, 1),
  ],
);
final question5 = QuestionData(
  polygons: [
    polygon5.copyWith()
      ..color = Colors.orange
      ..scaleHeight = 2
      ..scaleWidth = 2,
  ],
  positions: [
    V(5, 1),
  ],
);

List<QuestionData> questionData = [
  question1,
  question2,
  question3,
  question4,
  question5,
];

class QuestionPolygons {
  final InterfaceClickableShape target;
  final List<InterfaceClickableShape> allPolygons;

  QuestionPolygons({
    required this.target,
    required this.allPolygons,
  });
}
