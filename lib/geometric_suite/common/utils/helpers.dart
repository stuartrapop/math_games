import 'package:flame/components.dart';

/// **Finds the top-left vertex in a given set of vertices**
Vector2 getTopLeft(List<Vector2> vertices) {
  double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
  double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
  return Vector2(minX, minY);
}
