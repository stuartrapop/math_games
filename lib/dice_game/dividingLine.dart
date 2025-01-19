import 'dart:ui';

import 'package:flame/components.dart';

class Dividingline extends PositionComponent {
  Dividingline({int priority = 0}) {
    this.priority = priority;
  }
  @override
  void render(Canvas canvas) {
    anchor = Anchor.topCenter;
    super.render(canvas);
    canvas.drawLine(
        Offset(0, 0), Offset(0, 300), Paint()..color = const Color(0xFFFFFFFF));
  }
}
