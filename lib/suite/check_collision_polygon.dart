import 'dart:math';

import 'package:forge2d/forge2d.dart';

bool isConvexPolygon(List<Vector2> vertices) {
  if (vertices.length < 3) return false; // Not a valid polygon

  int sign = 0; // Track cross product sign consistency

  for (int i = 0; i < vertices.length; i++) {
    Vector2 v1 = vertices[i];
    Vector2 v2 = vertices[(i + 1) % vertices.length];
    Vector2 v3 = vertices[(i + 2) % vertices.length];

    // Compute edge vectors
    Vector2 edge1 = v2 - v1;
    Vector2 edge2 = v3 - v2;

    // Compute cross product: (edge1.x * edge2.y - edge1.y * edge2.x)
    double crossProduct = edge1.x * edge2.y - edge1.y * edge2.x;

    // Determine sign of the cross product
    if (crossProduct != 0) {
      int currentSign = (crossProduct > 0) ? 1 : -1;

      // If it's the first nonzero cross product, set the reference sign
      if (sign == 0) {
        sign = currentSign;
      } else if (sign != currentSign) {
        // If the sign changes, it's concave
        return false;
      }
    }
  }

  return true; // No sign change, so it's convex
}

/// **Compute the minimum penetration depth between two polygons**
double findMinSeparation(List<Vector2> a, List<Vector2> b) {
  double minSeparation = double.infinity;

  // print('\n🔍 Checking separation between polygons:');
  // print('➡️ Polygon A: ${a}');
  // print('➡️ Polygon B: ${b}');

  Vector2 getPerpendicular(Vector2 vector) {
    return Vector2(-vector.y, vector.x);
  }

  /// **Computes the magnitude (length) of a vector**
  double getMagnitude(Vector2 vector) {
    return sqrt(vector.x * vector.x + vector.y * vector.y);
  }

  /// **Returns a normalized version of a vector**
  Vector2 normalize(Vector2 vector) {
    double mag = getMagnitude(vector);
    return mag == 0 ? Vector2.zero() : Vector2(vector.x / mag, vector.y / mag);
  }

  for (int i = 0; i < a.length; i++) {
    Vector2 v1 = a[i];
    Vector2 v2 = a[(i + 1) % a.length];

    Vector2 edge = v2 - v1;
    Vector2 normal = normalize(getPerpendicular(edge));

    // print('\n🔹 Checking edge: $v1 -> $v2');
    // print('   📏 Edge vector: $edge');
    // print('   📏 Perpendicular axis (Normal): $normal');

    var (minA, maxA) = projectPolygon(a, normal);
    var (minB, maxB) = projectPolygon(b, normal);

    // print('   🟢 Projection of A on axis: [$minA, $maxA]');
    // print('   🔵 Projection of B on axis: [$minB, $maxB]');

    // Compute actual overlap
    double overlap = min(maxA, maxB) - max(minA, minB);

    if (overlap <= 0) {
      // print('   🚫 Separation found on this axis - NO COLLISION');
      return overlap; // If there is no overlap, polygons are separated
    }

    minSeparation = min(minSeparation, overlap);
    // print('   ✅ Overlap on this axis - CONTINUE CHECKING (Overlap: $overlap)');
  }

  // print('✔️ No separating axis found - Polygons are colliding');
  return minSeparation;
}

/// **Project a polygon onto an axis**
(double, double) projectPolygon(List<Vector2> poly, Vector2 axis) {
  double min = poly.first.dot(axis);
  double max = min;

  for (var vertex in poly.skip(1)) {
    double projection = vertex.dot(axis);
    min = projection < min ? projection : min;
    max = projection > max ? projection : max;
  }

  return (min, max);
}

/// **Check if two polygons are colliding**
bool isCollidingPolygonPolygon(List<Vector2> a, List<Vector2> b) {
  const double epsilon = 1e-6;
  double sep1 = findMinSeparation(a, b);
  double sep2 = findMinSeparation(b, a);

  if (!isConvexPolygon(a) || !isConvexPolygon(b)) {
    print('🔴 Error all Polygons must be convex');
  }

  // print('\n🔽 FINAL CHECK:');
  // print('   🔴 Separation A→B: $sep1');
  // print('   🔵 Separation B→A: $sep2');

  bool colliding = sep1 > epsilon && sep2 > epsilon;
  print("sep1: $sep1, sep2: $sep2");
  print(colliding
      ? '✅ COLLISION DETECTED!'
      : '❌ NO COLLISION - Objects are touching or separated');

  return colliding;
}
