import 'dart:math';
import 'dart:ui';

import 'package:first_math/utils/bounderies.dart';
import 'package:flame/components.dart';
import 'package:geobase/geobase.dart';

PositionSeries rotatePolygon({
  required PositionSeries source,
  required double rotation,
  required Position polyLabeCenter,
  required double yAxisRotation,
}) {
  T rotateSeries<T extends Position>(
    Position source, {
    required CreatePosition<T> to,
  }) {
    final translatedX = source.x - polyLabeCenter.x;
    final translatedY = source.y - polyLabeCenter.y;
    final rotatedX = translatedX * cos(rotation) - translatedY * sin(rotation);
    final rotatedY = translatedX * sin(rotation) + translatedY * cos(rotation);
    return to.call(
      x: rotatedX,
      y: rotatedY,
    );
  }

  final rotatedSeries = source.transform(rotateSeries);
  final rotatedYAxisSeries = rotateSeriesAroundYAxisTo2D(
    series: rotatedSeries,
    angle: yAxisRotation,
  );

  return rotatedYAxisSeries;
}

PositionSeries scalePolygon({
  required PositionSeries source,
  required double radius,
}) {
  // Find the center of the polygon using polylabel2D
  source = source * 100;
  final originalPolyCenter = Polygon([source]).polylabel2D().position;

  // Translate the polygon so the polylabel2D center is at (0, 0)
  final centeredPositions = source.positions.map((point) {
    final dx = point.x - originalPolyCenter.x;
    final dy = point.y - originalPolyCenter.y;
    return Position.create(x: dx, y: dy);
  }).toList();

  final centeredSeries = PositionSeries.from(centeredPositions);
  double calculateFarthestDistance(PositionSeries positions) {
    return positions.positions.map((point) {
      return sqrt(point.x * point.x + point.y * point.y);
    }).reduce((a, b) => max(a, b));
  }

  final maxDistance = calculateFarthestDistance(centeredSeries);

  final scale = radius / maxDistance;

  final scaledSeries = centeredSeries * scale;

  return scaledSeries;
}

PositionSeries offsetPolygon({
  required PositionSeries source,
  required Position center,
  required Vector2 size,
}) {
  double xOffset = -(center.x) + size.x / 2;
  double yOffset = -(center.y) + size.y / 2;

  T offsetSeries<T extends Position>(
    Position source, {
    required CreatePosition<T> to,
  }) {
    return to.call(
      x: source.x + xOffset,
      y: source.y + yOffset,
    );
  }

  return source.transform(offsetSeries);
}

Path positionSeriesToPath(
    PositionSeries positionSeries, Vector2 componentSize) {
  final path = Path();

  if (positionSeries.valueCount == 0) {
    return path; // Return an empty path if the PositionSeries is empty
  }

  // Center offset to align the geometry with the center of the component
  final centerOffset = componentSize / 2;

  // Iterate through the positions in the series
  for (int i = 0; i < positionSeries.valueCount / 2; i++) {
    final position = positionSeries[i];
    final x = position.x.toDouble() + centerOffset.x;
    final y = position.y.toDouble() + centerOffset.y;

    if (i == 0) {
      // Move to the first point
      path.moveTo(x, y);
    } else {
      // Draw a line to subsequent points
      path.lineTo(x, y);
    }
  }

  // Close the path to complete the polygon
  path.close();

  return path;
}

List<Vector2> positionSeriesToVertices(PositionSeries positionSeries) {
  final vertices = <Vector2>[];

  for (int i = 0; i < positionSeries.valueCount / 2; i++) {
    vertices.add(Vector2(
      positionSeries[i].x.toDouble(),
      positionSeries[i].y.toDouble(),
    ));
  }

  return vertices;
}

List<Vector3> positionSeriesToVector3(PositionSeries positionSeries) {
  return positionSeries.positions.map((position) {
    return Vector3(
        position.x, position.y, 0.0); // Convert to Vector3 with z = 0
  }).toList();
}

PositionSeries rotateSeriesAroundYAxisTo2D(
    {required PositionSeries series, required double angle}) {
  // Create the rotation matrix for the Y-axis
  Matrix4 rotationMatrix = Matrix4.rotationY(angle);

  // Convert the PositionSeries to Vector3 points, apply the rotation, and return as PositionSeries
  final rotatedPositions = series.positions.map((position) {
    Vector3 point = Vector3(position.x, position.y, 0.0);
    Vector3 transformedPoint = rotationMatrix.transform3(point);
    return Position.create(x: transformedPoint.x, y: transformedPoint.y);
  }).toList();

  return PositionSeries.from(rotatedPositions);
}

List<Wall> polygonToWalls(
    {required PositionSeries polygon, double strokeWidth = 1}) {
  final walls = <Wall>[];

  final points = polygon.valueCount / 2;
  if (points < 2) {
    throw ArgumentError(
        'Polygon must have at least two points to create walls.');
  }

  for (int i = 0; i < polygon.valueCount / 2; i++) {
    final start = Vector2(polygon[i].x.toDouble(), polygon[i].y.toDouble());
    final end = Vector2(
      polygon[(i + 1) % (polygon.valueCount / 2).toInt()].x.toDouble(),
      polygon[(i + 1) % (polygon.valueCount / 2).toInt()].y.toDouble(),
    );

    walls.add(Wall(start, end, strokeWidth: strokeWidth));
  }

  return walls;
}
