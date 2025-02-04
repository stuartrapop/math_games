import 'dart:ui';

import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:just_audio/just_audio.dart';

class VolumeDisplay extends SpriteComponent
    with HasGameRef<NumberLineGame>, TapCallbacks {
  VolumeDisplay() : super();

  @override
  Future<void> onLoad() async {
    // Load the sprite image
    sprite = await gameRef.loadSprite('volume_up.png');
    size = Vector2(50, 50); // Set the size of the component
    anchor = Anchor.center; // Center the component anchor
    paint.colorFilter = const ColorFilter.mode(
      Color(0xFFFFFFFF), // White
      BlendMode.srcATop,
    );
  }

  @override
  void onTapUp(TapUpEvent event) async {
    if (gameRef.hasVolume) {
      await gameRef.bgmAudioPlayer.stop();
      gameRef.hasVolume = false;
      sprite = await gameRef.loadSprite('volume_off.png');
      paint.colorFilter = const ColorFilter.mode(
        Color.fromARGB(255, 237, 16, 16), // Red
        BlendMode.srcATop,
      ); //
    } else {
      await gameRef.bgmAudioPlayer.stop();
      await gameRef.bgmAudioPlayer.seek(Duration.zero);
      await gameRef.bgmAudioPlayer.setLoopMode(LoopMode.one);
      await gameRef.bgmAudioPlayer.play();
      gameRef.hasVolume = true;
      sprite = await gameRef.loadSprite('volume_up.png');
      paint.colorFilter = const ColorFilter.mode(
        Color(0xFFFFFFFF), // White
        BlendMode.srcATop,
      );
    }
  }
}
