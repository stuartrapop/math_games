import 'dart:io';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

class Utils {
  static Future<void> configureTts({
    required bool isRandom,
    required String language,
  }) async {
    double pitchAdjustment = Random().nextDouble() * 0.8;
    double rateAdjustment = Random().nextDouble() * 0.3;
    // await flutterTts.setLanguage('fr-FR');
    await flutterTts.setLanguage(language);
    await flutterTts.setSpeechRate(isRandom ? rateAdjustment + 0.2 : 0.3);
    if (kIsWeb) {
      // running on the web!
      await flutterTts.setSpeechRate(0.8);
    } else {
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.8 : 0.395);
    }

    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(isRandom ? 0.5 + pitchAdjustment : 0.2);
  }

  static Future<void> speakText(String text) async {
    print("Attempting to speak text: $text"); // Debug statement
    var result = await flutterTts.speak(text);
    if (result == 1) {
      print("Speech started successfully");
    } else {
      print("Failed to start speech");
    }
  }

  static Future<void> stopSpeaking() async {
    await flutterTts.stop();
    await Future.delayed(Duration(milliseconds: 500));
  }

  static void speak(
    textValue, {
    required bool isRandom,
    String language = 'fr-FR',
  }) async {
    await stopSpeaking(); // Stop an
    await configureTts(
      isRandom: isRandom,
      language: language,
    );
    await speakText(textValue);
    // await stopSpeaking();
  }

  static List<int> generateLeftValues() {
    final random = Random();
    final uniqueValues = <int>{};

    while (uniqueValues.length < 5) {
      uniqueValues
          .add(random.nextInt(24) + 1); // Generates a number between 1 and 24
    }

    return uniqueValues.toList();
  }
}

void printComponentTree(Component component, {int depth = 0}) {
  // Print the current component with indentation
  final indent = '  ' * depth;
  print('$indent- ${component.runtimeType} (${component})');

  // Recursively print children
  for (final child in component.children) {
    printComponentTree(child, depth: depth + 1);
  }
}
