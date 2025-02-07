import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Grid component for visualization
class GridComponent extends PositionComponent {
  final int gridSize;
  final int rows;
  final int cols;
  final double lineWidth;
  final List<Vector2> snapPoints = [];

  GridComponent(
      {required this.gridSize,
      required this.rows,
      required this.cols,
      required this.lineWidth});

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = lineWidth;
    for (int i = 0; i <= cols; i++) {
      double x = i * gridSize.toDouble();
      canvas.drawLine(
          Offset(x, 0), Offset(x, rows * gridSize.toDouble()), paint);
    }
    for (int j = 0; j <= rows; j++) {
      double y = j * gridSize.toDouble();
      canvas.drawLine(
          Offset(0, y), Offset(cols * gridSize.toDouble(), y), paint);
    }
  }

  @override
  void onMount() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        snapPoints
            .add(Vector2(i * gridSize.toDouble(), j * gridSize.toDouble()));
      }
    }
    super.onMount();
  }
}
