import 'package:first_math/geometric_suite/match_polygon/components/clickable_polygon.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:first_math/geometric_suite/shape_tracer/components/tracable_polygon.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

typedef V = Vector2;

T createPolygon<T extends InterfaceClickableShape>({
  required List<Vector2> vertices,
  Color color = Colors.blue,
  double scaleWidth = 1.0,
  double scaleHeight = 1.0,
  double rotation = 0.0,
  Vector2? upperLeftPosition,
  double borderWidth = 0,
}) {
  if (T == ClickablePolygon) {
    return ClickablePolygon(
      vertices: vertices,
      color: color,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
      rotation: rotation,
      upperLeftPosition: upperLeftPosition,
      borderWidth: borderWidth,
    ) as T;
  } else if (T == TracablePolygon) {
    return TracablePolygon(
      vertices: vertices,
      color: color,
      scaleWidth: scaleWidth,
      scaleHeight: scaleHeight,
      rotation: rotation,
      upperLeftPosition: upperLeftPosition,
      borderWidth: borderWidth,
    ) as T;
  } else {
    throw ArgumentError("Unsupported polygon type: $T");
  }
}
