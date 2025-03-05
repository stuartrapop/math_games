import 'dart:ui';

import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/suite/components/interface_snappable_shape.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_circle.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon_with_circular_hole.dart';
import 'package:flame/components.dart';
import 'package:polybool/polybool.dart';

class CellColorClass {
  Map<Color, double> colorDistribution = {};

  void updateColor(Color color, double area) {
    colorDistribution.update(color, (existingArea) => existingArea + area,
        ifAbsent: () => area);
  }

  void normalize() {
    double totalArea = colorDistribution.values.fold(0, (a, b) => a + b);
    if (totalArea > 0) {
      colorDistribution.updateAll((key, value) => value / totalArea);
    }
  }

  @override
  String toString() {
    return colorDistribution.toString();
  }
}

Polygon _polygonIntersectsCell(
    List<Coordinate> polygon, List<Coordinate> cellVertices) {
  final poly1 = Polygon(regions: [polygon]);
  final poly2 = Polygon(regions: [cellVertices]);
  return poly1.intersect(poly2);
}

double _calculatePolygonArea(List<Coordinate> vertices) {
  if (vertices.length < 3) return 0; // Not a valid polygon

  double area = 0.0;
  for (int i = 0; i < vertices.length; i++) {
    Coordinate current = vertices[i];
    Coordinate next = vertices[(i + 1) % vertices.length];
    area += (current.x * next.y) - (next.x * current.y);
  }
  return area.abs() / 2.0; // Always return positive area
}

/// ✅ **Optimized: Process only affected grid cells!**
List<List<CellColorClass>> processGridCells({
  required GridComponent grid,
  required List<InterfaceSnappableShape> shapes,
  required List<Vector2> positions,
}) {
  // ✅ Step 1: Initialize blank grid
  List<List<CellColorClass>> gridColorMap = List.generate(
    grid.rows,
    (_) => List.generate(grid.cols, (_) => CellColorClass()),
  );

  // ✅ Step 2: Process each shape
  for (int i = 0; i < shapes.length; i++) {
    InterfaceSnappableShape shape = shapes[i];
    Vector2 position = positions[i];

    // 🔹 Handle **SnappableCircle**
    if (shape is SnappableCircle) {
      _processCircle(shape, position, grid, gridColorMap);
    }
    // 🔹 Handle **SnappablePolygonWithCircularHole** (treated like a polygon)
    else if (shape is SnappablePolygonWithCircularHole ||
        shape is SnappablePolygon) {
      _processPolygon(shape, position, grid, gridColorMap);
    }
  }

  // ✅ Step 3: Normalize color percentages
  for (var row in gridColorMap) {
    for (var cell in row) {
      cell.normalize();
    }
  }

  return gridColorMap;
}

void _processCircle(
  SnappableCircle circle,
  Vector2 position,
  GridComponent grid,
  List<List<CellColorClass>> gridColorMap,
) {
  double radiusInGridUnits = circle.radius / grid.gridSize;
  Vector2 circleCenter =
      position + Vector2(radiusInGridUnits, radiusInGridUnits);

  int minCol = (circleCenter.x - radiusInGridUnits).floor();
  int maxCol = (circleCenter.x + radiusInGridUnits).ceil();
  int minRow = (circleCenter.y - radiusInGridUnits).floor();
  int maxRow = (circleCenter.y + radiusInGridUnits).ceil();

  for (int col = minCol; col < maxCol; col++) {
    for (int row = minRow; row < maxRow; row++) {
      if (col < 0 || row < 0 || col >= grid.cols || row >= grid.rows) {
        continue; // 🔹 Skip out-of-bounds cells
      }

      // 🔥 Convert grid cell to coordinates
      List<Vector2> cellVertices = [
        Vector2(col.toDouble(), row.toDouble()),
        Vector2(col.toDouble() + 1, row.toDouble()),
        Vector2(col.toDouble() + 1, row.toDouble() + 1),
        Vector2(col.toDouble(), row.toDouble() + 1),
      ];

      // 🔹 Check if **circle overlaps the cell**
      if (_circleIntersectsCell(
          circleCenter, radiusInGridUnits, cellVertices)) {
        double area = _calculateCircleCellOverlap(
            circleCenter, radiusInGridUnits, cellVertices);
        gridColorMap[row][col].updateColor(circle.color, area);
      }
    }
  }
}

void _processPolygon(
  InterfaceSnappableShape polygon,
  Vector2 position,
  GridComponent grid,
  List<List<CellColorClass>> gridColorMap,
) {
  double width = polygon.size.x / grid.gridSize;
  double height = polygon.size.y / grid.gridSize;

  int minCol = (position.x).floor();
  int maxCol = ((position.x + width)).ceil();
  int minRow = (position.y).floor();
  int maxRow = ((position.y + height)).ceil();

  for (int col = minCol; col < maxCol; col++) {
    for (int row = minRow; row < maxRow; row++) {
      if (col < 0 || row < 0 || col >= grid.cols || row >= grid.rows) {
        continue;
      }

      List<Coordinate> cellVertices = [
        Coordinate(col.toDouble(), row.toDouble()),
        Coordinate(col.toDouble() + 1, row.toDouble()),
        Coordinate(col.toDouble() + 1, row.toDouble() + 1),
        Coordinate(col.toDouble(), row.toDouble() + 1),
      ];

      // 🔹 Convert polygon vertices (Vector2 → Coordinate)
      List<Coordinate> polygonVertices = (polygon is SnappablePolygon)
          ? polygon.adjustedVertices.map((v) {
              return Coordinate(v.x + position.x, v.y + position.y);
            }).toList()
          : (polygon as SnappablePolygonWithCircularHole)
              .adjustedVertices
              .map((v) {
              return Coordinate(v.x + position.x, v.y + position.y);
            }).toList();

      Polygon intersection =
          _polygonIntersectsCell(polygonVertices, cellVertices);
      if (intersection.regions.isNotEmpty) {
        double area = _calculatePolygonArea(intersection.regions.first);
        gridColorMap[row][col].updateColor(polygon.color, area);
      }
    }
  }
}

bool _circleIntersectsCell(
    Vector2 circleCenter, double radius, List<Vector2> cellVertices) {
  for (Vector2 vertex in cellVertices) {
    if (vertex.distanceTo(circleCenter) <= radius) {
      return true;
    }
  }
  return false;
}

double _calculateCircleCellOverlap(
    Vector2 circleCenter, double radius, List<Vector2> cellVertices) {
  int insidePoints =
      cellVertices.where((v) => v.distanceTo(circleCenter) <= radius).length;
  return insidePoints / 4.0; // 🔥 Returns overlap ratio (0-1)
}

/// ✅ **Compare Two Processed Grids (Top & Bottom)**
bool compareGrids({
  required GridComponent grid,
  required List<InterfaceSnappableShape> questions,
  required List<Vector2> questionPositions,
  required List<Vector2> answerPositions,
  double tolerance = 0.01, // Allow 1% difference
}) {
  Stopwatch stopwatch = Stopwatch()..start(); // ⏳ Start measuring

  print("🔵 Starting color processing...");
  // print("QuestionPosition for comparison: $questionPositions");
  List<List<CellColorClass>> questionGrid = processGridCells(
      grid: grid, shapes: questions, positions: questionPositions);
  List<List<CellColorClass>> answerGrid = processGridCells(
      grid: grid, shapes: questions, positions: answerPositions);
  stopwatch.stop();
  print("✅ Color processing completed in ${stopwatch.elapsedMilliseconds} ms");

  stopwatch.reset();
  stopwatch.start();
  // print("🔵 Starting grid comparison...");

  // ✅ Compare Each Grid Cell
  for (int row = 0; row < grid.rows; row++) {
    for (int col = 0; col < grid.cols; col++) {
      CellColorClass questionCell = questionGrid[row][col];
      CellColorClass answerCell = answerGrid[row][col];

      // print("🔍 Comparing Cell [${col}, ${row}]");
      // print("   Question: ${questionCell.colorDistribution}");
      // print("   Answer  : ${answerCell.colorDistribution}");

      if (!_colorDistributionsMatch(questionCell.colorDistribution,
          answerCell.colorDistribution, tolerance, 0.2, 0.0)) {
        print("❌ Mismatch at [${col}, ${row}]");
        stopwatch.stop();
        print(
            "✅ Grid comparison completed in ${stopwatch.elapsedMilliseconds} ms");
        return false;
      }
    }
  }

  stopwatch.stop();
  print("✅ Grid comparison completed in ${stopwatch.elapsedMilliseconds} ms");

  print("✅ Grids Match!");
  return true;
}

/// **Color Comparison With Tolerance**
// bool _colorDistributionsMatch(
//     Map<Color, double> a, Map<Color, double> b, double tolerance) {r
//   for (var color in a.keys) {
//     double aPercentage = a[color] ?? 0;
//     double bPercentage = b[color] ?? 0;
//     if ((aPercentage - bPercentage).abs() > tolerance) return false;
//   }
//   return true;
// }

bool _colorDistributionsMatch(
    Map<Color, double> a,
    Map<Color, double> b,
    double tolerance,
    double areaTolerance, // ✅ New: Allows slight area difference
    double minCoverageThreshold // ✅ New: Minimum required coverage
    ) {
  // 🔹 First, ensure the color distributions match within tolerance
  for (var color in a.keys) {
    double aPercentage = a[color] ?? 0;
    double bPercentage = b[color] ?? 0;
    if ((aPercentage - bPercentage).abs() > tolerance) return false;
  }
  // area test might be too much
  // 🔹 Then, check total area coverage consistency
  double totalCoverageA = a.values.fold(0, (sum, v) => sum + v);
  double totalCoverageB = b.values.fold(0, (sum, v) => sum + v);

  // ✅ Ensure the total area covered is close within `areaTolerance`
  if ((totalCoverageA - totalCoverageB).abs() > areaTolerance) return false;

  // ✅ Ensure both cells have at least some coverage (avoids false positives)
  if (totalCoverageA < minCoverageThreshold ||
      totalCoverageB < minCoverageThreshold) {
    return false;
  }

  return true; // 🎯 Both color & area match!
}
