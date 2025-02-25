import 'dart:async';
import 'dart:math';

import 'package:first_math/geometric_suite/common/utils/helpers.dart';
import 'package:first_math/geometric_suite/suite/utils/check_collision_polygon.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

abstract class BasePolygon extends PositionComponent
    with DragCallbacks, TapCallbacks, GestureHitboxes, HasPaint {
  late Color color;
  double borderWidth;
  double scaleWidth;
  double scaleHeight;
  double rotation;
  bool flipHorizontal;
  bool flipVertical;
  List<Vector2> vertices;
  List<Vector2> innerVertices;
  late List<Vector2> adjustedVertices;
  late List<Vector2> adjustedInnerVertices;
  late Vector2 topLeft;
  Paint fillPaint = Paint();
  final Paint holePaint = Paint()..blendMode = BlendMode.clear;
  late Paint highlightPaint = Paint();

  late Paint outerPaint;
  Path holePath = Path();
  Path polygonPath = Path();
  Vector2? upperLeftPosition;
  double pixelToUnitRatio;

  BasePolygon({
    required this.vertices,
    required this.pixelToUnitRatio,
    this.innerVertices = const [],
    this.color = Colors.white,
    this.scaleWidth = 1.0,
    this.scaleHeight = 1.0,
    this.rotation = 0.0,
    this.flipHorizontal = false,
    this.flipVertical = false,
    this.upperLeftPosition,
    this.borderWidth = 1.0,
  });

  BasePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    Color? color,
    double? scaleWidth,
    double? scaleHeight,
    double? rotation,
    bool? flipHorizontal,
    bool? flipVertical,
    Vector2? upperLeftPosition,
    double? pixelToUnitRatio,
    double? borderWidth,
  });

  void addHitboxes() {
    // ✅ Remove existing hitboxes to prevent duplication
    children
        .whereType<PolygonHitbox>()
        .forEach((hitbox) => hitbox.removeFromParent());

    if (adjustedInnerVertices.isNotEmpty) {
      final triangles = triangulatePolygonWithHoles(
        outerPolygon: adjustedVertices,
        holes: [adjustedInnerVertices],
      );

      for (var triangle in triangles) {
        final relativeTriangle = triangle
            .map((v) => (v) * pixelToUnitRatio) // ✅ Convert to world pixels
            .toList();

        add(PolygonHitbox(relativeTriangle, isSolid: false)
          ..debugColor = Colors.green // ✅ Make hitboxes visible
          ..anchor = Anchor.topLeft);
      }
    } else {
      final pixelVertices = adjustedVertices
          .map((v) => (v) * pixelToUnitRatio) // ✅ Convert to world pixels
          .toList();

      add(PolygonHitbox(pixelVertices, isSolid: true)
        ..debugColor = Colors.blue // ✅ Make hitboxes visible
        ..anchor = Anchor.topLeft);
    }

    // print("✅ Added Hitboxes to Polygon at Pos: $position, Size: $size");
  }

  void initializeAdjustedVertices() {
    List<Vector2> rotatedVertices = rotateVertices(vertices, rotation);
    List<Vector2> rotatedInnerVertices =
        rotateVertices(innerVertices, rotation);

    // 🔹 Flip Horizontally if needed
    if (flipHorizontal) {
      rotatedVertices = flipVerticesHorizontally(rotatedVertices);
      if (rotatedInnerVertices.isNotEmpty) {
        rotatedInnerVertices = flipVerticesHorizontally(rotatedInnerVertices);
      }
    }

    // 🔹 Flip Vertically if needed
    if (flipVertical) {
      rotatedVertices = flipVerticesVertically(rotatedVertices);
      if (rotatedInnerVertices.isNotEmpty) {
        rotatedInnerVertices = flipVerticesVertically(rotatedInnerVertices);
      }
    }

    topLeft = getTopLeft(rotatedVertices);

    adjustedVertices = shiftAndScaleVertices(
      vertices: rotatedVertices,
      topLeft: topLeft,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );

    adjustedInnerVertices = shiftAndScaleVertices(
      vertices: rotatedInnerVertices,
      topLeft: topLeft,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );

    // ✅ SET SIZE CORRECTLY (IN GRID UNITS)
    double minX = adjustedVertices.map((v) => v.x).reduce(min);
    double maxX = adjustedVertices.map((v) => v.x).reduce(max);
    double minY = adjustedVertices.map((v) => v.y).reduce(min);
    double maxY = adjustedVertices.map((v) => v.y).reduce(max);

    size = Vector2(maxX - minX, maxY - minY) *
        pixelToUnitRatio; // ✅ Grid units remain unchanged
  }

  List<Vector2> shiftAndScaleVertices({
    required List<Vector2> vertices,
    required Vector2 topLeft,
    required double scaleWidth,
    required double scaleHeight,
  }) {
    return vertices.map((v) {
      Vector2 shifted = (v - topLeft);
      return Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight);
    }).toList();
  }

  /// ✅ Flips the vertices horizontally over the **centerline**
  List<Vector2> flipVerticesHorizontally(List<Vector2> vertices) {
    double centerX =
        vertices.map((v) => v.x).reduce((a, b) => a + b) / vertices.length;
    return vertices.map((v) => Vector2(2 * centerX - v.x, v.y)).toList();
  }

  /// ✅ Flips the vertices vertically over the **centerline**
  List<Vector2> flipVerticesVertically(List<Vector2> vertices) {
    double centerY =
        vertices.map((v) => v.y).reduce((a, b) => a + b) / vertices.length;
    return vertices.map((v) => Vector2(v.x, 2 * centerY - v.y)).toList();
  }

  List<Vector2> rotateVertices(List<Vector2> vertices, double angleInDegrees) {
    final double radians = angleInDegrees * (pi / 180.0);
    final double cosA = cos(radians);
    final double sinA = sin(radians);
    return vertices.map((v) {
      return Vector2(v.x * cosA - v.y * sinA, v.x * sinA + v.y * cosA);
    }).toList();
  }

  void updateOuterPath() {
    polygonPath.reset();
    polygonPath.moveTo(adjustedVertices.first.x * pixelToUnitRatio,
        adjustedVertices.first.y * pixelToUnitRatio);

    for (var vertex in adjustedVertices.skip(1)) {
      polygonPath.lineTo(
          vertex.x * pixelToUnitRatio, vertex.y * pixelToUnitRatio);
    }

    polygonPath.close();
  }

  @override
  Future<void> onLoad() async {
    debugMode = false;
    priority = 1;
    initializeAdjustedVertices();
    anchor = Anchor.topLeft;
    highlightPaint
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    fillPaint = Paint()..color = color;
    outerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0, 1],
        colors: [Color.alphaBlend(color.withOpacity(0.8), Colors.white), color],
      ).createShader(polygonPath.getBounds());
    addHitboxes();
    return super.onLoad();
  }

  /// ✅ Properly draws the polygon using correct colors and grid scaling
  void _drawPolygon(Canvas canvas) {
    updateOuterPath();
    canvas.saveLayer(null, Paint());
    canvas.drawPath(polygonPath, fillPaint);

    if (adjustedInnerVertices.isNotEmpty) {
      holePath.reset();
      holePath.moveTo(adjustedInnerVertices.first.x * pixelToUnitRatio,
          adjustedInnerVertices.first.y * pixelToUnitRatio);
      for (var vertex in adjustedInnerVertices.skip(1)) {
        holePath.lineTo(
            vertex.x * pixelToUnitRatio, vertex.y * pixelToUnitRatio);
      }
      holePath.close();

      // 🔥 Cut out the hole
      canvas.drawPath(holePath, holePaint);
    }

    // ✅ Restore the canvas layer to apply transparency
    canvas.restore();

    // 🔥 Draw the outline (Highlight)
    canvas.drawPath(polygonPath, highlightPaint);
  }

  @override
  void render(Canvas canvas) {
    _drawPolygon(canvas);

    super.render(canvas);
  }
}
