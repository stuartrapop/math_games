import 'package:first_math/geometric_suite/common/components/polygon_factory_function.dart';
import 'package:first_math/geometric_suite/common/types/shapes.dart';
import 'package:first_math/geometric_suite/match_polygon/components/clickable_polygon.dart';

ClickablePolygon square =
    createPolygon<ClickablePolygon>(vertices: squareVertices);
ClickablePolygon octogon =
    createPolygon<ClickablePolygon>(vertices: octogonalVertices);
ClickablePolygon hexagon =
    createPolygon<ClickablePolygon>(vertices: hexagonalVertices);
ClickablePolygon polygon5 =
    createPolygon<ClickablePolygon>(vertices: polygon5Vertices);
ClickablePolygon triangle =
    createPolygon<ClickablePolygon>(vertices: triangleVertices);
ClickablePolygon parallagram =
    createPolygon<ClickablePolygon>(vertices: parallagramVertices);
ClickablePolygon lShape =
    createPolygon<ClickablePolygon>(vertices: lShapeVertices);
