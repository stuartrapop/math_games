import 'package:first_math/components/sized_text_box.dart';
import 'package:first_math/utils/spelling_numbers.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DisplayDice extends PositionComponent {
  int number;

  DisplayDice({this.number = 1, int priority = 20})
      : super(
          priority: priority,
        );

  List<DiceSprite> diceSprite = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    diceSprite.clear();

    generateDiceSprites(number);

    diceSprite.shuffle();
    addAll(diceSprite);

    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, 600, 900),
    //   Paint()..color = const Color.fromARGB(255, 50, 50, 52),
    // );
  }

  void generateDiceSprites(int remaining) {
    List<int> diceValues = _findRandomDiceCombination(remaining, 6);

    // If no valid combination is found, clear the dice sprites
    if (diceValues.isEmpty) {
      diceSprite.clear();
      return;
    }

    diceSprite.clear();
    for (int i = 0; i < diceValues.length; i++) {
      int dieValue = diceValues[i];

      // Position dice horizontally, each shifted slightly to the right
      final position = Vector2(size.y / 2 + (size.y * 1.05) * i, size.y / 2);

      var sprite = DiceSprite(number: dieValue)
        ..size = Vector2(size.y, size.y) // Set to the size of DisplayDice
        ..position = position // Center within DisplayDice
        ..anchor = Anchor.center;

      diceSprite.add(sprite);
    }
  }

  /// Helper function to find a random valid dice combination.
  List<int> _findRandomDiceCombination(int target, int maxDice) {
    List<int> result = [];
    if (_randomBacktrack(target, maxDice, result)) {
      return result;
    }
    return [];
  }

  bool _randomBacktrack(int target, int maxDice, List<int> result) {
    if (target == 0) {
      return true; // Found a valid combination
    }
    if (maxDice == 0 || target < 0) {
      return false; // No more dice or target is negative
    }

    // Shuffle possible die values (1 through min(6, target))
    List<int> dieValues = List.generate(6, (index) => index + 1)
      ..shuffle(); // Randomize die values

    for (int dieValue in dieValues) {
      if (dieValue > target) continue; // Skip values larger than the target

      result.add(dieValue);
      if (_randomBacktrack(target - dieValue, maxDice - 1, result)) {
        return true; // Found a valid combination
      }
      result.removeLast(); // Backtrack
    }

    return false; // No valid combination found
  }
}

class DiceSprite extends SpriteComponent with HasGameRef, TapCallbacks {
  int number = 1;
  DiceSprite({this.number = 1});
  @override
  Sprite? sprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('inverted-dice-${number.toString()}.png');

    anchor = Anchor.center;

    // Apply the color tint using the paint property
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 247, 249, 247); // Change this color to your desired tint
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    print("tapped on left card");
    String numberText = SpellingNumber(
      lang: 'fr',
      decimalSeperator: "-",
    ).convert(number);
    Utils.speak(numberText, isRandom: true);
    final textBox = SizedTextBox(
      numberText,
      size: Vector2(500, 499),
      timePerChar: 0.1,
      fontSize: 50,
    )..position = Vector2(300, 680);
    gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
      child.removeFromParent();
    });
    gameRef.world.add(textBox);
    Future.delayed(Duration(seconds: 3), () {
      textBox.removeFromParent();
    });

    super.onTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
