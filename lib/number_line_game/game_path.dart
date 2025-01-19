import 'dart:math';

import 'package:flutter/material.dart';

class GamePath {
  late Path path;
  final Size gameSize;
  final double pathRadius;
  final double innerRadius; // Minimum radius for the hollow center

  GamePath(
      {required this.gameSize,
      this.pathRadius = 200.0,
      this.innerRadius = 180.0}) {
    path = _createGamePath();
  }
  Path _createGamePath() {
    final center = Offset(gameSize.width / 2, gameSize.height / 2);
    final path = Path();

    const totalRotations = 2.0;
    const totalPoints = 300; // Increased for smoother curve

    // Parameters for Archimedean spiral
    final a = pathRadius / (1.2 * pi * totalRotations); // Growth factor
    final startAngle = 2.5 * pi * totalRotations; // Start from outside

    // Start from the outermost point
    final firstRadius = a * startAngle;
    final firstX = center.dx + firstRadius * cos(startAngle);
    final firstY = center.dy + firstRadius * sin(startAngle);
    path.moveTo(firstX, firstY);

    // Create spiral going inward, stopping at the inner radius
    for (int i = 1; i <= totalPoints; i++) {
      final progress = i / totalPoints;
      final angle = startAngle * (1 - progress); // Go from outer to inner

      // In Archimedean spiral, radius is directly proportional to angle
      final radius = a * angle;

      if (radius < innerRadius) {
        break; // Stop drawing if the radius is smaller than the innerRadius
      }

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      path.lineTo(x, y);
    }

    return path;
  }

  Offset? getPositionAtDistance(double distance) {
    try {
      if (gameSize.isEmpty) {
        print("Error: Game size is empty.");
        return null;
      }
      // Check if the path is valid and has metrics
      if (path == null || path.computeMetrics().isEmpty) {
        print("Error: Path is null or empty.");
        return null;
      }

      // Get the first metric of the path
      final pathMetrics = path.computeMetrics();
      final pathMetric = pathMetrics.first;

      // Ensure the distance is within the valid range
      if (distance < 0 || distance > pathMetric.length) {
        print(
            "Error: Distance is out of bounds. Valid range is 0 to ${pathMetric.length}, got $distance");
        return null;
      }

      final tangent = pathMetric.getTangentForOffset(distance);
      return tangent?.position ?? Offset.zero;
    } catch (e) {
      print("Error in getPositionAtDistance: $e");
    }
    return null;
  }

  // Get total path length
  double get length {
    return path.computeMetrics().first.length;
  }

  double? getDistanceOnPath(Offset point, double threshold) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final length = metric.length;

      for (double distance = 0; distance <= length; distance += 1.0) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          final distanceToPath = (tangent.position - point).distance;
          if (distanceToPath <= threshold) {
            return distance;
          }
        }
      }
    }
    return null;
  }
}
