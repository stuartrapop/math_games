import 'package:first_math/geometric_suite/common/components/BasePolygon.dart';
import 'package:first_math/geometric_suite/common/types/AbstractFlameGameClass.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/match_polygon/utils/simulate_click.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:geobase/geobase.dart';

class ClickablePolygon extends BasePolygon
    with HasGameRef<GameWithFrameFeatures>
    implements InterfaceClickableShape {
  @override
  int polygonIndex;
  @override
  Function? updateActivePolygonIndex;
  ClickablePolygon({
    required super.vertices,
    this.updateActivePolygonIndex,
    double pixelToUnitRatio = 50,
    super.borderWidth = 1.0,
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
  ClickablePolygon copyWith({
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
    // ✅ Ensure updated ratio is applied before computations

    // ✅ Ensure upperLeftPosition is correctly updated
    final Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();

    // ✅ Compute new position
    final Vector2 updatedPosition =
        newUpperLeftPosition * (pixelToUnitRatio ?? this.pixelToUnitRatio);

    ClickablePolygon copiedPolygon = ClickablePolygon(
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
    )..position = updatedPosition;

    // print("borderWidth: $borderWidth");
    // 🔥 Recalculate adjusted vertices
    copiedPolygon.initializeAdjustedVertices();
    return copiedPolygon;
  }

  bool isTapped = false;

  @override
  Future<void> onLoad() {
    initializeAdjustedVertices();
    return super.onLoad();
  }

  @override
  void onMount() {
    if (polygonIndex != -1) resetColor();

    super.onMount();
  }

  void updatePaints() {
    fillPaint.color = isTapped ? color : Colors.transparent;
  }

  @override
  void resetColor() {
    isTapped = false;
    updatePaints();
  }

  List<double> convertVector2ToDoubles(List<Vector2> vectors) {
    return vectors.expand((v) => [v.x, v.y]).toList();
  }

  @override
  Future<void> demoClick() async {
    List<Vector2> points = adjustedVertices;
    Polygon componentPolygon = Polygon.build([convertVector2ToDoubles(points)]);
    Vector2 labelPosition = Vector2(componentPolygon.polylabel2D().position.x,
        componentPolygon.polylabel2D().position.y);
    resetColor();
    await simulateClick(
      labelPosition: labelPosition,
      pixelToUnitRatio: pixelToUnitRatio,
      gameRef: gameRef,
      currentComponent: this,
    );
  }

  @override
  void toggleColor() {
    isTapped = !isTapped;
    updatePaints();
  }

  @override
  String toString() {
    return "ClickablePolygon: polygonIndex: $polygonIndex, isTapped: $isTapped";
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("tap on polygon");

    if (updateActivePolygonIndex != null) {
      updateActivePolygonIndex!(polygonIndex);
    }

    super.onTapDown(event);
  }
}
