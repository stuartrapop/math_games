import 'package:first_math/suite/components/grid_component.dart';
import 'package:first_math/suite/components/snappable_polygon.dart';
import 'package:flame/components.dart';

void printPolygonsOnGrid(GridComponent targetGrid, World world) {
  final allPolygons = world.children.whereType<SnappablePolygon>().toList();
  final polygonsOnGrid =
      allPolygons.where((polygon) => polygon.grid == targetGrid).toList();

  print(
      "📌 Found ${polygonsOnGrid.length} SnappablePolygons on the target grid:");
  for (var polygon in polygonsOnGrid) {
    print(polygon.toPrint());
  }
}

List<SnappablePolygon> getPolygonsOnGrid(
    GridComponent targetGrid, World world) {
  final allPolygons = world.children.whereType<SnappablePolygon>().toList();
  return allPolygons.where((polygon) => polygon.grid == targetGrid).toList();
}

List<Vector2> getShiftedPositions(
    {required List<SnappablePolygon> polygons, required GridComponent grid}) {
  if (polygons.isEmpty) return [];
  polygons.forEach((p) => print(
      "Initial position: ${(p.position - grid.position) / grid.gridSize.toDouble()}"));

  double minX = polygons
      .map((p) => (p.position.x - grid.position.x) / grid.gridSize.toDouble())
      .reduce((a, b) => a < b ? a : b);
  double minY = polygons
      .map((p) => (p.position.y - grid.position.y) / grid.gridSize.toDouble())
      .reduce((a, b) => a < b ? a : b);

  print("MinX: $minX, MinY: $minY");

  return polygons
      .map((p) =>
          p.position -
          grid.position -
          (Vector2(minX, minY) * grid.gridSize.toDouble()))
      .toList();
}

bool validatePolygonCount(
    List<SnappablePolygon> question, List<SnappablePolygon> answer) {
  return question.length == answer.length;
}

bool comparePolygons(
    {required List<SnappablePolygon> questions,
    required GridComponent questionGrid,
    required List<SnappablePolygon> answers,
    required GridComponent answerGrid}) {
  List<Vector2> questionPositions =
      getShiftedPositions(polygons: questions, grid: questionGrid);
  List<Vector2> answerPositions =
      getShiftedPositions(polygons: answers, grid: answerGrid);
  print("Question positions: $questionPositions");
  print("Answer positions: $answerPositions");

  // Sort both lists by position for easier comparison
  questionPositions.sort((a, b) => a.x.compareTo(b.x));
  answerPositions.sort((a, b) => a.x.compareTo(b.x));

  for (int i = 0; i < questions.length; i++) {
    SnappablePolygon q = questions[i];
    SnappablePolygon a = answers[i];

    if (q.color != a.color ||
        q.scaleWidth != a.scaleWidth ||
        q.scaleHeight != a.scaleHeight ||
        q.rotation != a.rotation ||
        questionPositions[i] != answerPositions[i]) {
      return false;
    }
  }
  return true;
}
