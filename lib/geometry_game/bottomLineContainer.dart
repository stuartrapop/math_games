import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class BottomLineContainer extends BodyComponent<GeometryGame>
    with
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks,
        ContactCallbacks,
        HasGameRef<GeometryGame> {
  String label;
  final double width;
  final double height;

  BottomLineContainer(
      {this.label = '',
      int priority = 1,
      required this.width,
      required this.height});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add a hitbox wrapped in a PositionComponent
// Add a hitbox wrapped in a PositionComponent
    final hitboxComponent = PositionComponent(
      size: Vector2(100, 100),
      position: Vector2(width / 2, -height),
      anchor: Anchor.center,
    )..add(RectangleHitbox()..collisionType = CollisionType.active);

    // Add the hitbox as a child
    add(hitboxComponent);
    // Add the hitbox as a child
  }

  @override
  Future<void> onRemove() async {
    print('Removing bottom line body...');
    // Ensure the body is destroyed before removing the component
    if (body.isActive) {
      world.destroyBody(body);
    }
    super.onRemove();
  }

  @override
  Body createBody() {
    // Create the physics body
    final bodyDef = BodyDef(
      gravityScale: Vector2.all(0),
      userData: this, // Associate this component with the body
      position: Vector2(0, 599),
      type: BodyType.static,
    );

    // Define the shape and attach it to the body as a fixture
    final shape = PolygonShape()
      ..setAsBox(width / 2, height, Vector2(width / 2, height / 2), 0);

    final fixtureDef = FixtureDef(shape)
      ..friction = 0.0
      ..density = 0.8
      ..restitution = 0
      ..filter.categoryBits = 0x0001
      ..filter.maskBits = 0xFFFF
      ..isSensor = false;

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);

    // Log all fixtures
    for (final fixture in body.fixtures) {
      print("Body Fixture: ${fixture.shape}, ${fixture.filterData}");
    }

    return body;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Update the position of the physics body during drag
    final newPosition = body.position + event.delta;
    body.setTransform(newPosition, body.angle);
    print('Dragging ball to: ${body.position}');
    super.onDragUpdate(event);
  }

  // @override
  // void beginContact(Object other, Contact contact) {
  //   print("Begin contact with $other, $contact");
  //   if (other is BodyComponent) {
  //     final newOther = other as BodyComponent;
  //     final otherBody = newOther.body; // Access the body safely
  //     if (otherBody != null) {
  //       // final oldVelocity =
  //       //     Vector2(otherBody.linearVelocity.x, otherBody.linearVelocity.y);
  //       // final newVelocity =
  //       //     Vector2(oldVelocity.x, -oldVelocity.y) * 3; // Reverse Y and double
  //       // otherBody.linearVelocity = newVelocity;
  //       // print(
  //       //     'Collision detected with BodyComponent. OldVelocity $oldVelocity New velocity: ${otherBody.linearVelocity}');

  //       final oldVelocity = otherBody.linearVelocity;
  //       final impulse = Vector2(
  //           0, -5 * oldVelocity.y * otherBody.mass); // Reverse and amplify
  //       otherBody.applyLinearImpulse(impulse, point: otherBody.position);
  //       print('Applied impulse: $impulse');
  //     }
  //   }
  // }

  @override
  void endContact(Object other, Contact contact) {
    if (other is BodyComponent) {
      final newOther = other as BodyComponent;
      final otherBody = newOther.body; // Access the body safely
      if (otherBody != null) {
        final oldVelocity =
            Vector2(otherBody.linearVelocity.x, otherBody.linearVelocity.y);
        final newVelocity = Vector2(oldVelocity.x * 2, oldVelocity.y * 1.5);
        // Reverse and amplify
        Future.delayed(const Duration(milliseconds: 100), () {
          // otherBody.applyLinearImpulse(impulse, point: otherBody.position);
          // otherBody.linearVelocity = newVelocity;
        });
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Apply a velocity when tapped
    body.linearVelocity = body.linearVelocity + Vector2(25, -25);
    print('Applied velocity: ${body.linearVelocity}');
    super.onTapDown(event);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
