import 'dart:collection';

import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/shapes.dart';
import 'package:flame/components.dart';

List<SnappablePolygon> mergeAdjacentPolygons(List<SnappablePolygon> polygons) {
  List<SnappablePolygon> mergedPolygons = [];
  Set<SnappablePolygon> visited = {};

  for (var polygon in polygons) {
    if (visited.contains(polygon)) continue; // Skip already merged polygons

    List<SnappablePolygon> connectedGroup =
        _findConnectedPolygons(polygon, polygons, visited);

    if (connectedGroup.length > 1) {
      // ✅ Merge polygons into a single shape
      SnappablePolygon mergedPolygon = _mergePolygonGroup(connectedGroup);
      mergedPolygons.add(mergedPolygon);
    } else {
      mergedPolygons.add(polygon);
    }
  }

  return mergedPolygons;
}

// 🔹 Find adjacent polygons of the same color
List<SnappablePolygon> _findConnectedPolygons(SnappablePolygon start,
    List<SnappablePolygon> allPolygons, Set<SnappablePolygon> visited) {
  List<SnappablePolygon> group = [];
  Queue<SnappablePolygon> queue = Queue()..add(start);

  while (queue.isNotEmpty) {
    SnappablePolygon current = queue.removeFirst();
    if (visited.contains(current)) continue;

    visited.add(current);
    group.add(current);

    for (var neighbor in allPolygons) {
      if (!visited.contains(neighbor) &&
          _arePolygonsAdjacent(current, neighbor)) {
        queue.add(neighbor);
      }
    }
  }

  return group;
}

// 🔹 Check if two polygons are adjacent (share an edge)
bool _arePolygonsAdjacent(SnappablePolygon a, SnappablePolygon b) {
  if (a.color != b.color) return false; // Must be the same color

  Set<Vector2> sharedVertices =
      a.vertices.toSet().intersection(b.vertices.toSet());

  return sharedVertices.length == 2; // Must share exactly 2 vertices (one edge)
}

// 🔹 Merge a group of adjacent polygons into a single one
SnappablePolygon _mergePolygonGroup(List<SnappablePolygon> group) {
  List<Vector2> mergedVertices = _mergeVertices(group);

  return SnappablePolygon(
    vertices: mergedVertices,
    isDraggable: group.first.isDraggable, // Preserve behavior
    grid: tempGrid, // Use a temporary grid
  )..color = group.first.color;
  ;
}

// 🔹 Merge all vertices from adjacent polygons into one shape
List<Vector2> _mergeVertices(List<SnappablePolygon> polygons) {
  Set<Vector2> allVertices = {};

  for (var polygon in polygons) {
    allVertices.addAll(polygon.vertices);
  }

  return _orderVertices(allVertices.toList());
}

// 🔹 Order vertices correctly to maintain a valid polygon shape
List<Vector2> _orderVertices(List<Vector2> vertices) {
  vertices.sort((a, b) =>
      a.y.compareTo(b.y) == 0 ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
  return vertices;
}
