import 'dart:math';

import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:first_math/utils/constants.dart';
import 'package:first_math/utils/geometry_helpers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geobase/geobase.dart' as gb;
import 'package:geobase/geobase.dart';

class ScaledCenteredPolygon extends PositionComponent
    with
        FlameBlocReader<MatchStatsBloc, MatchStatsState>,
        HasPaint,
        CollisionCallbacks,
        HasGameRef,
        HasVisibility {
  final Vector2 initialPosition;
  String label;
  gb.PositionSeries positionSeries;
  double rotateSpeed;
  double radius;
  double yAxisRotateSpeed;
  ScaledCenteredPolygon({
    required this.initialPosition,
    required this.label,
    required this.rotateSpeed,
    int priority = 1,
    required this.positionSeries,
    required this.radius,
    required this.yAxisRotateSpeed,
  }) : super(anchor: Anchor.center);

  late Path path;
  late Vector2 labelPosition;
  late gb.PositionSeries scaleSeries;
  late gb.PositionSeries polyCenterSeries;
  late gb.Position polyCenter;
  late double rotation = 0;
  late double yAxisRotation = 0;
  late Paint objectColor;
  late double distancePolyCenterToFurthestPoint;

  void updateGeometry() {
    final rotateSeries = rotatePolygon(
      source: polyCenterSeries,
      rotation: rotation,
      yAxisRotation: yAxisRotation,
      polyLabeCenter: polyCenter,
    );

    labelPosition = size / 2;

    path = positionSeriesToPath(rotateSeries, size);
  }

  @override
  void update(double dt) {
    rotation = (rotation + rotateSpeed * dt) % (2 * pi);
    yAxisRotation = (yAxisRotation + yAxisRotateSpeed * dt) % (2 * pi);
    double blendFactor = (sin(yAxisRotation) + 1) / 2;

    // Interpolate between blue and red using the blend factor
    objectColor.color = Color.lerp(Color.fromARGB(255, 44, 15, 214),
        Color.fromARGB(255, 189, 82, 130), blendFactor)!;
    updateGeometry();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    scaleSeries = scalePolygon(source: positionSeries, radius: radius);

    path = positionSeriesToPath(scaleSeries, size);

    polyCenter = Polygon([scaleSeries]).polylabel2D().position;
    polyCenterSeries =
        offsetPolygon(source: scaleSeries, center: polyCenter, size: size);
    polyCenter = Polygon([polyCenterSeries]).polylabel2D().position;
    objectColor = Paint()
      ..color = const Color.fromARGB(255, 98, 82, 189)
      ..style = PaintingStyle.fill
      ..strokeWidth = 20;
    anchor = Anchor.center;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    print("Collision Start: $points, $other");
  }

  @override
  void render(Canvas canvas) {
    // Draw the filled path
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), fillRed);
    canvas.drawPath(path, objectColor);
    text25White.render(canvas, "$label", labelPosition, anchor: Anchor.center);
    super.render(canvas);
  }
  // @override
  // void render(Canvas canvas) {
  //   // Ensure that the default rendering logic is suppressed
  //   // This avoids any unintended rendering like the large white circle.
  //   final Paint fillBlue = Paint()
  //     ..color = Colors.transparent
  //     ..style = PaintingStyle.fill
  //     ..strokeWidth = 20; // Transparent background
  //   canvas.drawRect(size.toRect(), fillBlue);
  //   super.render(canvas);
  // }
}
