import 'dart:async';
import 'dart:ui';

import 'package:first_math/geometric_suite/tiled_menu/components/character_component.dart';
import 'package:first_math/geometric_suite/tiled_menu/tile_world.dart';
import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ObstacleComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<TiledGame> {
  bool disabled;
  bool _hasCollided = false;
  ObstacleComponent({this.disabled = false}) {}

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(RectangleHitbox());
    // debugMode = true;
    debugColor = const Color(0xFFFF00FF);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (disabled) return;

    if (other is CharacterComponent) {
      if (!_hasCollided) {
        switch (game.direction) {
          case Direction.idle:
            game.collisionDirection = CollisionDirection.none;
            break;
          case Direction.down:
            game.collisionDirection = CollisionDirection.down;
            break;
          case Direction.left:
            game.collisionDirection = CollisionDirection.left;

            break;
          case Direction.up:
            game.collisionDirection = CollisionDirection.up;
            break;
          case Direction.right:
            game.collisionDirection = CollisionDirection.right;
            break;
        }
        game.direction = Direction.idle;

        _hasCollided = true;
        print(
            'collision with obstacle in direction: ${game.collisionDirection}');
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is CharacterComponent) {
      game.collisionDirection = CollisionDirection.none;
      _hasCollided = false;
    }
  }
}
