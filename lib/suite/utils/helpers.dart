import 'package:first_math/suite/components/grid_component.dart';
import 'package:flame/components.dart';

/// **Finds the top-left vertex in a given set of vertices**
Vector2 getTopLeft(List<Vector2> vertices) {
  double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
  double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
  return Vector2(minX, minY);
}

/// **Calculate polygon width from its vertices**
double getPolygonWidth(List<Vector2> vertices) {
  double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
  double maxX = vertices.map((v) => v.x).reduce((a, b) => a > b ? a : b);
  return maxX - minX;
}

/// **Calculate polygon height from its vertices**
double getPolygonHeight(List<Vector2> vertices) {
  double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
  double maxY = vertices.map((v) => v.y).reduce((a, b) => a > b ? a : b);
  return maxY - minY;
}

/// **Snap the polygon's top-left vertex to the closest grid point**
Vector2 getClosestGridPoint({
  required Vector2 position,
  required GridComponent grid,
}) {
  double x = ((position.x) / grid.gridSize).round() * grid.gridSize.toDouble();
  double y = ((position.y) / grid.gridSize).round() * grid.gridSize.toDouble();
  return Vector2(x, y);
}

/// **Ensure the entire polygon stays within grid bounds**
Vector2 clampToGrid({
  required Vector2 position,
  required GridComponent grid,
  required double polygonWidth,
  required double polygonHeight,
}) {
  final minX = 0.0;
  final maxX = grid.gridSize * grid.cols - polygonWidth;

  final minY = 0.0;
  final maxY = grid.gridSize * grid.rows - polygonHeight;

  return Vector2(
    position.x.clamp(minX, maxX),
    position.y.clamp(minY, maxY),
  );
}
