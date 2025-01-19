import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class SizedTextBox extends TextBoxComponent {
  SizedTextBox(
    String text, {
    super.align,
    super.size,
    double? timePerChar,
    double? margins,
    double fontSize = 22.0,
  }) : super(
          text: text,
          textRenderer: TextPaint(
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          boxConfig: TextBoxConfig(
            maxWidth: 350,
            timePerChar: timePerChar ?? 0.2,
            growingBox: true,
            margins: EdgeInsets.all(margins ?? 0),
          ),
        );
}
