import 'dart:math';

import 'package:dart_earcut/dart_earcut.dart';
import 'package:first_math/geometric_suite/common/utils/helpers.dart';
import 'package:first_math/geometric_suite/suite/components/interface_snappable_shape.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_circle.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon_with_circular_hole.dart';
import 'package:flame/components.dart';

bool checkOverlap(
    InterfaceSnappableShape other, InterfaceSnappableShape dragged) {
  print("Checking Overlap");
  if (other is SnappableCircle && dragged is SnappablePolygon) {
    print("Circle-Polygon Collision ");
    return _circlePolygonOverlap(circle: other, polygon: dragged);
  } else if (other is SnappablePolygon && dragged is SnappableCircle) {
    print("Polygon-Circle Collision");
    return _circlePolygonOverlap(circle: dragged, polygon: other);
  } else if (other is SnappablePolygon && dragged is SnappablePolygon) {
    print("**********Polygon-Polygon Collision");
    return _polygonPolygonOverlap(p1: other, p2: dragged);
  } else if (other is SnappableCircle && dragged is SnappableCircle) {
    print("Circle-Circle Collision");
    return _circleCircleOverlap(c1: other, c2: dragged);
  } else if (other is SnappablePolygonWithCircularHole) {
    print("Polygon with Hole other is polygon with hole");
    return isDraggedInsideHole(shape1: dragged, shape2: other);
  } else if (dragged is SnappablePolygonWithCircularHole) {
    print("Polygon with Hole dragged is polygon with hole");
    return isDraggedInsideHole(shape1: other, shape2: dragged);
  } else {
    // Default case (shouldn't happen)
    throw ArgumentError("Unsupported shape types: $other, $dragged");
  }
}

bool isDraggedInsideHole({
  required InterfaceSnappableShape shape1,
  required SnappablePolygonWithCircularHole shape2,
}) {
  final Vector2 holeCenter = (shape2.position + shape2.size / 2) /
      shape1.grid.gridSize.toDouble(); // Center of the polygon
  final double holeRadius = shape2.holeRadius;
  print("Hole Center: $holeCenter, Hole Radius: $holeRadius");
  // ✅ If shape1 shape is a SnappablePolygon (check all vertices)
  if (shape1 is SnappablePolygon) {
    print("shape1 vertices: ${shape1.adjustedVertices}");
    Vector2 shape1Position = shape1.position / shape1.grid.gridSize.toDouble();
    print("shape1 position: ${shape1Position}");
    bool allVerticesInside = shape1.adjustedVertices.every(
      (vertex) => (vertex + shape1Position).distanceTo(holeCenter) < holeRadius,
    );

    if (allVerticesInside) {
      print("Polygon is completely inside the hole!");
      return false;
    }
  }

  // ✅ If shape1 shape is a SnappableCircle (check if fully inside)
  else if (shape1 is SnappableCircle) {
    double shape1Radius = shape1.radius / shape1.grid.gridSize.toDouble();
    Vector2 shape1Position = shape1.position / shape1.grid.gridSize.toDouble();
    print("shape1Radius: $shape1Radius");
    print("shape1 position: ${shape1.position}");

    Vector2 shape1Center = shape1Position + Vector2.all(shape1Radius);
    print("shape1Center: $shape1Center hole center $holeCenter");
    double circleDistance = shape1Center.distanceTo(holeCenter);

    if (circleDistance + shape1Radius <= holeRadius) {
      print("Circle is fully inside the hole!");
      return false;
    }
  }

  // ✅ Shape is NOT fully inside the hole (valid movement)
  SnappablePolygon normalPolygon = SnappablePolygon(
    vertices: shape2.vertices, // Only outer vertices
    grid: shape2.grid,
    questionIndex: shape2.questionIndex,
    polygonIndex: shape2.polygonIndex,
    flipHorizontal: shape2.flipHorizontal,
    flipVertical: shape2.flipVertical,
    upperLeftPosition: shape2.upperLeftPosition,
    isDraggable: shape2.isDraggable,
  ).copyWith(
    pixelToUnitRatio: shape2.pixelToUnitRatio,
  )..position = shape2.position;

  // ✅ Now check for regular overlap using `checkOverlap`
  return checkOverlap(normalPolygon, shape1);
}

/// ✅ Circle-Circle Collision
bool _circleCircleOverlap(
    {required SnappableCircle c1, required SnappableCircle c2}) {
  double distance = c1.position.distanceTo(c2.position);
  return distance < (c1.radius + c2.radius);
}

/// ✅ Polygon-Polygon Collision (Existing Logic)
bool _polygonPolygonOverlap(
    {required SnappablePolygon p1, required SnappablePolygon p2}) {
  print("p1: ${p1.adjustedVertices}, p2: ${p2.adjustedVertices}");

  Vector2 p1GridPosition = p1.position / p1.pixelToUnitRatio;
  Vector2 p2GridPosition = p2.position / p2.pixelToUnitRatio;

  print("p1GridPosition: $p1GridPosition, p2GridPosition: $p2GridPosition");

  List<Vector2> p1Polygon =
      p1.adjustedVertices.map((v) => v + p1GridPosition).toList();
  List<Vector2> p2Polygon =
      p2.adjustedVertices.map((v) => v + p2GridPosition).toList();
  List<Vector2> p1PolygonInner =
      p1.adjustedInnerVertices.map((v) => v + p1GridPosition).toList();
  List<Vector2> p2PolygonInner =
      p2.adjustedInnerVertices.map((v) => v + p2GridPosition).toList();

  print("p1Polygon: $p1Polygon, p2Polygon: $p2Polygon");
  print("p1PolygonInner: $p1PolygonInner, p2PolygonInner: $p2PolygonInner");

  // List<List<Vector2>> p1ConvexPolygons = _triangulatePolygon(p1Polygon);
  // List<List<Vector2>> p2ConvexPolygons = _triangulatePolygon(p2Polygon);

  List<List<Vector2>> p1ConvexPolygons = p1PolygonInner.isNotEmpty
      ? triangulatePolygonWithHoles(
          outerPolygon: p1Polygon,
          holes: [p1PolygonInner],
        )
      : _triangulatePolygon(p1Polygon);

  List<List<Vector2>> p2ConvexPolygons = p2PolygonInner.isNotEmpty
      ? triangulatePolygonWithHoles(
          outerPolygon: p2Polygon,
          holes: [p2PolygonInner],
        )
      : _triangulatePolygon(p2Polygon);

  print("p1ConvexPolygons: $p1ConvexPolygons");
  print("p2ConvexPolygons: $p2ConvexPolygons");

  for (var poly1 in p1ConvexPolygons) {
    for (var poly2 in p2ConvexPolygons) {
      if (isCollidingPolygonPolygon(poly1, poly2)) {
        return true;
      }
    }
  }
  return false;
}

/// ✅ Circle-Polygon Collision
bool _circlePolygonOverlap({
  required SnappableCircle circle,
  required SnappablePolygon polygon,
}) {
  double pixelToUnitRatio = polygon.pixelToUnitRatio;
  double circleRadius = circle.radius / pixelToUnitRatio;
  Vector2 circleCenter =
      circle.position / pixelToUnitRatio + Vector2.all(circleRadius);
  Vector2 polygonPosition = polygon.position / pixelToUnitRatio;

  print("Circle Center: $circleCenter, Circle Radius: $circleRadius");
  print("Polygon Vertices: ${polygon.adjustedVertices}");

  // Check if any polygon edge is too close to the circle
  for (int i = 0; i < polygon.adjustedVertices.length; i++) {
    Vector2 v1 = polygon.adjustedVertices[i] + polygonPosition;
    Vector2 v2 =
        polygon.adjustedVertices[(i + 1) % polygon.adjustedVertices.length] +
            polygonPosition;

    double distance = _distanceToSegment(circleCenter, v1, v2);
    print(
        "Distance to Segment $v1 $v2,  $i: $distance circle radius: $circleRadius");
    if (distance < circleRadius) return true;
  }

  // Check if the circle's center is inside the polygon
  if (isPointInPolygon(
    point: circleCenter,
    polygon: polygon.adjustedVertices,
    polygonPosition: polygonPosition,
  )) {
    print("Circle Center Inside Polygon");
    return true;
  }
  print("Circle Center Outside Polygon");
  return false;
}

/// ✅ Triangulate Polygon for Collision
List<List<Vector2>> _triangulatePolygon(List<Vector2> polygon) {
  if (isConvexPolygon(polygon)) {
    return [polygon];
  }

  List<List<Vector2>> convexPolygons = [];
  List<int> indices = Earcut.triangulateFromPoints(
      polygon.map((v) => Point(v.x, v.y)).toList());

  for (int i = 0; i < indices.length; i += 3) {
    convexPolygons.add([
      polygon[indices[i]],
      polygon[indices[i + 1]],
      polygon[indices[i + 2]],
    ]);
  }
  return convexPolygons;
}

/// ✅ Distance from a point to a line segment (for circle-polygon check)
double _distanceToSegment(Vector2 point, Vector2 v1, Vector2 v2) {
  double lengthSquared = v1.distanceToSquared(v2);
  if (lengthSquared == 0.0) return point.distanceTo(v1);
  double t = ((point - v1).dot(v2 - v1)) / lengthSquared;
  t = t.clamp(0.0, 1.0);
  Vector2 projection = v1 + (v2 - v1) * t;
  return point.distanceTo(projection);
}

/// ✅ Checks if a point is inside a polygon using the Ray-Casting Algorithm.
bool isPointInPolygon(
    {required Vector2 point,
    required List<Vector2> polygon,
    required Vector2 polygonPosition}) {
  print("point: $point, polygon: $polygon");
  int intersections = 0;

  for (int i = 0; i < polygon.length; i++) {
    Vector2 v1 = polygon[i] + polygonPosition;
    Vector2 v2 = polygon[(i + 1) % polygon.length] + polygonPosition;

    // Check if the point is exactly on a vertex
    if (point == v1 || point == v2) {
      return true;
    }

    // Check if the point is exactly on an edge
    if (_isPointOnSegment(point, v1, v2)) {
      return true;
    }

    // Ray-casting algorithm: count intersections with polygon edges
    if ((v1.y > point.y) != (v2.y > point.y) &&
        (point.x < (v2.x - v1.x) * (point.y - v1.y) / (v2.y - v1.y) + v1.x)) {
      intersections++;
    }
  }

  // If the number of intersections is odd, the point is inside the polygon
  return (intersections % 2) == 1;
}

/// ✅ Checks if a point lies exactly on a segment between two vertices.
bool _isPointOnSegment(Vector2 point, Vector2 v1, Vector2 v2) {
  double crossProduct =
      (point.y - v1.y) * (v2.x - v1.x) - (point.x - v1.x) * (v2.y - v1.y);
  if (crossProduct.abs() > 1e-10) {
    return false;
  }

  double dotProduct =
      (point.x - v1.x) * (v2.x - v1.x) + (point.y - v1.y) * (v2.y - v1.y);
  if (dotProduct < 0) {
    return false;
  }

  double squaredLength =
      (v2.x - v1.x) * (v2.x - v1.x) + (v2.y - v1.y) * (v2.y - v1.y);
  if (dotProduct > squaredLength) {
    return false;
  }

  return true;
}
