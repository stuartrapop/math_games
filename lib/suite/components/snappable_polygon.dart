import 'dart:math';
import 'dart:ui';

import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class SnappablePolygon extends BodyComponent
    with DragCallbacks, ContactCallbacks {
  final GridComponent grid;
  final List<Vector2> vertices;
  late final Vector2 initialPosition;
  final Color polyColor;
  double scaleWidth; // ✅ Scale width of the polygon
  double scaleHeight;
  double rotation;
  bool isDraggable;
  Vector2? lastValidPosition;

  late final double polygonWidth;
  late final double polygonHeight;
  late final List<Vector2> adjustedVertices;

  SnappablePolygon({
    required this.grid,
    required this.vertices,
    required this.polyColor,
    this.scaleWidth = 1,
    this.scaleHeight = 1,
    this.rotation = 0,
    this.isDraggable = true,
  });
  SnappablePolygon copyWith({
    List<Vector2>? vertices,
    Color? polyColor,
    GridComponent? grid,
    double? scaleWidth,
    double? scaleHeight,
    bool? isDraggable,
    double? rotation,
  }) {
    return SnappablePolygon(
      grid: grid ?? this.grid,
      vertices: vertices != null
          ? vertices.map((v) => v.clone()).toList()
          : this.vertices.map((v) => v.clone()).toList(),
      polyColor: polyColor ?? this.polyColor,
      scaleWidth: scaleWidth ?? this.scaleWidth,
      scaleHeight: scaleHeight ?? this.scaleHeight,
      isDraggable: isDraggable ?? this.isDraggable,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  Body createBody() {
    assert(initialPosition != null,
        "initialPosition must be set before adding to the world!");
    final List<Vector2> rotatedVertices = rotateVertices(vertices, rotation);
    final Vector2 topLeft = _getTopLeft(rotatedVertices);
    adjustedVertices = rotatedVertices.map((v) {
      Vector2 shifted = (v - topLeft);
      Vector2 scaled =
          Vector2(shifted.x * scaleWidth, shifted.y * scaleHeight) *
              grid.gridSize.toDouble();

      return scaled;
    }).toList();

    polygonWidth = _getPolygonWidth(adjustedVertices);
    polygonHeight = _getPolygonHeight(adjustedVertices);

    // ✅ Convert initial position from unit space to pixel space
    final Vector2 initialPixelPosition = getClosestGridPoint(
        initialPosition * grid.gridSize.toDouble() + grid.position);

    final bodyDef = BodyDef(
      userData: isDraggable ? this : null,
      position: initialPixelPosition,
      type: BodyType.static,
      gravityScale: Vector2.zero(), // Disable gravity
      fixedRotation: true,
    );

    final shape = PolygonShape()..set(adjustedVertices);
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0 // Set density to 0
      ..restitution = 0.0 // No bounce
      ..friction = 0.0;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  List<Vector2> rotateVertices(List<Vector2> vertices, double angleInDegrees) {
    final double radians = angleInDegrees *
        (3.141592653589793 / 180.0); // Convert degrees to radians
    final double cosA = cos(radians);
    final double sinA = sin(radians);

    return vertices.map((v) {
      return Vector2(
          v.x * cosA - v.y * sinA, // Rotate X
          v.x * sinA + v.y * cosA // Rotate Y
          );
    }).toList();
  }

  bool checkOverlap(SnappablePolygon other) {
    // Get bounding box for this polygon
    Vector2 thisMin = Vector2(
        adjustedVertices.map((v) => v.x + body.position.x).reduce(min),
        adjustedVertices.map((v) => v.y + body.position.y).reduce(min));
    Vector2 thisMax = Vector2(
        adjustedVertices.map((v) => v.x + body.position.x).reduce(max),
        adjustedVertices.map((v) => v.y + body.position.y).reduce(max));

    // Get bounding box for other polygon
    Vector2 otherMin = Vector2(
        other.adjustedVertices
            .map((v) => v.x + other.body.position.x)
            .reduce(min),
        other.adjustedVertices
            .map((v) => v.y + other.body.position.y)
            .reduce(min));
    Vector2 otherMax = Vector2(
        other.adjustedVertices
            .map((v) => v.x + other.body.position.x)
            .reduce(max),
        other.adjustedVertices
            .map((v) => v.y + other.body.position.y)
            .reduce(max));

    // Check for overlap with a small epsilon for grid alignment
    const epsilon = 0.001;
    bool noOverlap = thisMax.x <= otherMin.x + epsilon ||
        thisMin.x >= otherMax.x - epsilon ||
        thisMax.y <= otherMin.y + epsilon ||
        thisMin.y >= otherMax.y - epsilon;

    return !noOverlap;
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!isDraggable) return;
    lastValidPosition = body.position.clone();
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    final Vector2 newPosition = body.position + event.delta;
    final Vector2 clampedPosition = _clampToGrid(newPosition);
    body.setTransform(clampedPosition, body.angle);
  }

  void printPolygonsOnGrid(GridComponent targetGrid) {
    final allPolygons = world.children.whereType<SnappablePolygon>().toList();
    final polygonsOnGrid =
        allPolygons.where((polygon) => polygon.grid == targetGrid).toList();

    print(
        "📌 Found ${polygonsOnGrid.length} SnappablePolygons on the target grid:");
    for (var polygon in polygonsOnGrid) {
      print(polygon.toPrint());
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDraggable) return;

    final Vector2 snappedPosition = getClosestGridPoint(body.position);
    body.setTransform(snappedPosition, body.angle);

    // Check for overlaps with other polygons
    bool hasOverlap = false;
    for (var component in world.children) {
      if (component is SnappablePolygon && component != this) {
        if (checkOverlap(component)) {
          hasOverlap = true;
          break;
        }
      }
    }
    // 🔥 Print all SnappablePolygons
    printPolygonsOnGrid(targetGrid);
    // If there's an overlap, revert to the last valid position
    if (hasOverlap && lastValidPosition != null) {
      body.setTransform(lastValidPosition!, body.angle);
      print("Overlap detected! Reverting to previous position");
    }

    super.onDragEnd(event);
  }

  /// **Ensure the entire polygon stays within grid bounds**
  Vector2 _clampToGrid(Vector2 position) {
    final minX = grid.position.x;
    final maxX = grid.position.x + grid.gridSize * grid.cols - polygonWidth;

    final minY = grid.position.y;
    final maxY = grid.position.y + grid.gridSize * grid.rows - polygonHeight;

    return Vector2(
      position.x.clamp(minX, maxX),
      position.y.clamp(minY, maxY),
    );
  }

  /// **Finds the top-left vertex in a given set of vertices**
  Vector2 _getTopLeft(List<Vector2> vertices) {
    double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
    double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
    return Vector2(minX, minY);
  }

  /// **Calculate polygon width from its vertices**
  double _getPolygonWidth(List<Vector2> vertices) {
    double minX = vertices.map((v) => v.x).reduce((a, b) => a < b ? a : b);
    double maxX = vertices.map((v) => v.x).reduce((a, b) => a > b ? a : b);
    return maxX - minX;
  }

  /// **Calculate polygon height from its vertices**
  double _getPolygonHeight(List<Vector2> vertices) {
    double minY = vertices.map((v) => v.y).reduce((a, b) => a < b ? a : b);
    double maxY = vertices.map((v) => v.y).reduce((a, b) => a > b ? a : b);
    return maxY - minY;
  }

  /// **Snap the polygon's top-left vertex to the closest grid point**
  Vector2 getClosestGridPoint(Vector2 position) {
    double x = ((position.x - grid.position.x) / grid.gridSize).round() *
            grid.gridSize +
        grid.position.x;
    double y = ((position.y - grid.position.y) / grid.gridSize).round() *
            grid.gridSize +
        grid.position.y;
    return Vector2(x, y);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = polyColor;

    final path = Path()
      ..moveTo(adjustedVertices.first.x, adjustedVertices.first.y);
    for (var vertex in adjustedVertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  String toPrint() {
    final r = (polyColor.value >> 16) & 0xFF;
    final g = (polyColor.value >> 8) & 0xFF;
    final b = polyColor.value & 0xFF;
    return "Polygon at grid position: (${((body.position.x - grid.position.x) / grid.gridSize).round()}, ${((body.position.y - grid.position.y) / grid.gridSize).round()})"
        "\n  - Color: RGB($r, $g, $b)"
        "\n  - Scale: (Width: $scaleWidth, Height: $scaleHeight)"
        "\n  - Rotation: $rotation degrees";
  }
}
