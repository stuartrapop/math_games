// Import the test package and Counter class

import 'package:first_math/suite/utils/check_collision_polygon.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('polygon tests', () {
    var outerPolygon = [
      Vector2(0, 0),
      Vector2(20, 0),
      Vector2(20, 20),
      Vector2(0, 20)
    ];
    var holes = [
      [Vector2(5, 5), Vector2(15, 5), Vector2(15, 15), Vector2(5, 15)]
    ];

// Expected: 6 triangles
// Triangles should cover the outer polygon while avoiding the hole

    final triangles =
        triangulatePolygonWithHoles(outerPolygon: outerPolygon, holes: holes);
    print("Triangles in test $triangles");
    test('\npolygon collision tests1', () {
      // expect(isCollidingPolygonPolygon(obj1, obj2), false);
    });
    test('\npolygon collision tests2', () {
      // expect(isCollidingPolygonPolygon(obj2, obj3), true);
    });
    test('\npolygon collision tests3', () {
      // expect(isCollidingPolygonPolygon(obj4, obj5), false);
    });
  });
}
