import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class HomePositionComponent extends SpriteComponent with TapCallbacks {
  final FlameGame game;
  final Function returnHome;
  HomePositionComponent({
    required this.game,
    required this.returnHome,
  });
  @override
  Sprite? sprite;

  @override
  void onTapDown(TapDownEvent event) {
    print("tappe on home card");
    returnHome();
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await game.loadSprite('home.png');

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
