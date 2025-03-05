import 'package:first_math/geometric_suite/common/components/BasePolygon.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/shape_tracer/shape_tracer_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TracablePolygon extends BasePolygon
    with HasGameRef<ShapeTracerGame>
    implements InterfaceClickableShape {
  @override
  int polygonIndex;
  bool isSolid;
  bool isFullyTraced = false;
  Paint linePaint = Paint();

  Vector2? currentStartVertex; // Track the starting point of the trace
  Vector2? tempEndVertex; // Track the current drag position

  @override
  Function? updateActivePolygonIndex;
  TracablePolygon({
    required super.vertices,
    this.updateActivePolygonIndex,
    this.isSolid = true,
    double pixelToUnitRatio = 50,
    super.borderWidth = 0,
    super.innerVertices,
    super.flipHorizontal,
    super.flipVertical,
    super.scaleWidth,
    super.scaleHeight,
    super.rotation,
    Vector2? upperLeftPosition,
    super.color,
    this.polygonIndex = -1,
  }) : super(
          upperLeftPosition: upperLeftPosition,
          pixelToUnitRatio: pixelToUnitRatio,
        ) {
    position = (upperLeftPosition ?? Vector2.zero()) * pixelToUnitRatio;
  }
  @override
  TracablePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    Color? color,
    double? scaleWidth,
    double? scaleHeight,
    double? rotation,
    Vector2? position,
    Vector2? size,
    bool? flipHorizontal,
    bool? flipVertical,
    Vector2? upperLeftPosition,
    double? pixelToUnitRatio,
    double? borderWidth,
    int? polygonIndex,
    Function? updateActivePolygonIndex,
    double? holeRadius,
    bool? isSolid,
  }) {
    // ✅ Ensure upperLeftPosition is correctly updated
    final Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();

    // ✅ Compute new position
    final Vector2 updatedPosition =
        newUpperLeftPosition * (pixelToUnitRatio ?? this.pixelToUnitRatio);

    TracablePolygon copiedPolygon = TracablePolygon(
      updateActivePolygonIndex:
          updateActivePolygonIndex ?? this.updateActivePolygonIndex,
      vertices: vertices ?? this.vertices.map((v) => v.clone()).toList(),
      innerVertices:
          innerVertices ?? this.innerVertices.map((v) => v.clone()).toList(),
      pixelToUnitRatio: pixelToUnitRatio ?? this.pixelToUnitRatio,
      upperLeftPosition: newUpperLeftPosition,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
      scaleWidth: scaleWidth ?? this.scaleWidth,
      scaleHeight: scaleHeight ?? this.scaleHeight,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      borderWidth: borderWidth ?? this.borderWidth,
      polygonIndex: polygonIndex ?? this.polygonIndex,
      isSolid: isSolid ?? this.isSolid,
    )..position = updatedPosition;

    // print("borderWidth: $borderWidth");
    // 🔥 Recalculate adjusted vertices
    copiedPolygon.initializeAdjustedVertices();
    return copiedPolygon;
  }

  @override
  bool isTapped = false;

  @override
  Future<void> onLoad() {
    super.onLoad();
    initializeAdjustedVertices();

    return Future.value();
  }

  @override
  void update(double dt) {
    if (!isSolid) {
      checkIfPolygonIsFullyTraced();
    }
  }

  @override
  void onMount() {
    super.onMount();
    fillPaint.color = isSolid ? color : Colors.transparent;
  }

  @override
  void resetColor() {}

  List<double> convertVector2ToDoubles(List<Vector2> vectors) {
    return vectors.expand((v) => [v.x, v.y]).toList();
  }

  @override
  Future<void> demoClick() async {}

  @override
  void toggleColor() {}

  @override
  String toString() {
    return "TracablePolygon: polygonIndex: $polygonIndex, isTapped: $isTapped";
  }

  /// ✅ Properly draws the polygon using correct colors and grid scaling
  void _drawPolygon(Canvas canvas) {
    polygonPath = createPathFromVertices(adjustedVertices, pixelToUnitRatio);
    canvas.saveLayer(null, Paint());
    canvas.drawPath(polygonPath, fillPaint);

    // ✅ Restore the canvas layer to apply transparency
    canvas.restore();

    // 🔥 Draw the outline (Highlight)
    canvas.drawPath(polygonPath, highlightPaint);
  }

  /// ✅ Draws round dots at each vertex when `isSolid` is `false`
  void _drawDots(Canvas canvas) {
    final Paint dotPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255);
    for (Vector2 vertex in adjustedVertices) {
      canvas.drawCircle(
          Offset(vertex.x * pixelToUnitRatio, vertex.y * pixelToUnitRatio),
          6,
          dotPaint);
    }
  }

  /// ✅ Draws all traced lines
  void _drawTracedLines(Canvas canvas) {
    if (isSolid) return;
    linePaint
      ..color = isFullyTraced ? Colors.white : Colors.red
      ..strokeWidth = 6.0;

    List<(Vector2, Vector2)> edges = getPolygonEdges(polygon: this);
    for (var line in gameRef.tracedLines) {
      Vector2 startVertex = line.$1 - upperLeftPosition!;
      Vector2 endVertex = line.$2 - upperLeftPosition!;
      bool isPolygonEdge = edges.any((edge) =>
          (edge.$1 == line.$1 && edge.$2 == line.$2) ||
          (edge.$1 == line.$2 && edge.$2 == line.$1));
      if (!isPolygonEdge) continue;
      canvas.drawLine(
        Offset(
            startVertex.x * pixelToUnitRatio, startVertex.y * pixelToUnitRatio),
        Offset(endVertex.x * pixelToUnitRatio, endVertex.y * pixelToUnitRatio),
        linePaint,
      );
    }
  }

  @override
  void render(Canvas canvas) {
    if (isSolid) {
      _drawPolygon(canvas); // Normal polygon rendering
    } else {
      _drawDots(canvas); // Draw dots at each vertex
    }
    _drawTracedLines(canvas); // Draw the traced lines
    super.render(canvas);
  }

  /// ✅ Detects when a user taps a vertex
  @override
  void onTapDown(TapDownEvent event) {}

  void checkIfPolygonIsFullyTraced() {
    List<(Vector2, Vector2)> edges = getPolygonEdges(polygon: this);
    bool allEdgesTraced = edges.every((edge) => _lineExists(edge.$1, edge.$2));

    if (allEdgesTraced) {
      isFullyTraced = true;
      linePaint.color = Colors.white;
      fillPaint.color = color;
    }
  }

  /// ✅ Helper function to get all edges of the polygon
  List<(Vector2, Vector2)> getPolygonEdges({required TracablePolygon polygon}) {
    List<(Vector2, Vector2)> edges = [];
    for (int i = 0; i < adjustedVertices.length; i++) {
      Vector2 start = adjustedVertices[i] + upperLeftPosition!;
      Vector2 end = adjustedVertices[(i + 1) % adjustedVertices.length] +
          upperLeftPosition!;
      edges.add((start, end));
    }
    return edges;
  }

  bool _lineExists(Vector2 start, Vector2 end) {
    return gameRef.tracedLines.any((line) =>
        (line.$1 == start && line.$2 == end) ||
        (line.$1 == end && line.$2 == start));
  }
}
