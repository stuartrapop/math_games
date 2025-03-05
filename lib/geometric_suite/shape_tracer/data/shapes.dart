import 'package:first_math/geometric_suite/common/components/polygon_factory_function.dart';
import 'package:first_math/geometric_suite/common/types/shapes.dart';
import 'package:first_math/geometric_suite/shape_tracer/components/tracable_polygon.dart';

TracablePolygon square =
    createPolygon<TracablePolygon>(vertices: squareVertices);
TracablePolygon octogon =
    createPolygon<TracablePolygon>(vertices: octogonalVertices);
TracablePolygon hexagon =
    createPolygon<TracablePolygon>(vertices: hexagonalVertices);
TracablePolygon polygon5 =
    createPolygon<TracablePolygon>(vertices: polygon5Vertices);
TracablePolygon triangle =
    createPolygon<TracablePolygon>(vertices: triangleVertices);
TracablePolygon parallagram =
    createPolygon<TracablePolygon>(vertices: parallagramVertices);
TracablePolygon lShape =
    createPolygon<TracablePolygon>(vertices: lShapeVertices);
