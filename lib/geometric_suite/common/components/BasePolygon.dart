import 'dart:async';
import 'dart:math';

import 'package:first_math/geometric_suite/common/utils/helpers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

abstract class BasePolygon extends PositionComponent
    with TapCallbacks, GestureHitboxes, HasPaint {
  late Color color;
  double borderWidth;
  double scaleWidth;
  double scaleHeight;
  double rotation;
  bool flipHorizontal;
  bool flipVertical;
  double holeRadius;
  List<Vector2> vertices;
  List<Vector2> innerVertices;
  late List<Vector2> adjustedVertices;
  late List<Vector2> adjustedInnerVertices;
  late Vector2 topLeft;
  late Paint fillPaint;
  late Paint holePaint;
  late Paint highlightPaint;

  // late Paint outerPaint;
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
    this.holeRadius = 0.0,
    this.rotation = 0.0,
    this.flipHorizontal = false,
    this.flipVertical = false,
    this.upperLeftPosition,
    this.borderWidth = 0,
  });

  BasePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    double? holeRadius,
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
          ..debugMode = false
          ..priority = 100
          ..anchor = Anchor.topLeft);
      }
    } else {
      final pixelVertices = adjustedVertices
          .map((v) => (v) * pixelToUnitRatio) // ✅ Convert to world pixels
          .toList();

      add(PolygonHitbox(pixelVertices, isSolid: true)
        ..debugColor = Colors.blue
        ..priority = 100
        ..debugMode = false // ✅ Make hitboxes visible
        ..anchor = Anchor.topLeft);
    }

    // print("✅ Added Hitboxes to Polygon at Pos: $position, Size: $size");
  }

  void initializeAdjustedVertices() {
    List<Vector2> shiftAndScaledVertices = shiftAndScaleVertices(
      vertices: vertices,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );
    List<Vector2> rotatedShiftedScaledVertices =
        rotateVertices(shiftAndScaledVertices, rotation);

    topLeft = getTopLeft(vertices);

    List<Vector2> rotatedInnerVertices =
        rotateVertices(innerVertices, rotation);

    List<Vector2> shiftAndScaledInnerVertices = shiftAndScaleVertices(
      vertices: innerVertices,
      overRideTopLeft: topLeft,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
    );
    List<Vector2> rotatedShiftedScaledInnerVertices =
        rotateVertices(shiftAndScaledInnerVertices, rotation);

    // 🔹 Flip Horizontally if needed
    if (flipHorizontal) {
      rotatedShiftedScaledVertices =
          flipVerticesHorizontally(rotatedShiftedScaledVertices);
      if (rotatedInnerVertices.isNotEmpty) {
        rotatedInnerVertices =
            flipVerticesHorizontally(rotatedShiftedScaledInnerVertices);
      }
    }

    // 🔹 Flip Vertically if needed
    if (flipVertical) {
      rotatedShiftedScaledVertices =
          flipVerticesVertically(rotatedShiftedScaledVertices);
      if (rotatedInnerVertices.isNotEmpty) {
        rotatedInnerVertices =
            flipVerticesVertically(rotatedShiftedScaledInnerVertices);
      }
    }

    topLeft = getTopLeft(rotatedShiftedScaledVertices);

    adjustedVertices = shiftAndScaleVertices(
      vertices: rotatedShiftedScaledVertices,
      overRideTopLeft: topLeft,
      scaleWidth: 1.0,
      scaleHeight: 1.0,
    );
    adjustedInnerVertices = shiftAndScaleVertices(
      vertices: rotatedShiftedScaledInnerVertices,
      overRideTopLeft: topLeft,
      scaleWidth: 1,
      scaleHeight: 1,
    );

    // ✅ SET SIZE CORRECTLY (IN GRID UNITS)
    double minX = adjustedVertices.map((v) => v.x).reduce(min);
    double maxX = adjustedVertices.map((v) => v.x).reduce(max);
    double minY = adjustedVertices.map((v) => v.y).reduce(min);
    double maxY = adjustedVertices.map((v) => v.y).reduce(max);

    size = Vector2(maxX - minX, maxY - minY) *
        pixelToUnitRatio; // ✅ Grid units remain unchanged
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("tapDown of BasePolygon");
    super.onTapDown(event);
  }

  List<Vector2> shiftAndScaleVertices({
    required List<Vector2> vertices,
    Vector2? overRideTopLeft,
    required double scaleWidth,
    required double scaleHeight,
  }) {
    if (vertices.isEmpty) return [];
    Vector2 topLeft = overRideTopLeft ?? getTopLeft(vertices);
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

  Path createPathFromVertices(List<Vector2> vertices, double pixelRatio) {
    final path = Path();
    path.moveTo(vertices.first.x * pixelRatio, vertices.first.y * pixelRatio);
    for (var vertex in vertices.skip(1)) {
      path.lineTo(vertex.x * pixelRatio, vertex.y * pixelRatio);
    }
    path.close();
    return path;
  }

  @override
  Future<void> onLoad() async {
    debugMode = false;
    priority = 1;
    initializeAdjustedVertices();
    anchor = Anchor.topLeft;
    highlightPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    fillPaint = Paint()..color = color;
    holePaint = Paint()..blendMode = BlendMode.clear;
    addHitboxes();
    return super.onLoad();
  }

  /// ✅ Properly draws the polygon using correct colors and grid scaling
  void _drawPolygon(Canvas canvas) {
    polygonPath = createPathFromVertices(adjustedVertices, pixelToUnitRatio);
    canvas.saveLayer(null, Paint());
    canvas.drawPath(polygonPath, fillPaint);

    if (adjustedInnerVertices.isNotEmpty) {
      holePath =
          createPathFromVertices(adjustedInnerVertices, pixelToUnitRatio);
      // 🔥 Cut out the hole
      canvas.drawPath(holePath, holePaint);
    }

    if (holeRadius > 0) {
      // 🔥 Cut out the hole
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        holeRadius * pixelToUnitRatio,
        holePaint,
      );
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
