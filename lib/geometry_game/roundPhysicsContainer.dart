import 'dart:math';

import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:first_math/geometry_game/scaledCenteredPolygon.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geobase/geobase.dart' as gb;

class RoundPhysicsContainer extends BodyComponent<GeometryGame>
    with TapCallbacks, DragCallbacks, CollisionCallbacks, ContactCallbacks {
  final Vector2 initialPosition;
  final double radius;
  String label;
  gb.PositionSeries positionSeries;
  double rotateSpeed;
  late double velocity;
  double yAxisRotateSpeed;

  RoundPhysicsContainer({
    required this.initialPosition,
    this.label = '',
    required this.rotateSpeed,
    int priority = 1,
    required this.positionSeries,
    required this.radius,
    required this.yAxisRotateSpeed,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add the visual and interactive layer
    final visualLayer = ScaledCenteredPolygon(
      initialPosition: initialPosition,
      label: label,
      positionSeries: positionSeries,
      rotateSpeed: rotateSpeed,
      yAxisRotateSpeed: yAxisRotateSpeed,
      radius: radius,
    )..anchor = Anchor.center;

    // Position it at the center of the body
    visualLayer.position = Vector2.zero();

    // Add the visual layer as a child
    add(visualLayer);
    // Add a hitbox for collision
    // Add a hitbox wrapped in a PositionComponent
  }

  @override
  Future<void> onRemove() async {
    print('Removing round physics body...');
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
      gravityScale: Vector2(1, 1),
      angularDamping: 1,
      userData: this, // Associate this component with the body
      position: initialPosition,
      fixedRotation: true,
      type: BodyType.dynamic,
    );

    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..friction = 0.0
      ..density = 2
      ..restitution = 1
      ..filter.categoryBits = 0x0001
      ..filter.maskBits = 0xFFFF
      ..isSensor = false;

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);
    final double random = Random().nextInt(100).toDouble();
    body.linearVelocity = Vector2(random, random);

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

  @override
  void endContact(Object other, Contact contact) {
    if (other is RoundPhysicsContainer) {
      final newOther = other as RoundPhysicsContainer;
      final otherBody = newOther.body; // Access the body safely
      if (otherBody != null) {
        final oldVelocity = otherBody.linearVelocity;
        final newVelocity = Vector2(50, 100 * oldVelocity.y);
        // otherBody.linearVelocity = newVelocity;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Apply a velocity when tapped
    final double random = Random().nextInt(100).toDouble();
    print('Tapped ball with velocity: $random');
    body.linearVelocity = Vector2(random, random);
    super.onTapDown(event);
  }

  @override
  void render(Canvas canvas) {
    // super.render(canvas);
  }
}
