import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/suite/components/snappable_polygon.dart';
import 'package:flame/components.dart';

void printPolygonsOnGrid(GridComponent targetGrid) {
  final allPolygons =
      targetGrid.children.whereType<SnappablePolygon>().toList();
  final polygonsOnGrid =
      allPolygons.where((polygon) => polygon.grid == targetGrid).toList();
  print(
      "📌 Found ${polygonsOnGrid.length} SnappablePolygons on the target grid:");
  List<Vector2> positions = polygonsOnGrid
      .map((p) => p.position / targetGrid.gridSize.toDouble())
      .toList();
  print(
      "Positions:[${positions.map((v) => 'V(${v.x.toInt()}, ${v.y.toInt()})').join(', ')}]");
}

List<SnappablePolygon> getPolygonsOnGrid(
    GridComponent targetGrid, World world) {
  final allPolygons = world.children.whereType<SnappablePolygon>().toList();
  return allPolygons.where((polygon) => polygon.grid == targetGrid).toList();
}

List<Vector2> getShiftedPositions({required List<Vector2> positions}) {
  if (positions.isEmpty) return [];
  print("Positions: $positions");

  double minX = positions.map((p) => p.x).reduce((a, b) => a < b ? a : b);
  double minY = positions.map((p) => (p.y)).reduce((a, b) => a < b ? a : b);

  print("MinX: $minX, MinY: $minY");

  return positions.map((p) => p - (Vector2(minX, minY))).toList();
}

bool validatePolygonCount(
    List<SnappablePolygon> question, List<SnappablePolygon> answer) {
  return question.length == answer.length;
}
