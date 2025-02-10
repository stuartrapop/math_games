import 'dart:math';

import 'package:dart_earcut/dart_earcut.dart';
import 'package:first_math/suite/check_collision_polygon.dart' hide Vector2;
import 'package:first_math/suite/components/grid_component.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class SnappablePolygon extends BodyComponent
    with DragCallbacks, ContactCallbacks, TapCallbacks {
  late GridComponent grid;
  late Vector2 initialPosition = Vector2.zero();
  late Color color = Colors.white;
  double scaleWidth = 1.0;
  double scaleHeight = 1.0;
  double rotation = 0.0;

  late final double polygonWidth;
  late final double polygonHeight;
  late final List<Vector2> adjustedVertices;
  Vector2? lastValidPosition;

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

  @override
  Body createBody() {
    final List<Vector2> rotatedVertices = rotateVertices(vertices, rotation);
    final Vector2 topLeft = _getTopLeft(rotatedVertices);
    adjustedVertices = rotatedVertices.map((v) {
      Vector2 shifted = (v - topLeft);
      Vector2 scaled =
          Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight) *
              grid.gridSize.toDouble();

      return scaled;
    }).toList();

    polygonWidth = _getPolygonWidth(adjustedVertices);
    polygonHeight = _getPolygonHeight(adjustedVertices);

    // ✅ Convert initial position from unit space to pixel space
    final Vector2 initialPixelPosition = getClosestGridPoint(
        initialPosition * grid.gridSize.toDouble() + grid.position);

    final bodyDef = BodyDef(
      userData: isDraggable ? this : null,
      position: initialPixelPosition,
      type: BodyType.static,
      gravityScale: Vector2.zero(), // Disable gravity
      fixedRotation: true,
    );

    final shape = PolygonShape()..set(adjustedVertices);
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0 // Set density to 0
      ..restitution = 0.0 // No bounce
      ..friction = 0.0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
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

  bool checkOverlap(SnappablePolygon other, SnappablePolygon draggedPolygon) {
    List<Vector2> thisPolygon =
        draggedPolygon.adjustedVertices.map((v) => v + body.position).toList();
    List<Vector2> otherPolygon =
        other.adjustedVertices.map((v) => v + other.body.position).toList();

    List<List<Vector2>> draggedConvexPolygons = [];
    if (isConvexPolygon(thisPolygon)) {
      draggedConvexPolygons = [thisPolygon];
    } else {
      List<int> indices = Earcut.triangulateFromPoints(
          thisPolygon.map((v) => Point(v.x, v.y)).toList());

      // ✅ Convert index triplets into a list of triangles
      for (int i = 0; i < indices.length; i += 3) {
        draggedConvexPolygons.add([
          thisPolygon[indices[i]],
          thisPolygon[indices[i + 1]],
          thisPolygon[indices[i + 2]],
        ]);
      }
    }

    List<List<Vector2>> otherConvexPolygons = [];
    if (isConvexPolygon(otherPolygon)) {
      otherConvexPolygons = [otherPolygon];
    } else {
      List<int> indices = Earcut.triangulateFromPoints(
          otherPolygon.map((v) => Point(v.x, v.y)).toList());

      // ✅ Convert index triplets into a list of triangles
      for (int i = 0; i < indices.length; i += 3) {
        otherConvexPolygons.add([
          otherPolygon[indices[i]],
          otherPolygon[indices[i + 1]],
          otherPolygon[indices[i + 2]],
        ]);
      }
    }

    print("draggedConvexPolygons: ${draggedConvexPolygons.length}");
    print("otherConvexPolygons: ${otherConvexPolygons.length}");

    for (var draggedConvex in draggedConvexPolygons) {
      for (var otherConvex in otherConvexPolygons) {
        if (isCollidingPolygonPolygon(draggedConvex, otherConvex)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!isDraggable) return;
    lastValidPosition = body.position.clone();
    super.onDragStart(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("on Tap Down");
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    final Vector2 newPosition = body.position + event.delta;
    final Vector2 clampedPosition = _clampToGrid(newPosition);
    body.setTransform(clampedPosition, body.angle);
  }

  void printPolygonsOnGrid(GridComponent targetGrid) {
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

    final Vector2 snappedPosition = getClosestGridPoint(body.position);
    body.setTransform(snappedPosition, body.angle);

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
      body.setTransform(lastValidPosition!, body.angle);
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
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(adjustedVertices.first.x, adjustedVertices.first.y);
    for (var vertex in adjustedVertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  String toPrint() {
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    return "Polygon at grid position: (${((body.position.x - grid.position.x) / grid.gridSize).round()}, ${((body.position.y - grid.position.y) / grid.gridSize).round()})"
        "\n  - Color: RGB($r, $g, $b)"
        "\n  - Scale: (Width: $scaleWidth, Height: $scaleHeight)"
        "\n  - Rotation: $rotation degrees";
  }
}
