import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: AngleSlideGame()));
}

class AngleSlideGame extends StatefulWidget {
  const AngleSlideGame({super.key});

  @override
  State<AngleSlideGame> createState() => _AngleSlideGameState();
}

class _AngleSlideGameState extends State<AngleSlideGame> {
  double _angleAOB = 30; // Initial angle for ∠BOC

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust the Angle'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adjust the angle ∠AOB using the slider.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display current angle
            Row(
              children: [
                const Text(
                  'Percentage of a full circle: ',
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                ),
                Text(
                  '${(_angleAOB.toInt() / 360 * 100).round()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Angle diagram
            Center(
              child: Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: AngleDiagramPainter(angleAOB: _angleAOB),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Slider for angle adjustment
            Center(
              child: Container(
                width: 400,
                child: Slider(
                  value: _angleAOB,
                  min: 0,
                  max: 360,
                  divisions: 72,
                  label: '${(_angleAOB.toInt() / 360 * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _angleAOB = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AngleDiagramPainter extends CustomPainter {
  final double angleAOB;

  AngleDiagramPainter({required this.angleAOB});

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

    // Draw rays
    canvas.drawLine(
      center,
      center + Offset(radius, 0), // Ray OA
      linePaint,
    );

    canvas.drawLine(
      center,
      center +
          Offset(radius * cos((angleAOB) * pi / 180),
              -radius * sin((angleAOB) * pi / 180)), // Ray OB
      linePaint,
    );

    // Draw the large arc for ∠BOC
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.04),
      -angleAOB * pi / 180,
      angleAOB * pi / 180,
      false,
      arcPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.04),
      0 * pi / 180,
      360 * pi / 180,
      true,
      linePaint,
    );

    final angleMarkPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlue;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.00),
      -angleAOB * pi / 180,
      angleAOB * pi / 180,
      true,
      angleMarkPaint,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw labels
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

    drawText('O', center + const Offset(0, 20));
    drawText('A', center + Offset(radius + 20, 0));
    drawText(
        'B',
        center +
            Offset(radius * 1.2 * cos((angleAOB) * pi / 180),
                -radius * 1.2 * sin((angleAOB) * pi / 180)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
