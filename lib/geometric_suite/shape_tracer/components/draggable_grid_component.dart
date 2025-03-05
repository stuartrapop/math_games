import 'dart:async';

import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/shape_tracer/components/tracable_polygon.dart';
import 'package:first_math/geometric_suite/shape_tracer/shape_tracer_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DraggableGridComponent extends GridComponent
    with DragCallbacks, HasGameRef<ShapeTracerGame> {
  Vector2? currentStartVertex;
  Vector2? tempEndVertex;

  late EffectController movementController = EffectController(duration: 1.0);
  late Vector2 movementOffset = Vector2.zero();
  DraggableGridComponent({
    required super.gridSize,
    required super.rows,
    required super.cols,
    required super.lineWidth,
  });
  @override
  void onLoad() {
    print("loading draggable grid");
    size = Vector2(gridSize * cols.toDouble(), gridSize * rows.toDouble());
    add(RectangleHitbox());
    super.onLoad();
  }

  Future<void> demoMoveTo() async {
    List<(Vector2, Vector2)> untracedEdges = getUntracedEdges();
    if (untracedEdges.isEmpty) {
      print("No untraced edges found");
      return;
    }

    Vector2 start = untracedEdges[0].$1;
    Vector2 end = untracedEdges[0].$2;
    movementOffset = (end - start) * gridSize.toDouble();
    double duration = (100 + movementOffset.length) / (5.0 * 35);
    final hand = SpriteComponent(
      sprite: await gameRef.loadSprite('click.png'),
      size: Vector2.all(50),
      position: (start) * gridSize.toDouble() - Vector2(12, 10),
      anchor: Anchor.topLeft,
    );
    add(hand);
    movementController = EffectController(duration: duration, alternate: true);

    currentStartVertex = (start);
    tempEndVertex = (start);

    Completer<void> completer = Completer<void>();
    priority = 10;

    final effect = SequenceEffect(
      [
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(duration: 0.3, alternate: true),
        ),
        MoveEffect.by(
          movementOffset,
          movementController,
        ),
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(duration: 0.3, alternate: true),
        ),
      ],
      onComplete: () {
        priority = 1; // ✅ Reset priority after movement completes
        completer.complete();
        remove(hand);
        currentStartVertex = null;
        tempEndVertex = null;
      },
    );

    Future.delayed(Duration.zero, () {
      hand.add(effect);
    });

    await completer.future;
  }

  bool isSolution() {
    List<TracablePolygon> tracablePolygons =
        children.whereType<TracablePolygon>().toList();
    bool allTraced = true;
    for (var polygon in tracablePolygons) {
      if (!polygon.isFullyTraced) {
        allTraced = false;
        break;
      }
    }
    return allTraced;
  }

  @override
  void update(double dt) {
    if (movementController.progress > 0) {
      tempEndVertex = currentStartVertex! +
          (movementOffset / gridSize.toDouble()) * movementController.progress;
    }
    super.update(dt);
  }

  // /// ✅ Detects when a drag starts on a valid vertex
  @override
  void onDragStart(DragStartEvent event) {
    Vector2 startGridPoint = event.localPosition / gridSize.toDouble();

    Vector2 startVertex = _getNearestVertex(startGridPoint);

    print("Drag started from: $startVertex startGridPoint: $startGridPoint");
    if (_isCloseToVertex(startVertex, startGridPoint)) {
      currentStartVertex = startVertex;
      tempEndVertex = null; // Reset temp end vertex
      print("currentStartVertex from: $currentStartVertex");
    } else {
      currentStartVertex = null;
    }
    super.onDragStart(event);
  }

  // @override
  void onDragUpdate(DragUpdateEvent event) {
    if (currentStartVertex != null) {
      tempEndVertex = event.localEndPosition / gridSize.toDouble();
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (currentStartVertex != null) {
      Vector2 endVertex = _getNearestVertex(tempEndVertex!);

      if (_isCloseToVertex(endVertex, tempEndVertex!) &&
          endVertex != currentStartVertex) {
        // ✅ Ensure line is not already in `tracedLines`
        if (!_lineExists(currentStartVertex!, endVertex)) {
          List<(Vector2, Vector2)> edges = [];

          List<TracablePolygon> tracablePolygons =
              children.whereType<TracablePolygon>().toList();
          bool edgeFound = false;
          for (var polygon in tracablePolygons) {
            List<(Vector2, Vector2)> polygonEdges =
                polygon.getPolygonEdges(polygon: polygon);
            edges.addAll(polygonEdges);

            bool isEdge = edges.any((line) =>
                (line.$1 == currentStartVertex && line.$2 == endVertex) ||
                (line.$1 == endVertex && line.$2 == currentStartVertex));
            if (isEdge) {
              print("Line is an edge");
              edgeFound = true;
              break;
            }
          }
          if (!edgeFound) {
            print("Line is not an edge");
            currentStartVertex = null;
            tempEndVertex = null;
            return;
          }

          if (_lineExists(currentStartVertex!, endVertex)) {
            print("Line already exists");
            return;
          }

          gameRef.tracedLines.add((currentStartVertex!, endVertex));
          print("Line added: $currentStartVertex -> $endVertex");
        } else {
          print("Duplicate line ignored: $currentStartVertex -> $endVertex");
        }
      } else {
        print("Drag ended, but not near a valid vertex. No line drawn.");
      }
      super.onDragEnd(event);

      // Reset tracking variables
      currentStartVertex = null;
      tempEndVertex = null;
    }
  }

  /// ✅ Returns a list of edges that have NOT been traced
  List<(Vector2, Vector2)> getUntracedEdges() {
    // ✅ Get all polygon edges
    List<(Vector2, Vector2)> allEdges = _getAllPolygonEdges();

    // ✅ Use a Set for faster lookup
    Set<(Vector2, Vector2)> tracedSet = {
      for (var line in gameRef.tracedLines)
        line.$1.x < line.$2.x ||
                (line.$1.x == line.$2.x && line.$1.y < line.$2.y)
            ? line
            : (line.$2, line.$1) // Ensure consistent direction
    };

    // ✅ Filter edges that are NOT in `tracedLines`
    List<(Vector2, Vector2)> untracedEdges = allEdges.where((edge) {
      var orderedEdge = edge.$1.x < edge.$2.x ||
              (edge.$1.x == edge.$2.x && edge.$1.y < edge.$2.y)
          ? edge
          : (edge.$2, edge.$1);
      return !tracedSet.contains(orderedEdge);
    }).toList();

    return untracedEdges;
  }

  // /// ✅ Finds the nearest vertex to the given position
  Vector2 _getNearestVertex(Vector2 position) {
    List<TracablePolygon> tracablePolygons =
        children.whereType<TracablePolygon>().toList();

// ✅ Use a Set to store unique vertices
    Set<Vector2> uniqueVertices = {};

// ✅ Loop through all polygons
    for (var polygon in tracablePolygons) {
      for (var vertex in polygon.adjustedVertices) {
        uniqueVertices.add(vertex + polygon.upperLeftPosition!);
      }
    }

// ✅ Convert the Set to a List
    List<Vector2> gridVertices = uniqueVertices.toList();

    Vector2 nearestVertex = gridVertices.reduce(
        (a, b) => (a - position).length < (b - position).length ? a : b);
    return nearestVertex;
  }

  // /// ✅ Checks if a position is close to a vertex (clicking or ending drag)
  bool _isCloseToVertex(Vector2 vertex, Vector2 position) {
    return (vertex - position).length < 0.7;
  }

  bool _lineExists(Vector2 start, Vector2 end) {
    return gameRef.tracedLines.any((line) =>
        (line.$1 == start && line.$2 == end) ||
        (line.$1 == end && line.$2 == start));
  }

  /// ✅ Helper function to get all edges of the polygon
  List<(Vector2, Vector2)> _getAllPolygonEdges() {
    List<TracablePolygon> tracablePolygons =
        children.whereType<TracablePolygon>().toList();

// ✅ Use a Set to store unique edges
    Set<(Vector2, Vector2)> uniqueEdges = {};
    for (var polygon in tracablePolygons) {
      List<(Vector2, Vector2)> edges =
          polygon.getPolygonEdges(polygon: polygon);
      for (var edge in edges) {
        // ✅ Ensure each edge is stored in one direction (start < end)
        var orderedEdge = edge.$1.x < edge.$2.x ||
                (edge.$1.x == edge.$2.x && edge.$1.y < edge.$2.y)
            ? edge
            : (edge.$2, edge.$1);

        uniqueEdges.add(orderedEdge);
      }
    }
    return uniqueEdges.toList();
  }

  void _drawTracedLines(Canvas canvas) {
    final Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 6.0;

    // Draw the current temporary line (while dragging)
    if (currentStartVertex != null && tempEndVertex != null) {
      Vector2 startVertex = currentStartVertex!;
      Vector2 endVertex = tempEndVertex!;

      canvas.drawLine(
        Offset(startVertex.x * gridSize.toDouble(),
            startVertex.y * gridSize.toDouble()),
        Offset(endVertex.x * gridSize.toDouble(),
            endVertex.y * gridSize.toDouble()),
        linePaint..color = Colors.red,
      );
    }
  }

  void printLines(
      {required List<(Vector2, Vector2)> edges, required String title}) {
    print("Printing lines: edges.length: ${edges.length}");
    for (var edge in edges) {
      print("$title: (${edge.$1}, ${edge.$2})");
    }
  }

  @override
  void render(Canvas canvas) {
    _drawTracedLines(canvas); // Draw the traced lines

    super.render(canvas);
  }
}
