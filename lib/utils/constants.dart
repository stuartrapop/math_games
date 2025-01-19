import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// textstyle
final TextPaint text25White = TextPaint(
  style: const TextStyle(
    fontSize: 27.0,
    fontFamily: 'Awesome Font',
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
);

//colors
final Paint fillBlue = Paint()
  ..color = const Color.fromARGB(255, 98, 82, 189)
  ..style = PaintingStyle.fill
  ..strokeWidth = 20;
final Paint fillHoverRed = Paint()
  ..color = const Color.fromARGB(255, 203, 73, 73)
  ..style = PaintingStyle.fill
  ..strokeWidth = 20;
final Paint fillRed = Paint()
  ..color = const Color.fromARGB(255, 209, 38, 38)
  ..style = PaintingStyle.fill
  ..strokeWidth = 20;
final Paint fillBlack = Paint()..color = const Color.fromARGB(255, 6, 6, 6);
final Paint fill75TransparentBlack = Paint()
  ..color =
      const Color.fromARGB(128, 0, 0, 0) // 64 is 25% opaque (75% transparent)
  ..style = PaintingStyle.fill
  ..strokeWidth = 20;

final List<Color> regletteColors = [
  const Color(0xFFFFFFFF), // White
  const Color.fromARGB(255, 242, 62, 62), // Red
  const Color(0xFF90EE90), // Light Green
  const Color.fromARGB(255, 199, 79, 199), // Purple
  const Color(0xFFFFFF00), // Yellow
  const Color.fromARGB(255, 33, 140, 33), // Dark Green
  const Color.fromARGB(255, 45, 42, 42), // Black
  const Color.fromARGB(255, 161, 80, 80), // Brown
  const Color.fromARGB(255, 93, 93, 222), // Blue
  const Color(0xFFFFA500), // Orange
];
