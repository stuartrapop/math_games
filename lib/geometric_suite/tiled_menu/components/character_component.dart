import 'dart:ui';

import 'package:first_math/geometric_suite/tiled_menu/tile_world.dart';
import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class CharacterComponent extends SpriteAnimationComponent
    with HasGameRef<TiledGame>, CollisionCallbacks {
  final String fileName;
  final Vector2 srcSize;
  CharacterComponent({required this.fileName, required this.srcSize}) {}
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation idleRightAnimation;
  late SpriteAnimation idleDownAnimation;
  late SpriteAnimation idleLeftAnimation;
  late SpriteAnimation idleUpAnimation;

  final double animationSpeed = .1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // debugMode = true;
    debugColor = const Color.fromARGB(255, 17, 16, 17);
    RectangleHitbox hitbox = RectangleHitbox(
        size: size * 2 / 3, anchor: Anchor.topLeft, position: size / 6);

    add(hitbox);
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load(fileName), srcSize: srcSize);

    // new
    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 3);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 3);
    upAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 3);
    rightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 3);
    idleRightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 1);
    idleDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);
    idleLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 1);
    idleUpAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 1);
    animation = idleRightAnimation;
  }

  @override
  void update(double dt) {
    switch (game.direction) {
      case Direction.idle:
        switch (game.collisionDirection) {
          case CollisionDirection.right:
            animation = idleRightAnimation;
            break;
          case CollisionDirection.left:
            animation = idleLeftAnimation;
            break;
          case CollisionDirection.down:
            animation = idleDownAnimation;
            break;
          case CollisionDirection.up:
            animation = idleUpAnimation;
            break;
          case CollisionDirection.none:
            animation = idleRightAnimation;
            break;
        }

        break;

      case Direction.down:
        animation = downAnimation;
        if (y < game.mapHeight - height) {
          if (game.collisionDirection != CollisionDirection.down) {
            y += dt * game.characterSpeed;
          } else {
            animation = idleDownAnimation;
          }
        } else {
          animation = idleDownAnimation;
        }
        break;
      case Direction.left:
        animation = leftAnimation;
        if (x > 0) {
          if (game.collisionDirection != CollisionDirection.left) {
            x -= dt * game.characterSpeed;
          } else {
            animation = idleLeftAnimation;
          }
        } else {
          animation = idleLeftAnimation;
        }

        break;
      case Direction.up:
        animation = upAnimation;
        if (y > 0) {
          if (game.collisionDirection != CollisionDirection.up) {
            y -= dt * game.characterSpeed;
          } else {
            animation = idleUpAnimation;
          }
        } else {
          animation = idleUpAnimation;
        }

        break;
      case Direction.right:
        animation = rightAnimation;
        if (x < game.mapWidth - width) {
          if (game.collisionDirection != CollisionDirection.right) {
            x += dt * game.characterSpeed;
          } else {
            animation = idleRightAnimation;
          }
        } else {
          animation = idleRightAnimation;
        }
        break;
    }
    super.update(dt);
  }
}
