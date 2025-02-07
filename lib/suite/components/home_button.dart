import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class HomeButton extends SpriteComponent with HasGameRef, TapCallbacks {
  static void _defaultCallback() {}
  final Function callback;
  HomeButton({this.callback = _defaultCallback});
  @override
  Sprite? sprite;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('home.png');

    anchor = Anchor.center;

    // Apply the color tint using the paint property
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 247, 249, 247); // Change this color to your desired tint
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    callback();
    print("tapped on left card");

    super.onTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
