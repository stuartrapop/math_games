import 'dart:ui';

import 'package:flame/components.dart';

abstract class InterfaceClickableShape extends PositionComponent {
  int get polygonIndex;
  set polygonIndex(int value);

  // Getter and Setter for isTapped
  bool get isTapped;
  set isTapped(bool value);

  // Getter and Setter for color
  Color get color;
  set color(Color value);

  Function? updateActivePolygonIndex;
  void toggleColor();
  void resetColor();
  Future<void> demoClick();

  InterfaceClickableShape copyWith({
    double? pixelToUnitRatio,
    Vector2? upperLeftPosition,
    int? polygonIndex,
    Function? updateActivePolygonIndex,
    Color? color,
    double? borderWidth,
  });
}
