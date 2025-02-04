import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class FireAnimation extends SpriteAnimationComponent {
  FireAnimation() : super(size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    final spriteSheet =
        await Flame.images.load('/fireGif/fire4-ezgif.com-gif.png');

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 27, // Number of frames
        amountPerRow: 5,
        textureSize: Vector2(241, 320), // Size of each frame
        stepTime: 0.01, // Speed of animation
      ),
    );
  }
}
