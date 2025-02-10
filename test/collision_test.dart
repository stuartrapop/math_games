// Import the test package and Counter class

import 'package:first_math/suite/check_collision_polygon.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('polygon tests', () {
    final obj1 = PolygonObject(
        [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]);

    final obj2 = PolygonObject(
        [Vector2(1, 0), Vector2(2, 0), Vector2(2, 1), Vector2(1, 1)]);
    final obj3 = PolygonObject(
        [Vector2(1.5, 0), Vector2(2.5, 0), Vector2(2, 1), Vector2(2.5, 1)]);
    final obj4 = PolygonObject([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)]);
    final obj5 = PolygonObject([Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)]);
    test('\npolygon collision tests1', () {
      expect(isCollidingPolygonPolygon(obj1, obj2), false);
    });
    test('\npolygon collision tests2', () {
      expect(isCollidingPolygonPolygon(obj2, obj3), true);
    });
    test('\npolygon collision tests3', () {
      expect(isCollidingPolygonPolygon(obj4, obj5), false);
    });
  });
}
