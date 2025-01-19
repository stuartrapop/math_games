import 'package:flutter/material.dart';

List<Color> ballColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  const Color.fromARGB(255, 234, 95, 141),
  const Color.fromARGB(255, 174, 178, 196),
  const Color.fromARGB(255, 62, 77, 248),
  const Color.fromARGB(255, 255, 7, 164),
  const Color.fromARGB(255, 7, 255, 36),
];

class CollisionGroups {
  static const int numberBall = 1;
  static const int spiralCircle = 2;
}
