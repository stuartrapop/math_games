import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

/// Custom component combining `BodyComponent` and manual position handling.
abstract class PositionBodyComponent<T extends Forge2DGame>
    extends BodyComponent<T> {
  /// Sync visual position with the body's position.
  Vector2 get position => body.position;

  set position(Vector2 newPosition) {
    body.setTransform(newPosition, body.angle);
  }

  /// Sync visual angle with the body's angle.
  double get angle => body.angle;

  set angle(double newAngle) {
    body.setTransform(body.position, newAngle);
  }

  @override
  Future<void> onRemove() async {
    print('Removing PositionBodyComponent body...');
    // Ensure the body is destroyed before removing the component
    if (body.isActive) {
      world.destroyBody(body);
    }
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Optional: Add custom updates related to position and angle if needed
  }

  @override
  void render(Canvas canvas) {
    // Render at the body's position and angle
    canvas.save();
    canvas.translate(body.position.x, body.position.y);
    canvas.rotate(body.angle);
    super.render(canvas);
    canvas.restore();
  }
}
