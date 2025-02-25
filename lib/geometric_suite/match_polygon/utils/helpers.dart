import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:flame/components.dart';

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
