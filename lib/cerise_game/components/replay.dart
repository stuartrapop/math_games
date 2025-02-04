import 'package:first_math/cerise_game/cerise_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Replay extends PositionComponent
    with TapCallbacks, HasPaint, HasGameRef<CeriseGame>, HasVisibility {
  final Function gameReset;

  Replay({required this.gameReset}) : super();

  @override
  // runnig in debug mode
  bool debugMode = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // ✅ Draw the circular button background
    Paint circlePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, circlePaint);

    // ✅ Draw the replay icon using TextPainter
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.replay.codePoint),
        style: TextStyle(
          fontSize: size.x * 0.8,
          fontFamily: Icons.replay.fontFamily,
          package: Icons.replay.fontPackage,
          color: const Color.fromARGB(255, 168, 163, 163),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((size.x - textPainter.width) / 2,
            (size.y - textPainter.height) / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameReset(); // ✅ Reset game on tap
    super.onTapDown(event);
  }
}
