import 'dart:async';
import 'dart:ui';

import 'package:first_math/geometric_suite/tiled_menu/components/character_component.dart';
import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MenuTriggerComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<TiledGame> {
  bool _hasCollided = false;
  MenuTriggerComponent() {}

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(RectangleHitbox());
    debugMode = true;
    debugColor = const Color(0xFFFF00FF);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CharacterComponent) {
      print('collision with obstacle in direction: ');
      game.returnHome();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is CharacterComponent) {}
  }
}
