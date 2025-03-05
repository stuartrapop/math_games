import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/suite/components/interface_snappable_shape.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_circle.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon_with_circular_hole.dart';
import 'package:first_math/geometric_suite/suite/data/questions.dart';

GridComponent tempGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = V(250, 100);

InterfaceSnappableShape square = SnappablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
    V(0, 1)
  ],
  grid: tempGrid,
);

InterfaceSnappableShape octogon = SnappablePolygon(
  vertices: [
    V(1, 0),
    V(2, 0),
    V(3, 1),
    V(3, 2),
    V(2, 3),
    V(1, 3),
    V(0, 2),
    V(0, 1)
  ],
  grid: tempGrid,
);
InterfaceSnappableShape pentagon = SnappablePolygon(
  vertices: [
    V(2, 0.5),
    V(4, 2),
    V(3, 4),
    V(1, 4),
    V(0, 2),
  ],
  grid: tempGrid,
);
InterfaceSnappableShape hexagon = SnappablePolygon(
  vertices: [
    V(1, 0),
    V(2, 0),
    V(3, 1),
    V(2, 2),
    V(1, 2),
    V(0, 1),
  ],
  grid: tempGrid,
);
InterfaceSnappableShape polygon5 = SnappablePolygon(
  vertices: [
    V(1, 0),
    V(2, 0),
    V(2, 1),
    V(2, 2),
    V(1, 2),
    V(0, 1),
  ],
  grid: tempGrid,
);

InterfaceSnappableShape triangle = SnappablePolygon(
  // Initial top-left position
  vertices: [
    V(0, 1), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
  ],
  grid: tempGrid,
);
InterfaceSnappableShape yellowParralelogram = SnappablePolygon(
  vertices: [
    V(1, 0), // Top-left (snap reference)
    V(4, 0),
    V(3, 2),
    V(0, 2)
  ],
  grid: tempGrid,
);
InterfaceSnappableShape lShape = SnappablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(3, 0),
    V(3, 1),
    V(1, 1),
    V(1, 2),
    V(0, 2)
  ],
  grid: tempGrid,
);
InterfaceSnappableShape circle = SnappableCircle(
  grid: tempGrid,
);

InterfaceSnappableShape polygonWithHole = SnappablePolygon(
  vertices: [V(0, 0), V(20, 0), V(20, 20), V(0, 20)],
  innerVertices: [V(5, 5), V(15, 5), V(15, 15), V(5, 15)],
  grid: tempGrid,
);
InterfaceSnappableShape polygonWithLShapeHole = SnappablePolygon(
  vertices: [V(0, 0), V(4, 0), V(4, 5), V(0, 5)],
  innerVertices: [V(1, 1), V(2, 1), V(2, 3), V(3, 3), V(3, 4), V(1, 4)],
  grid: tempGrid,
);

InterfaceSnappableShape polygonWithCircularHole =
    SnappablePolygonWithCircularHole(
  vertices: [V(0, 0), V(6, 0), V(6, 6), V(0, 6)],
  holeRadius: 2,
  grid: tempGrid,
);
