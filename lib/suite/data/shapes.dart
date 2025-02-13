import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:first_math/suite/data/questions.dart';

GridComponent tempGrid = GridComponent(
  gridSize: 35,
  rows: 8,
  cols: 14,
  lineWidth: 2,
)..position = V(250, 100);

// GridComponent questionGrid = GridComponent(
//   gridSize: 35,
//   rows: 8,
//   cols: 14,
//   lineWidth: 2,
// )..position = V(250, 400);

SnappablePolygon square = SnappablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
    V(0, 1)
  ],
  grid: tempGrid,
);

SnappablePolygon octogon = SnappablePolygon(
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
SnappablePolygon hexagon = SnappablePolygon(
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
SnappablePolygon polygon5 = SnappablePolygon(
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

SnappablePolygon triangle = SnappablePolygon(
  // Initial top-left position
  vertices: [
    V(0, 1), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
  ],
  grid: tempGrid,
);
SnappablePolygon yellowParralelogram = SnappablePolygon(
  vertices: [
    V(1, 0), // Top-left (snap reference)
    V(4, 0),
    V(3, 2),
    V(0, 2)
  ],
  grid: tempGrid,
);
SnappablePolygon lShape = SnappablePolygon(
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

SnappablePolygon polygonWithHole = SnappablePolygon(
  vertices: [V(0, 0), V(20, 0), V(20, 20), V(0, 20)],
  innerVertices: [V(5, 5), V(15, 5), V(15, 15), V(5, 15)],
  grid: tempGrid,
);
