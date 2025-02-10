import 'dart:async';
import 'dart:math';

import 'package:first_math/suite/check_collision_polygon.dart';
import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SnappablePolygon extends PositionComponent
    with DragCallbacks, TapCallbacks, GestureHitboxes, HasGameRef<SuiteGame> {
  late GridComponent grid;
  late Vector2 initialPosition = Vector2.zero();
  late Color color = Colors.white;
  double scaleWidth = 1.0;
  double scaleHeight = 1.0;
  double rotation = 0.0;

  late final double polygonWidth;
  late final double polygonHeight;
  late final List<Vector2> adjustedVertices;
  late final List<Vector2> adjustedInnerVertices;
  Vector2? lastValidPosition;
  late Vector2 topLeft;

  final List<Vector2> vertices;
  List<Vector2> innerVertices;
  bool isDraggable;
  SnappablePolygon({
    required this.vertices,
    this.innerVertices = const [],
    this.isDraggable = true,
  });
  SnappablePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    Color? color,
    GridComponent? grid,
    double? scaleWidth,
    double? scaleHeight,
    bool? isDraggable,
    double? rotation,
  }) {
    return SnappablePolygon(
      vertices: vertices != null
          ? vertices.map((v) => v.clone()).toList()
          : this.vertices.map((v) => v.clone()).toList(),
      innerVertices:
          innerVertices ?? this.innerVertices.map((v) => v.clone()).toList(),
      isDraggable: isDraggable ?? this.isDraggable,
    )
      ..grid = grid ?? this.grid
      ..color = color ?? this.color
      ..scaleWidth = scaleWidth ?? this.scaleWidth
      ..scaleHeight = scaleHeight ?? this.scaleHeight
      ..rotation = rotation ?? this.rotation
      ..initialPosition = initialPosition.clone();
  }

  bool isCounterClockwise(Vector2 a, Vector2 b, Vector2 c) {
    double crossProduct = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    return crossProduct > 0; // CCW if positive, CW if negative
  }

  @override
  Future<void> onLoad() {
    debugMode = true; // Show bounding box

    final List<Vector2> rotatedVertices = rotateVertices(vertices, rotation);
    final List<Vector2> rotatedInnverVertices =
        rotateVertices(innerVertices, rotation);
    topLeft = _getTopLeft(rotatedVertices);
    adjustedVertices = rotatedVertices.map((v) {
      Vector2 shifted = (v - topLeft);
      Vector2 scaled =
          Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight) *
              grid.gridSize.toDouble();
      return scaled;
    }).toList();
    adjustedInnerVertices = rotatedInnverVertices.map((v) {
      Vector2 shifted = (v - topLeft);
      Vector2 scaled =
          Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight) *
              grid.gridSize.toDouble();
      return scaled;
    }).toList();

    polygonWidth = _getPolygonWidth(adjustedVertices);
    polygonHeight = _getPolygonHeight(adjustedVertices);
    final Vector2 initialPixelPosition = getClosestGridPoint(
        initialPosition * grid.gridSize.toDouble() + grid.position);
    position = initialPixelPosition;
    size = Vector2(polygonWidth, polygonHeight);
    print(rotatedInnverVertices);

    // ✅ Create a PolygonHitbox from adjustedVertices
    print("adjustedVertices: $adjustedVertices");

    // ✅ Create a **non-solid** hitbox for the hole to block drag inside it
    if (adjustedInnerVertices.isNotEmpty) {
      print("adjustedInnerVertices: $adjustedInnerVertices");
      final triangles = triangulatePolygonWithHoles(
          outerPolygon: adjustedVertices, holes: [adjustedInnerVertices]);
      print("triangles: $triangles");
      for (int i = 0; i < triangles.length; i++) {
        final relativeTriangle = triangles[i].map((v) => v - topLeft).toList();
        if (true) {
          add(PolygonHitbox(relativeTriangle, isSolid: false)
            ..anchor = Anchor.topLeft);
        }
      }
    } else {
      add(PolygonHitbox(adjustedVertices, isSolid: true));
    }

    anchor = Anchor.topLeft;
    return super.onLoad();
  }

  /// **Create multiple hitboxes that exclude the hole**

  /// **Check if a triangle is fully inside the hole**
  bool isTriangleInsideHole(List<Vector2> triangle, List<Vector2> hole) {
    for (var vertex in triangle) {
      if (!pointInPolygon(vertex, hole)) {
        return false; // ✅ At least one vertex is outside → Not fully inside hole
      }
    }
    return true; // ❌ All vertices are inside → Ignore this triangle
  }

  /// **Check if a point is inside a polygon (Ray-Casting Algorithm)**
  bool pointInPolygon(Vector2 point, List<Vector2> polygon) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      Vector2 a = polygon[i];
      Vector2 b = polygon[(i + 1) % polygon.length];

      if ((a.y > point.y) != (b.y > point.y) &&
          point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x) {
        intersections++;
      }
    }
    return (intersections % 2) != 0;
  }

  List<Vector2> rotateVertices(List<Vector2> vertices, double angleInDegrees) {
    final double radians = angleInDegrees *
        (3.141592653589793 / 180.0); // Convert degrees to radians
    final double cosA = cos(radians);
    final double sinA = sin(radians);

    return vertices.map((v) {
      return Vector2(
          v.x * cosA - v.y * sinA, // Rotate X
          v.x * sinA + v.y * cosA // Rotate Y
          );
    }).toList();
  }

  @override
  void onDragStart(DragStartEvent event) {
    final localPoint = event.localPosition;
    print("🖱 Drag Start Event at $localPoint");
    if (!isDraggable) return;

    lastValidPosition = position.clone();
    super.onDragStart(event);
  }

  double calculatePolygonArea(List<Vector2> vertices) {
    if (vertices.length < 3) return 0; // Not a valid polygon

    double area = 0.0;

    for (int i = 0; i < vertices.length; i++) {
      Vector2 current = vertices[i];
      Vector2 next = vertices[(i + 1) % vertices.length];

      area += (current.x * next.y) - (next.x * current.y);
    }

    return area.abs() / 2.0; // Always return positive area
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("on Tap Down");
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    final Vector2 newPosition = position + event.delta;
    position = _clampToGrid(newPosition);
    // position = _clampToGrid(newPosition);
  }

  void printPolygonsOnGrid(GridComponent targetGrid) {
    final world = gameRef.world;
    final allPolygons = world.children.whereType<SnappablePolygon>().toList();
    final polygonsOnGrid =
        allPolygons.where((polygon) => polygon.grid == targetGrid).toList();

    print(
        "📌 Found ${polygonsOnGrid.length} SnappablePolygons on the target grid:");
    for (var polygon in polygonsOnGrid) {
      print(polygon.toPrint());
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDraggable) return;
    final world = gameRef.world;
    final Vector2 snappedPosition = getClosestGridPoint(_clampToGrid(position));
    position = snappedPosition;

    // Check for overlaps with other polygons
    bool hasOverlap = false;

    for (var component in world.children) {
      if (component is SnappablePolygon && component != this) {
        if (checkOverlap(component, this)) {
          hasOverlap = true;
          break;
        }
      }
    }
    // 🔥 Print all SnappablePolygons
    // printPolygonsOnGrid(grid);
    // If there's an overlap, revert to the last valid position
    if (hasOverlap && lastValidPosition != null) {
      position = lastValidPosition!;
      print("Overlap detected! Reverting to previous position");
    }

    super.onDragEnd(event);
  }

  /// **Ensure the entire polygon stays within grid bounds**
  Vector2 _clampToGrid(Vector2 position) {
    final minX = grid.position.x;
    final maxX = grid.position.x + grid.gridSize * grid.cols - polygonWidth;

    final minY = grid.position.y;
    final maxY = grid.position.y + grid.gridSize * grid.rows - polygonHeight;

    return Vector2(
      position.x.clamp(minX, maxX),
      position.y.clamp(minY, maxY),
    );
  }

  /// **Finds the top-left vertex in a given set of vertices**
  Vector2 _getTopLeft(List<Vector2> vertices) {
    double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
    double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
    return Vector2(minX, minY);
  }

  /// **Calculate polygon width from its vertices**
  double _getPolygonWidth(List<Vector2> vertices) {
    double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
    double maxX = vertices.map((v) => v.x).reduce((a, b) => a > b ? a : b);
    return maxX - minX;
  }

  /// **Calculate polygon height from its vertices**
  double _getPolygonHeight(List<Vector2> vertices) {
    double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
    double maxY = vertices.map((v) => v.y).reduce((a, b) => a > b ? a : b);
    return maxY - minY;
  }

  /// **Snap the polygon's top-left vertex to the closest grid point**
  Vector2 getClosestGridPoint(Vector2 position) {
    double x = ((position.x - grid.position.x) / grid.gridSize).round() *
            grid.gridSize +
        grid.position.x;
    double y = ((position.y - grid.position.y) / grid.gridSize).round() *
            grid.gridSize +
        grid.position.y;
    return Vector2(x, y);
  }

  @override
  void render(Canvas canvas) {
    final outerPaint = Paint()..color = color;
    final path = Path();

    // Draw the outer polygon
    path.moveTo(adjustedVertices.first.x, adjustedVertices.first.y);
    for (var vertex in adjustedVertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();

    // If there are inner vertices, create a hole
    if (adjustedInnerVertices.isNotEmpty) {
      // Save the canvas layer to allow blending effects
      canvas.saveLayer(null, Paint());

      // Draw the outer shape
      canvas.drawPath(path, outerPaint);

      // Create a hole using an inverse clipping path
      final holePath = Path()
        ..moveTo(adjustedInnerVertices.first.x, adjustedInnerVertices.first.y);
      for (var vertex in adjustedInnerVertices.skip(1)) {
        holePath.lineTo(vertex.x, vertex.y);
      }
      holePath.close();

      // Use BlendMode.clear to cut out the hole
      final holePaint = Paint()..blendMode = BlendMode.clear;
      canvas.drawPath(holePath, holePaint);

      // Restore the canvas to apply the blend mode
      canvas.restore();
    } else {
      // If no inner vertices, just draw the main shape normally
      canvas.drawPath(path, outerPaint);
    }
    super.render(canvas);
  }

  String toPrint() {
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    return "Polygon at grid position: (${((position.x - grid.position.x) / grid.gridSize).round()}, ${((position.y - grid.position.y) / grid.gridSize).round()})"
        "\n  - Color: RGB($r, $g, $b)"
        "\n  - Scale: (Width: $scaleWidth, Height: $scaleHeight)"
        "\n  - Rotation: $rotation degrees";
  }
}
