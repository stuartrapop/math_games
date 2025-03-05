import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

enum Direction {
  up,
  down,
  left,
  right,
  idle,
}

enum CollisionDirection {
  up,
  down,
  left,
  right,
  none,
}

Direction determineDirection(Vector2 character, Vector2 event) {
  double deltaX = event.x - character.x;
  double deltaY = event.y - character.y;

  // Determine if horizontal or vertical movement dominates
  if (deltaX.abs() > deltaY.abs()) {
    // Horizontal movement (Right or Left)
    return deltaX > 0 ? Direction.right : Direction.left;
  } else {
    // Vertical movement (Up or Down)
    return deltaY > 0 ? Direction.down : Direction.up;
  }
}

class TileWorld extends World with HasGameRef<TiledGame>, TapCallbacks {
  Timer? _tapTimer;
  int _tapCount = 0;
  @override
  void onTapDown(TapDownEvent event) {
    TiledGame game = gameRef;
    final double doubleTapInterval = 0.3;
    game.direction =
        determineDirection(game.george.position, event.localPosition);

    _tapCount++;
    print("Tap count: $_tapCount");

    if (_tapCount == 1) {
      // Start a timer on the first tap
      _tapTimer = Timer(doubleTapInterval, onTick: () {
        if (_tapCount == 1) {
          // Single tap detected
          print("Single tap detected at ${event.localPosition}");
          print("Direction: ${game.direction}");
          print("Collision Direction: ${game.collisionDirection}");
        }
        _tapCount = 0;
      })
        ..start();
    } else if (_tapCount == 2) {
      game.direction = Direction.idle;
      _tapTimer?.stop();
      _tapCount = 0;
    }

    super.onTapDown(event);
  }

  @override
  void update(double dt) {
    _tapTimer?.update(dt);
    super.update(dt);
  }
}
