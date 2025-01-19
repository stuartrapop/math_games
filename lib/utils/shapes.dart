import 'package:first_math/utils/create_shapes.dart';
import 'package:geobase/geobase.dart';

PositionSeries triangle = regularPolygon(sides: 3);
PositionSeries square = regularPolygon(sides: 4);
PositionSeries pentagon = regularPolygon(sides: 5);
PositionSeries hexagon = regularPolygon(sides: 6);
PositionSeries heptagon = regularPolygon(sides: 7);
PositionSeries octogon = regularPolygon(sides: 8);
PositionSeries polygon9 = regularPolygon(sides: 9);
PositionSeries polygon10 = regularPolygon(sides: 10);

final polygonShapes = {
  3: triangle,
  4: square,
  5: pentagon,
  6: hexagon,
  7: heptagon,
  8: octogon,
  9: polygon9,
  10: polygon10,
  'lShape': lShape,
  'asteroid': asteroid,
};

final PositionSeries lShape = PositionSeries.from([
  Position.create(x: 0, y: 0),
  Position.create(x: 10, y: 0),
  Position.create(x: 10, y: 20),
  Position.create(x: 20, y: 20),
  Position.create(x: 20, y: 30),
  Position.create(x: 0, y: 30),
]);

final PositionSeries asteroid = PositionSeries.from([
  Position.create(x: 0, y: 0),
  Position.create(x: -5, y: -10),
  Position.create(x: 0, y: -20),
  Position.create(x: 10, y: -28),
  Position.create(x: 20, y: -30),
  Position.create(x: 30, y: -20),
  Position.create(x: 20, y: -15),
  Position.create(x: 25, y: 0),
  Position.create(x: 7, y: 5),
]);
