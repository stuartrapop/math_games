import 'package:flame/components.dart';

enum SpriteName {
  fire,
  hearts,
  frogs,
  blueCoin,
  redGem,
  yellowGem,
}

class SpriteInfo {
  final String fileName;
  final int frames;
  final int framesPerRow;
  final Vector2 frameSize;
  final double stepTime;

  SpriteInfo({
    required this.fileName,
    required this.frames,
    required this.framesPerRow,
    required this.frameSize,
    required this.stepTime,
  });
}

extension SpriteTypeExtension on SpriteName {
  SpriteInfo get fileInfo {
    switch (this) {
      case SpriteName.fire:
        return SpriteInfo(
          fileName: "/fireGif/fire4-ezgif.com-gif.png",
          frames: 27,
          framesPerRow: 5,
          frameSize: Vector2(241, 320),
          stepTime: 0.05,
        );
      case SpriteName.hearts:
        return SpriteInfo(
          fileName: "/fireGif/hearts-sprite.png",
          frames: 7,
          framesPerRow: 5,
          frameSize: Vector2(350, 220),
          stepTime: 0.07,
        );
      case SpriteName.frogs:
        return SpriteInfo(
          fileName: "/fireGif/frogs-sprite.png",
          frames: 4,
          framesPerRow: 5,
          frameSize: Vector2(334, 272),
          stepTime: 0.2,
        );
      case SpriteName.blueCoin:
        return SpriteInfo(
          fileName: "/fireGif/blue-coin-sprite.png",
          frames: 29,
          framesPerRow: 30,
          frameSize: Vector2(300, 300),
          stepTime: 0.01,
        );
      case SpriteName.yellowGem:
        return SpriteInfo(
          fileName: "/fireGif/yellow-gem-sprite.png",
          frames: 30,
          framesPerRow: 30,
          frameSize: Vector2(300, 300),
          stepTime: 0.01,
        );
      case SpriteName.redGem:
        return SpriteInfo(
          fileName: "/fireGif/red-gem-sprite.png",
          frames: 30,
          framesPerRow: 30,
          frameSize: Vector2(300, 300),
          stepTime: 0.01,
        );
    }
  }
}
