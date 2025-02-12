import 'dart:async';
import 'dart:math';

import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:first_math/suite/suite_world.dart';
import 'package:first_math/suite/utils/check_collision_polygon.dart';
import 'package:first_math/suite/utils/helpers.dart';
import 'package:first_math/suite/utils/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SnappablePolygon extends PositionComponent
    with DragCallbacks, TapCallbacks, GestureHitboxes, HasGameRef<SuiteGame> {
  GridComponent grid;
  late Color color = Colors.white;
  double scaleWidth = 1.0;
  double scaleHeight = 1.0;
  double rotation = 0.0;
  int questionIndex;
  int polygonIndex;

  late final double polygonWidth;
  late final double polygonHeight;
  late final List<Vector2> adjustedVertices;
  late final List<Vector2> adjustedInnerVertices;
  Vector2? lastValidPosition;
  late Vector2 topLeft;
  final holePaint = Paint()..blendMode = BlendMode.clear;
  final Paint hightLightPaint = Paint()
    ..color = Colors.white54
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  late final Paint outerPaint;
  late final Path path;

  final List<Vector2> vertices;
  List<Vector2> innerVertices;
  Vector2? upperLeftPosition;
  bool isDraggable;

  SnappablePolygon({
    required this.vertices,
    required this.grid,
    this.upperLeftPosition,
    this.questionIndex = -1,
    this.polygonIndex = -1,
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
    int? questionIndex,
    int? polygonIndex,
    Vector2? upperLeftPosition,
  }) {
    return SnappablePolygon(
      grid: grid ?? this.grid,
      vertices: vertices != null
          ? vertices.map((v) => v.clone()).toList()
          : this.vertices.map((v) => v.clone()).toList(),
      innerVertices:
          innerVertices ?? this.innerVertices.map((v) => v.clone()).toList(),
      isDraggable: isDraggable ?? this.isDraggable,
      questionIndex: questionIndex ?? this.questionIndex,
      polygonIndex: polygonIndex ?? this.polygonIndex,
      upperLeftPosition: upperLeftPosition ?? this.upperLeftPosition,
    )
      ..color = color ?? this.color
      ..scaleWidth = scaleWidth ?? this.scaleWidth
      ..scaleHeight = scaleHeight ?? this.scaleHeight
      ..rotation = rotation ?? this.rotation;
  }

  List<Vector2> shiftAndScaleVertice({
    required List<Vector2> vertices,
    required Vector2 topLeft,
    required double scaleWidth,
    required double scaleHeight,
  }) {
    return vertices.map((v) {
      Vector2 shifted = (v - topLeft);
      Vector2 scaled =
          Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight) *
              grid.gridSize.toDouble();
      return scaled;
    }).toList();
  }

  void addHitBoxes({
    required List<Vector2> outerVertices,
    required List<Vector2> innerVertices,
    required Vector2 topLeft,
  }) {
    if (adjustedInnerVertices.isNotEmpty) {
      final triangles = triangulatePolygonWithHoles(
          outerPolygon: adjustedVertices, holes: [adjustedInnerVertices]);
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
  }

  @override
  Future<void> onLoad() {
    debugMode = true; // Show bounding box

    final List<Vector2> rotatedVertices = rotateVertices(vertices, rotation);
    final List<Vector2> rotatedInnverVertices =
        rotateVertices(innerVertices, rotation);
    topLeft = getTopLeft(rotatedVertices);
    adjustedVertices = shiftAndScaleVertice(
      vertices: rotatedVertices,
      topLeft: topLeft,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );
    adjustedInnerVertices = shiftAndScaleVertice(
      vertices: rotatedInnverVertices,
      topLeft: topLeft,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );
    polygonWidth = getPolygonWidth(adjustedVertices);
    polygonHeight = getPolygonHeight(adjustedVertices);
    position = upperLeftPosition! * grid.gridSize.toDouble();
    size = Vector2(polygonWidth, polygonHeight);
    addHitBoxes(
      innerVertices: adjustedInnerVertices,
      outerVertices: adjustedVertices,
      topLeft: topLeft,
    );
    anchor = Anchor.topLeft;
    path = Path();

    // Draw the outer polygon
    path.moveTo(adjustedVertices.first.x, adjustedVertices.first.y);
    for (var vertex in adjustedVertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();
    outerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0, 1],
        colors: [
          Color.alphaBlend(color.withOpacity(0.8), Colors.white),
          color
        ], // White to Polygon Color
      ).createShader(path.getBounds());
    ;
    return super.onLoad();
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

  @override
  void onTapDown(TapDownEvent event) {
    print("on Tap Down");
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    final Vector2 newPosition = position + event.delta;
    position = newPosition;
    print("position: $position");

    position = clampToGrid(
      position: newPosition,
      grid: grid,
      polygonWidth: polygonWidth,
      polygonHeight: polygonHeight,
    );
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDraggable) return;
    final world = gameRef.world as SuiteWorld;
    final Vector2 snappedPosition = getClosestGridPoint(
        position: clampToGrid(
          position: position,
          grid: grid,
          polygonWidth: polygonWidth,
          polygonHeight: polygonHeight,
        ),
        grid: grid);
    position = snappedPosition;

    // Check for overlaps with other polygons
    bool hasOverlap = false;

    for (var component in grid.children) {
      if (component is SnappablePolygon && component != this) {
        if (checkOverlap(component, this)) {
          hasOverlap = true;
          break;
        }
      }
    }
    // If there's an overlap, revert to the last valid position
    printPolygonsOnGrid(grid);
    if (hasOverlap && lastValidPosition != null) {
      position = lastValidPosition!;
      print("Overlap detected! Reverting to previous position");
    }
    print("before remove");
    world.removePolygons();
    print("position: ${(position - grid.position) / grid.gridSize.toDouble()}");
    gameRef.suiteBloc.add(PolygonMoved(
      questionIndex: questionIndex,
      polygonIndex: polygonIndex,
      newPosition: (position) / grid.gridSize.toDouble(),
    ));

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    if (adjustedInnerVertices.isNotEmpty) {
      // Save the canvas layer to allow blending effects
      canvas.saveLayer(null, Paint());
      canvas.drawPath(path, outerPaint);
      final holePath = Path()
        ..moveTo(adjustedInnerVertices.first.x, adjustedInnerVertices.first.y);
      for (var vertex in adjustedInnerVertices.skip(1)) {
        holePath.lineTo(vertex.x, vertex.y);
      }
      holePath.close();
      canvas.drawPath(holePath, holePaint);
      canvas.drawPath(holePath, hightLightPaint);
      canvas.restore();
    } else {
      canvas.drawPath(path, outerPaint);
    }
    canvas.drawPath(path, hightLightPaint);
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
