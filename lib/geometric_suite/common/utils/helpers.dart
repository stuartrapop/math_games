import 'dart:math';

import 'package:dart_earcut/dart_earcut.dart';
import 'package:flame/components.dart';

/// **Finds the top-left vertex in a given set of vertices**
Vector2 getTopLeft(List<Vector2> vertices) {
  double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
  double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
  return Vector2(minX, minY);
}

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
  // print("🔴 Checking collision between two polygons:");
  // print("a: ${a.map((v) => v).toList()};");
  // print("b: ${b.map((v) => v).toList()}");
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
  // print("sep1: $sep1, sep2: $sep2");
  // print(colliding
  //     ? '✅ COLLISION DETECTED!'
  //     : '❌ NO COLLISION - Objects are touching or separated');

  return colliding;
}

bool isCounterClockwise(List<Vector2> polygon) {
  double sum = 0.0;
  for (int i = 0; i < polygon.length; i++) {
    Vector2 p1 = polygon[i];
    Vector2 p2 = polygon[(i + 1) % polygon.length];
    sum += (p2.x - p1.x) * (p2.y + p1.y);
  }
  return sum > 0;
}

List<List<Vector2>> triangulatePolygonWithHoles({
  required List<Vector2> outerPolygon,
  required List<List<Vector2>> holes,
}) {
  // print("🔹 Original Outer Polygon: $outerPolygon");
  // print("🔹 Original Holes: $holes");

  // Ensure correct winding order
  outerPolygon = ensureCounterClockwise(outerPolygon);
  holes = holes.map((hole) => ensureClockwise(hole)).toList();

  // print("🔄 Corrected Outer Polygon: $outerPolygon");
  // print("🔄 Corrected Holes: $holes");

  List<double> flattenedVertices = [];
  List<int> holeIndices = [];

  // Add outer polygon vertices
  flattenedVertices.addAll(outerPolygon.expand((v) => [v.x, v.y]));

  // Add hole vertices
  int currentIndex = outerPolygon.length;
  for (var hole in holes) {
    holeIndices.add(currentIndex);
    flattenedVertices.addAll(hole.expand((v) => [v.x, v.y]));
    currentIndex += hole.length;
  }

  // print("📍 Flattened Vertices: $flattenedVertices");
  // print("🕳️ Hole Indices: $holeIndices");

  // Triangulate
  List<int> indices =
      Earcut.triangulateRaw(flattenedVertices, holeIndices: holeIndices);

  print("🔺 Raw Indices: $indices");

  if (indices.isEmpty) {
    print("❌ Triangulation failed - No indices generated");
    return [];
  }

  // Combine vertices
  List<Vector2> combinedVertices = [...outerPolygon, ...holes.expand((h) => h)];
  List<List<Vector2>> triangles = [];

  // Generate triangles
  for (int i = 0; i < indices.length; i += 3) {
    List<Vector2> triangle = [
      combinedVertices[indices[i]],
      combinedVertices[indices[i + 1]],
      combinedVertices[indices[i + 2]]
    ];

    // Enhanced hole checking
    Vector2 centroid = Vector2(
        (triangle[0].x + triangle[1].x + triangle[2].x) / 3,
        (triangle[0].y + triangle[1].y + triangle[2].y) / 3);

    print("🔺 Checking Triangle: $triangle");
    print("📍 Triangle Centroid: $centroid");

    bool isInHole = holes.any((hole) => pointInPolygon(centroid, hole));
    print("🕳️ Is Triangle in Hole: $isInHole");

    if (!isInHole) {
      triangles.add(triangle);
      print("✅ Valid Triangle Added: $triangle");
    }
  }

  print("🏁 Total Triangles: ${triangles.length}");
  return triangles;
}

/// **Ensure the outer polygon is counter-clockwise**
List<Vector2> ensureCounterClockwise(List<Vector2> polygon) {
  double area = 0;
  for (int i = 0; i < polygon.length; i++) {
    Vector2 p1 = polygon[i];
    Vector2 p2 = polygon[(i + 1) % polygon.length];
    area += (p2.x - p1.x) * (p2.y + p1.y);
  }
  return area > 0 ? polygon.reversed.toList() : polygon;
}

/// **Ensure holes are clockwise**
List<Vector2> ensureClockwise(List<Vector2> polygon) {
  double area = 0;
  for (int i = 0; i < polygon.length; i++) {
    Vector2 p1 = polygon[i];
    Vector2 p2 = polygon[(i + 1) % polygon.length];
    area += (p2.x - p1.x) * (p2.y + p1.y);
  }
  return area < 0 ? polygon.reversed.toList() : polygon;
}

/// **Check if a triangle is inside any of the holes**
bool isTriangleInsideAnyHole(
    List<Vector2> triangle, List<List<Vector2>> holes) {
  // Calculate triangle centroid
  Vector2 centroid = Vector2(
      (triangle[0].x + triangle[1].x + triangle[2].x) / 3,
      (triangle[0].y + triangle[1].y + triangle[2].y) / 3);

  // Check if centroid is inside any hole
  return holes.any((hole) => pointInPolygon(centroid, hole));
}

/// **Ray-Casting Algorithm: Check if a point is inside a polygon**
bool pointInPolygon(Vector2 point, List<Vector2> polygon) {
  int intersections = 0;
  for (int i = 0; i < polygon.length; i++) {
    Vector2 a = polygon[i];
    Vector2 b = polygon[(i + 1) % polygon.length];

    if ((a.y > point.y) != (b.y > point.y) &&
        point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x) {
      intersections++;
    }
  }
  return (intersections % 2) != 0;
}
