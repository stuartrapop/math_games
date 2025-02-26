import 'package:first_math/geometric_suite/common/types/AbstractFlameGameClass.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/match_polygon/utils/simulate_click.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ClickableCircle extends CircleComponent
    with TapCallbacks, HasGameRef<GameWithFrameFeatures>
    implements InterfaceClickableShape {
  @override
  int polygonIndex;
  @override
  Function? updateActivePolygonIndex;
  double pixelToUnitRatio = 50;
  Vector2? upperLeftPosition;

  late final Paint borderPaint;
  Color color;

  ClickableCircle({
    this.updateActivePolygonIndex,
    this.polygonIndex = -1,
    this.color = Colors.white,
    Color borderColor = Colors.white54,
    double borderWidth = 4,
    double radius = 50,
    this.pixelToUnitRatio = 50,
    this.upperLeftPosition,
  }) : super(
          radius: radius,
        ) {
    borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
  }

  @override
  ClickableCircle copyWith({
    Vector2? upperLeftPosition,
    int? polygonIndex,
    Function? updateActivePolygonIndex,
    double? pixelToUnitRatio, // Unused but needed for compatibility
    Color? color,
    double? radius,
    Color? borderColor,
    double? borderWidth,
  }) {
    final double newPixelToUnitRatio =
        pixelToUnitRatio ?? this.pixelToUnitRatio;

    final Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();

    final Vector2 updatedPosition = newUpperLeftPosition * newPixelToUnitRatio;

    return ClickableCircle(
      polygonIndex: polygonIndex ?? this.polygonIndex,
      updateActivePolygonIndex:
          updateActivePolygonIndex ?? this.updateActivePolygonIndex,
      color: color ?? this.color, // ✅ Corrected from paint.color
      borderColor: borderColor ?? borderPaint.color,
      borderWidth: borderWidth ?? borderPaint.strokeWidth,
      radius: radius ?? this.radius,
      pixelToUnitRatio: newPixelToUnitRatio,
      upperLeftPosition: newUpperLeftPosition,
    )..position = updatedPosition;
  }

  @override
  bool isTapped = false;

  @override
  void resetColor() {
    isTapped = false;
    paint.color = Colors.transparent;
  }

  @override
  Future<void> demoClick() async {
    print("demoClick radius $radius");
    await simulateClick(
        labelPosition:
            Vector2(radius / pixelToUnitRatio, radius / pixelToUnitRatio),
        pixelToUnitRatio: pixelToUnitRatio,
        gameRef: gameRef,
        currentComponent: this);
  }

  @override
  Future<void> onLoad() {
    // resetColor();
    return super.onLoad();
  }

  @override
  void onMount() {
    if (polygonIndex != -1) {
      resetColor();
    } else {
      paint.color = color;
    }
    super.onMount();
  }

  @override
  void toggleColor() {
    isTapped = !isTapped;
    paint.color = isTapped ? color : Colors.transparent;
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("Circle tapped");
    if (updateActivePolygonIndex != null) {
      updateActivePolygonIndex!(polygonIndex);
    }
    super.onTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the circle border
    canvas.drawCircle(Offset(radius, radius), radius, borderPaint);
  }
}
