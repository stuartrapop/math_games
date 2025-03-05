import 'dart:ui';

import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:flame/components.dart';

abstract class InterfaceSnappableShape extends PositionComponent {
  GridComponent get grid;
  set grid(GridComponent value);

  int get polygonIndex;
  set polygonIndex(int value);

  double get scaleWidth;
  set scaleWidth(double value) {}

  double get scaleHeight;
  set scaleHeight(double value) {}
  double get radius;
  set radius(double value) {}
  double get rotation;
  set rotation(double value) {}
  bool get flipVertical;
  bool get flipHorizontal;
  // GridComponent get grid => null;
  // set grid(GridComponent? value) {}

  // Getter and Setter for isTapped

  // Getter and Setter for color
  Color get color;
  set color(Color value);

  Function? updateActivePolygonIndex;

  Future<void> demoMoveTo({required Vector2 gridPoint});
  Vector2? upperLeftPosition;

  InterfaceSnappableShape copyWith({
    double? pixelToUnitRatio,
    Vector2? upperLeftPosition,
    int? polygonIndex,
    Function? updateActivePolygonIndex,
    Color? color,
    double? borderWidth,
    bool? flipVertical,
    bool? flipHorizontal,
    int? questionIndex,
    bool? isDraggable,
    GridComponent? grid,
    double? holeRadius,
  });
}
