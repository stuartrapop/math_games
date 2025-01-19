import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';

class Info extends PositionComponent with TapCallbacks, HasPaint {
  late InfoSprite infoSprite;

  Info({int priority = 10}) {
    this.priority = priority;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Set size and anchor for Dice
    anchor = Anchor.center;

    infoSprite = InfoSprite()
      ..size = size * 0.9 // Inherit size from Dice
      ..position = size / 2 // Center DiceSprite within Dice
      ..anchor = Anchor.center;

    // Add DiceSprite as a child
    add(infoSprite);
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    Utils.speak(
        '''Placez le cube dans une colonne pour atteindre le nombre cible.
  Chaque colonne représente un chiffre de la base 10.
  La colonne de droite représente les unités, la deuxième de droite represente les dizaines.
  À gauche des dizaines, sont les centaines. Et ainsi de suite.

  Presses longtemps sur n'importe quel colonne pour entendre le chiffre qu'elle représente.''',
        isRandom: false);
    super.onLongTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    // Draw a solid black background

    super.render(canvas);
  }
}

class InfoSprite extends SpriteComponent with HasGameRef {
  InfoSprite();
  @override
  Sprite? sprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('info.png');

    anchor = Anchor.center;

    // Apply the color tint using the paint property
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 247, 249, 247); // Change this color to your desired tint
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
//     // }