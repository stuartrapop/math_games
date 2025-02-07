import 'package:first_math/suite/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class AnimatedSprite extends SpriteAnimationComponent {
  final SpriteName spriteName;

  AnimatedSprite({
    required this.spriteName,
  }) : super(size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Flame.images.load(spriteName.fileInfo.fileName);

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: spriteName.fileInfo.frames, // Dynamic frame count
        amountPerRow:
            spriteName.fileInfo.framesPerRow >= spriteName.fileInfo.frames
                ? null
                : spriteName.fileInfo.framesPerRow,
        textureSize: spriteName.fileInfo.frameSize, // Dynamic frame size
        stepTime: spriteName.fileInfo.stepTime, // Speed of animation
      ),
    );
  }
}
