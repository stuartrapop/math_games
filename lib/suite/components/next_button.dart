import 'package:first_math/suite/suite_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class NextButtonComponent extends PositionComponent
    with TapCallbacks, HasVisibility, HasGameRef<SuiteGame> {
  final VoidCallback onNextPressed;
  late Paint _buttonPaint;
  late Paint _iconPaint;
  bool isActive = true;

  NextButtonComponent({required this.onNextPressed}) : super() {
    _buttonPaint = Paint()..color = Colors.blueAccent;
    _iconPaint = Paint()..color = Colors.white;
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(525, 360);
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;

    // Draw circular button
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _buttonPaint);

    // Draw arrow icon →
    final arrowPath = Path()
      ..moveTo(size.x * 0.4, size.y * 0.3)
      ..lineTo(size.x * 0.7, size.y * 0.5)
      ..lineTo(size.x * 0.4, size.y * 0.7)
      ..close();

    canvas.drawPath(arrowPath, _iconPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isVisible && isActive) {
      onNextPressed();
      isActive = false;
    }
  }
}
