import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

GridComponent solutionGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = Vector2(250, 100);

GridComponent targetGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = Vector2(250, 400);

final squareVertices = [
  Vector2(0, 0), // Top-left (snap reference)
  Vector2(1, 0),
  Vector2(1, 1),
  Vector2(0, 1),
];
final triangleVertices = [
  Vector2(0, 1), // Top-left (snap reference)
  Vector2(1, 0),
  Vector2(1, 1),
];

final parrallelagramVertices = [
  Vector2(1, 0), // Top-left (snap reference)
  Vector2(4, 0),
  Vector2(3, 2),
  Vector2(0, 2),
];

SnappablePolygon redRectangle = SnappablePolygon(
  grid: targetGrid,
  vertices: squareVertices,
  polyColor: Colors.red,
  scaleWidth: 2,
);
SnappablePolygon square2x2 = SnappablePolygon(
  grid: targetGrid,
  vertices: squareVertices,
  polyColor: Colors.green,
  scaleWidth: 2,
  scaleHeight: 2,
);

SnappablePolygon triangle = SnappablePolygon(
    // Initial top-left position
    grid: targetGrid,
    vertices: triangleVertices,
    polyColor: Colors.blue,
    scaleHeight: 2,
    scaleWidth: 2);
SnappablePolygon yellowParralelogram = SnappablePolygon(
  grid: targetGrid,
  vertices: parrallelagramVertices,
  polyColor: const Color.fromARGB(255, 219, 243, 33),
);

List<SnappablePolygon> question1 = [
  redRectangle.copyWith()..initialPosition = Vector2(1, 4),
  triangle.copyWith()..initialPosition = Vector2(1, 1),
  yellowParralelogram.copyWith()..initialPosition = Vector2(1, 5),
];
List<SnappablePolygon> answer1 = [
  redRectangle.copyWith(grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(6, 5),
  triangle.copyWith(grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(7, 2),
  yellowParralelogram.copyWith(grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(6, 3),
];

List<SnappablePolygon> question2 = [
  square2x2.copyWith()..initialPosition = Vector2(1, 4),
  square2x2.copyWith(polyColor: Colors.blue)..initialPosition = Vector2(4, 4),
  square2x2.copyWith(polyColor: Colors.blue)..initialPosition = Vector2(7, 4),
  square2x2.copyWith(polyColor: Colors.blue)..initialPosition = Vector2(1, 0),
  square2x2.copyWith(polyColor: Colors.blue)..initialPosition = Vector2(6, 0),
];
List<SnappablePolygon> answer2 = [
  square2x2.copyWith(grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(5, 3),
  square2x2.copyWith(
      polyColor: Colors.blue, grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(3, 3),
  square2x2.copyWith(
      polyColor: Colors.blue, grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(7, 3),
  square2x2.copyWith(
      polyColor: Colors.blue, grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(5, 1),
  square2x2.copyWith(
      polyColor: Colors.blue, grid: solutionGrid, isDraggable: false)
    ..initialPosition = Vector2(5, 5),
];

List<SnappablePolygon> question3 = [
  triangle.copyWith(polyColor: Colors.red, rotation: 90)
    ..initialPosition = Vector2(1, 0),
  triangle.copyWith(polyColor: Colors.black, rotation: 270)
    ..initialPosition = Vector2(1, 6),
  triangle.copyWith(polyColor: Colors.orange)..initialPosition = Vector2(4, 4),
  triangle.copyWith(polyColor: Colors.yellow, rotation: 180)
    ..initialPosition = Vector2(1, 4),
];
List<SnappablePolygon> answer3 = question3.map((e) {
  return e.copyWith(grid: solutionGrid, isDraggable: false)
    ..initialPosition = answer3pos[question3.indexOf(e)];
}).toList();
List<Vector2> answer3pos = [
  Vector2(6, 1),
  Vector2(4, 3),
  Vector2(4, 1),
  Vector2(6, 3),
];

List<List<SnappablePolygon>> questions = [question1, question2, question3];
List<List<SnappablePolygon>> answers = [answer1, answer2, answer3];
