import 'package:first_math/number_line_game/game_path.dart';
import 'package:flutter/material.dart';

class GamePathPainter extends CustomPainter {
  final GamePath gamePath;

  GamePathPainter({required this.gamePath});
  List<Offset>? _precomputedSegments;
  Paint pathPaint = Paint()
    ..color = Colors.grey.withOpacity(0.3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 40.0
    ..strokeCap = StrokeCap.round;
  // Cache for segment points
  final gradientPaint = Paint()..strokeWidth = 10.0;

  void _precomputeSegments() {
    const segmentCount = 200;
    final segmentLength = gamePath.length / segmentCount;

    _precomputedSegments = List.generate(segmentCount + 1, (i) {
      final distance = i * segmentLength;
      return gamePath.getPositionAtDistance(distance) ?? Offset.zero;
    });
  }

  LinearGradient linearGradient = LinearGradient(
    colors: [Colors.grey.shade800, Colors.grey.shade500],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (_precomputedSegments == null) {
      _precomputeSegments(); // Cache segments if not already done
    }

    for (int i = 0; i < _precomputedSegments!.length - 1; i++) {
      final start = _precomputedSegments![i];
      final end = _precomputedSegments![i + 1];
      gradientPaint.shader = LinearGradient(
        colors: [Colors.grey.shade800, Colors.grey.shade500],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromPoints(start, end));
      canvas.drawLine(start, end, gradientPaint);
    }
    canvas.drawPath(gamePath.path, pathPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
