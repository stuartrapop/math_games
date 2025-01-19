import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: AngleMeasurementGame()));
}

class AngleMeasurementGame extends StatefulWidget {
  const AngleMeasurementGame({super.key});

  @override
  State<AngleMeasurementGame> createState() => _AngleMeasurementGameState();
}

class _AngleMeasurementGameState extends State<AngleMeasurementGame> {
  final TextEditingController _answerController = TextEditingController();
  int _attemptsCount = 0;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Missing Angles'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the missing angle.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Math notation for the angle
            Row(
              children: [
                const Text(
                  'm∠BOC = ',
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _answerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffix: const Text('°'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      _isCorrect = value == '74'; // 155° - 45° - 36° = 74°
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Custom paint for the angle diagram
            Center(
              child: Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: AngleDiagramPainter(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Check button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _attemptsCount++;
                  });
                },
                child: Text(
                  'CHECK (${_attemptsCount})',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Number correct: ${_isCorrect ? 1 : 0}'),
          ],
        ),
      ),
    );
  }
}

class AngleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.4, size.height * 0.6);
    final radius = size.width * 0.35;

    // Drawing settings
    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arcPaint = Paint()
      ..color = const Color.fromARGB(255, 235, 69, 8)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final innerArcColor = Paint()
      ..color = const Color.fromARGB(255, 8, 53, 235)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final answerArcColor = Paint()
      ..color = const Color.fromARGB(255, 235, 8, 201)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    // Draw rays
    canvas.drawLine(
      center,
      center + Offset(radius, 0), // Ray OA
      linePaint,
    );
    canvas.drawLine(
      center,
      center +
          Offset(radius * cos(45 * pi / 180),
              -radius * sin(45 * pi / 180)), // Ray OC
      linePaint,
    );
    canvas.drawLine(
      center,
      center +
          Offset(radius * cos(155 * pi / 180),
              -radius * sin(155 * pi / 180)), // Ray OB
      linePaint,
    );

    // Draw the large arc (155°)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.04),
      -155 * pi / 180,
      155 * pi / 180,
      false,
      arcPaint,
    );
    // Draw the large arc (155°)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.02),
      -45 * pi / 180,
      45 * pi / 180,
      false,
      innerArcColor,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * .96),
      -155 * pi / 180,
      110 * pi / 180,
      false,
      answerArcColor,
    );

    // Draw angle markings
    final angleMarkPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    // 45° angle (pink)
    angleMarkPaint.color = Colors.pink.withOpacity(0.5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1),
      -45 * pi / 180,
      45 * pi / 180,
      true,
      angleMarkPaint,
    );

    // 36° angle (blue)
    angleMarkPaint.color = Colors.blue.withOpacity(0.3);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -155 * pi / 180,
      155 * pi / 180,
      true,
      angleMarkPaint,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw angle measurements
    void drawText(String text, Offset position) {
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas,
          position - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    drawText('45°', center + Offset(-radius * 0.2, -radius * 0.2));
    drawText('36°', center + Offset(radius * 0.2, -radius * 0.1));
    drawText(
        '155°',
        center +
            Offset(
                radius * cos(155 * pi / 180), -radius * sin(155 * pi / 180)));

    // Draw point labels
    drawText('O', center + const Offset(0, 20));
    drawText('A', center + Offset(radius + 20, 0));
    drawText(
        'B',
        center +
            Offset(radius * 1.2 * cos(45 * pi / 180),
                -radius * 1.2 * sin(45 * pi / 180)));
    drawText(
        'C',
        center +
            Offset(radius * 1.2 * cos(155 * pi / 180),
                -radius * 1.2 * sin(155 * pi / 180)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
