import 'dart:math';

import 'package:geobase/geobase.dart';

Position polygonCorner({
  required int i,
  required int sides,
  required double angle,
  double size = 1,
}) {
  if (sides < 3) {
    throw ArgumentError('A polygon must have at least 3 sides.');
  }

  // Center is (0, 0) and size is 1 for simplicity
  const double centerX = 0.0;
  const double centerY = 0.0;

  // Calculate the angle in radians
  final double angleRad = (2 * pi / sides) * i + angle;

  // Compute the corner's x and y coordinates
  final double x = centerX + size * cos(angleRad);
  final double y = centerY + size * sin(angleRad);

  // Return as a Position
  return Position.create(x: x, y: y);
}

PositionSeries regularPolygon({required int sides}) {
  final List<Position> corners = List.generate(
      sides,
      (i) => polygonCorner(
            i: i,
            sides: sides,
            angle: 0,
            size: 0.5,
          ));
  return PositionSeries.from(corners);
}

PositionSeries pointedStar(
    {required int sides, double outerSize = 1, double innerSize = 0.5}) {
  if (sides < 3) {
    throw ArgumentError('A star must have at least 3 sides.');
  }

  final List<Position> points = [];

  for (int i = 0; i < sides; i++) {
    // Add outer corner
    points.add(
      polygonCorner(i: i, sides: sides, angle: 0, size: outerSize),
    );

    // Add inner corner halfway to the next outer corner
    final int nextIndex = (i + 1) % sides;
    final Position outer =
        polygonCorner(i: i, sides: sides, angle: 0, size: outerSize);
    final Position nextOuter =
        polygonCorner(i: nextIndex, sides: sides, angle: 0, size: outerSize);

    final double midX = (outer.x + nextOuter.x) / 2;
    final double midY = (outer.y + nextOuter.y) / 2;

    points.add(Position.create(
        x: midX * innerSize / outerSize, y: midY * innerSize / outerSize));
  }

  return PositionSeries.from(points);
}
