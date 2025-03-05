import 'package:flame/components.dart';

typedef V = Vector2;
final List<Vector2> squareVertices = [
  V(0, 0), // Top-left (snap reference)
  V(1, 0),
  V(1, 1),
  V(0, 1),
];

List<Vector2> octogonalVertices = [
  V(1, 0),
  V(2, 0),
  V(3, 1),
  V(3, 2),
  V(2, 3),
  V(1, 3),
  V(0, 2),
  V(0, 1)
];

List<Vector2> hexagonalVertices = [
  V(1, 0),
  V(2, 0),
  V(3, 1),
  V(3, 2),
  V(2, 3),
  V(1, 3),
  V(0, 2),
  V(0, 1)
];

List<Vector2> polygon5Vertices = [
  V(1, 0),
  V(2, 0),
  V(2, 1),
  V(2, 2),
  V(1, 2),
  V(0, 1),
];

List<Vector2> triangleVertices = [
  V(0, 1), // Top-left (snap reference)
  V(1, 0),
  V(1, 1),
];

List<Vector2> parallagramVertices = [
  V(1, 0), // Top-left (snap reference)
  V(4, 0),
  V(3, 2),
  V(0, 2)
];

List<Vector2> lShapeVertices = [
  V(0, 0), // Top-left (snap reference)
  V(3, 0),
  V(3, 1),
  V(1, 1),
  V(1, 2),
  V(0, 2)
];
