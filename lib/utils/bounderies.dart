import 'package:first_math/utils/geometry_helpers.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:geobase/geobase.dart' as gb;

List<Wall> createBoundaries({
  double? strokeWidth,
  required double borderWidth,
  required double iconSide,
}) {
  // Create the boundaries of the game screen with border and 4 corner icons starting from the top left corner
  gb.PositionSeries outerFrame = gb.PositionSeries.from([
    gb.Position.create(x: iconSide, y: borderWidth),
    gb.Position.create(x: 600 - iconSide, y: borderWidth),
    gb.Position.create(x: 600 - iconSide, y: iconSide),
    gb.Position.create(x: 600 - borderWidth, y: iconSide),
    gb.Position.create(x: 600 - borderWidth, y: 900 - iconSide),
    gb.Position.create(x: 600 - iconSide, y: 900 - iconSide),
    gb.Position.create(x: 600 - iconSide, y: 900 - borderWidth),
    gb.Position.create(x: iconSide, y: 900 - borderWidth),
    gb.Position.create(x: iconSide, y: 900 - iconSide),
    gb.Position.create(x: borderWidth, y: 900 - iconSide),
  ]);

  return polygonToWalls(
    polygon: outerFrame,
  );
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final double strokeWidth;

  Wall(this.start, this.end, {double? strokeWidth})
      : strokeWidth = strokeWidth ?? 1;

  @override
  Future<void> onRemove() async {
    // Ensure the body is destroyed before removing the component
    if (body.isActive) {
      print('Removing wall body before destroy... $this');
      world.destroyBody(body);
      print('Removing wall body after destroy... $this');
    }
    super.onRemove();
  }

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: Vector2.zero(),
    );
    paint.strokeWidth = strokeWidth;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
