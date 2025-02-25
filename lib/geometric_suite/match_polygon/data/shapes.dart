import 'package:first_math/geometric_suite/match_polygon/components/clickable_polygon.dart';
import 'package:flame/components.dart';

typedef V = Vector2;
ClickablePolygon square = ClickablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
    V(0, 1)
  ],
);

ClickablePolygon octogon = ClickablePolygon(
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
);
ClickablePolygon hexagon = ClickablePolygon(
  vertices: [
    V(1, 0),
    V(2, 0),
    V(3, 1),
    V(2, 2),
    V(1, 2),
    V(0, 1),
  ],
);
ClickablePolygon polygon5 = ClickablePolygon(
  vertices: [
    V(1, 0),
    V(2, 0),
    V(2, 1),
    V(2, 2),
    V(1, 2),
    V(0, 1),
  ],
);

ClickablePolygon triangle = ClickablePolygon(
  // Initial top-left position
  vertices: [
    V(0, 1), // Top-left (snap reference)
    V(1, 0),
    V(1, 1),
  ],
);
ClickablePolygon yellowParralelogram = ClickablePolygon(
  vertices: [
    V(1, 0), // Top-left (snap reference)
    V(4, 0),
    V(3, 2),
    V(0, 2)
  ],
);
ClickablePolygon lShape = ClickablePolygon(
  vertices: [
    V(0, 0), // Top-left (snap reference)
    V(3, 0),
    V(3, 1),
    V(1, 1),
    V(1, 2),
    V(0, 2)
  ],
);
