import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BallCup extends Forge2DGame {
  BallCup() : super(gravity: Vector2(0, 10));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add the pivot point and scale bar
    final scalePivot = Pivot(position: Vector2(size.x / 2, size.y / 2));
    add(scalePivot);

    final scaleBar = ScaleBar(pivot: scalePivot, length: 200);
    add(scaleBar);
    await Future.wait([scaleBar.loaded]);

// Add weights to the scale and attach them with strings
    final leftWeight = Weight(
      initialPosition: Vector2(size.x / 2 - 100, size.y / 2 + 200),
      radius: 10,
      anchorBody: scaleBar.body,
      isLeft: true,
      barLength: 200,
    );
    final rightWeight = Weight(
      initialPosition: Vector2(size.x / 2 + 100, size.y / 2 + 200),
      radius: 20,
      anchorBody: scaleBar.body,
      isLeft: false,
      barLength: 200,
    );

    add(leftWeight);
    add(rightWeight);
  }
}

class Pivot extends BodyComponent {
  final Vector2 position;

  Pivot({required this.position});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 10;

    final bodyDef = BodyDef(
      position: position,
      type: BodyType.static,
    );

    final body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset(position.x, position.y),
      5,
      Paint()..color = const Color(0xFF000000),
    );
  }
}

class ScaleBar extends BodyComponent {
  final Pivot pivot;
  final double length;

  ScaleBar({required this.pivot, required this.length});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Defer joint creation to `onMount` where `body` is guaranteed to be initialized
  }

  @override
  void onMount() {
    super.onMount();

    // Attach the bar to the pivot with a revolute joint
    final revoluteJointDef = RevoluteJointDef()
      ..initialize(pivot.body, body, pivot.body.position)
      ..enableMotor = false; // No motor for free rotation
    world.createJoint(RevoluteJoint(revoluteJointDef));
  }

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(length / 2, 5, Vector2(0, 100), 0); // Bar dimensions

    final bodyDef = BodyDef(
      position: pivot.body.position,
      type: BodyType.dynamic,
    );

    final body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape, density: 1.0);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // final rect = Rect.fromCenter(
    //   center: Offset(body.position.x, body.position.y),
    //   width: length,
    //   height: 10,
    // );

    // canvas.drawRect(
    //   rect,
    //   Paint()..color = const Color(0xFF888888),
    // );

    // Draw the string connecting the pivot and the scale bar
    // Convert Vector2 to Offset

    canvas.drawLine(
      Offset(-100, 100),
      Offset(0, 0),
      Paint()
        ..color = const Color.fromARGB(255, 159, 32, 32)
        ..strokeWidth = 5,
    );
    canvas.drawLine(
      Offset(100, 100),
      Offset(0, 0),
      Paint()
        ..color = const Color.fromARGB(255, 159, 32, 32)
        ..strokeWidth = 5,
    );
  }
}

class Weight extends BodyComponent with TapCallbacks {
  final Vector2 initialPosition; // Initial position of the weight
  final Body anchorBody; // Reference to the bar (or any anchor body)
  final bool isLeft; // Determines if this is the left or right weight
  final double barLength; // Length of the scale bar
  double radius;
  Vector2 anchorPoint; // Anchor point on the bar
  DistanceJoint? joint; // Reference to the joint for easy re-creation

  Weight({
    required this.initialPosition,
    required this.radius,
    required this.anchorBody,
    required this.isLeft,
    required this.barLength,
  }) : anchorPoint = anchorBody.worldCenter +
            Vector2(isLeft ? -barLength / 2 : barLength / 2, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Attach the weight to the bar (or anchor)
    _attachToAnchor();
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("Tapped on weight");

    // Increment radius
    radius += 5;
    print("New radius: $radius");

    // Remove the old body and re-create it with the updated radius
    world.destroyBody(body);
    final newBody = createBody();
    body = newBody;

    // Recreate the joint to account for the new size
    _recreateJoint();
  }

  void _attachToAnchor() {
    // Create the distance joint
    final jointDef = DistanceJointDef()
      ..initialize(anchorBody, body, anchorPoint, body.position)
      ..dampingRatio = 1
      ..frequencyHz = 0;

    joint = DistanceJoint(jointDef);
    world.createJoint(joint!);
  }

  void _recreateJoint() {
    // Destroy the old joint if it exists
    if (joint != null) {
      world.destroyJoint(joint!);
    }

    // Keep the weight's position consistent with the anchor point
    position.setFrom(
        anchorPoint + Vector2(0, radius + 10)); // Offset for radius growth

    // Attach the weight to the bar again
    _attachToAnchor();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final bodyDef = BodyDef(
      position: initialPosition, // Use the initial position for consistency
      type: BodyType.dynamic,
    );

    final body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape,
        density: 10); // Higher density for realistic weight
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the updated circle
    canvas.drawCircle(
      Offset(body.position.x, body.position.y),
      radius,
      Paint()..color = const Color(0xFF0000FF),
    );
  }
}
