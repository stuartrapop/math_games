import 'dart:async';

import 'package:first_math/geometric_suite/common/components/BasePolygon.dart';
import 'package:first_math/geometric_suite/common/components/frame/grid_component.dart';
import 'package:first_math/geometric_suite/suite/bloc/suite_bloc.dart';
import 'package:first_math/geometric_suite/suite/components/interface_snappable_shape.dart';
import 'package:first_math/geometric_suite/suite/suite_game.dart';
import 'package:first_math/geometric_suite/suite/utils/check_collision_polygon.dart';
import 'package:first_math/geometric_suite/suite/utils/helpers.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SnappablePolygon extends BasePolygon
    with HasGameRef<SuiteGame>, DragCallbacks
    implements InterfaceSnappableShape {
  @override
  double radius = 1.0;
  @override
  GridComponent grid;
  int questionIndex;
  bool isDraggable;
  Vector2? lastValidPosition;

  @override
  int polygonIndex;
  @override
  Function? updateActivePolygonIndex;

  SnappablePolygon({
    required super.vertices,
    required this.grid,
    this.isDraggable = true,
    this.questionIndex = -1,
    this.polygonIndex = -1,
    super.innerVertices,
    super.flipHorizontal,
    super.flipVertical,
    super.upperLeftPosition, //
  }) : super(
          pixelToUnitRatio: grid.gridSize.toDouble(),
        );

  @override
  SnappablePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    Color? color,
    GridComponent? grid,
    double? scaleWidth,
    double? scaleHeight,
    bool? isDraggable,
    double? rotation,
    int? questionIndex,
    int? polygonIndex,
    Vector2? position,
    Vector2? size,
    bool? flipHorizontal,
    bool? flipVertical,
    Vector2? upperLeftPosition,
    double? pixelToUnitRatio,
    double? borderWidth,
    Function? updateActivePolygonIndex,
    double? holeRadius,
  }) {
    // ✅ Ensure we have a valid grid reference
    double newPixelToUnitRatio =
        pixelToUnitRatio ?? grid?.gridSize.toDouble() ?? this.pixelToUnitRatio;

    // ✅ Update the position using the new grid size
    Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();
    Vector2 updatedPosition = newUpperLeftPosition * newPixelToUnitRatio;
    SnappablePolygon copiedPolygon = SnappablePolygon(
      vertices: vertices ?? this.vertices.map((v) => v.clone()).toList(),
      innerVertices:
          innerVertices ?? this.innerVertices.map((v) => v.clone()).toList(),
      grid: grid ?? this.grid,
      questionIndex: questionIndex ?? this.questionIndex,
      polygonIndex: polygonIndex ?? this.polygonIndex,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
      upperLeftPosition: newUpperLeftPosition,
      isDraggable: isDraggable ?? this.isDraggable,
    )
      ..position = updatedPosition
      ..color = color ?? this.color
      ..scaleHeight = scaleHeight ?? this.scaleHeight
      ..scaleWidth = scaleWidth ?? this.scaleWidth
      ..rotation = rotation ?? this.rotation
      ..pixelToUnitRatio = newPixelToUnitRatio;

    copiedPolygon.initializeAdjustedVertices();

    return copiedPolygon;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = false;
    position = (upperLeftPosition ?? Vector2.zero()) * grid.gridSize.toDouble();
  }

  List<double> convertVector2ToDoubles(List<Vector2> vectors) {
    return vectors.expand((v) => [v.x, v.y]).toList();
  }

  Future<void> demoClick() async {
    print("Demo Click");
  }

  void toggleColor() {
    print("Toggle Color");
  }

  void resetColor() {
    print("Reset Color");
  }

  Future<void> demoMoveTo({required Vector2 gridPoint}) async {
    GridComponent answerGrid = gameRef.suiteWorld.answerGrid;

    // Find the corresponding polygon in the answer grid
    SnappablePolygon correspondingPolygon =
        answerGrid.children.whereType<SnappablePolygon>().toList().firstWhere(
              (element) =>
                  element.questionIndex == questionIndex &&
                  element.polygonIndex == polygonIndex,
              orElse: () => this,
            );
    print(
        "gridPoint: $gridPoint, ccurrent position: ${position / grid.gridSize.toDouble()}");
    if (gridPoint == (position / grid.gridSize.toDouble())) {
      return;
    }

    correspondingPolygon.blink(); // 🔥 Highlight before moving

    Vector2 currentGridPosition = position / grid.gridSize.toDouble();
    print("Current Grid Position: $currentGridPosition, Target: $gridPoint");

    // Calculate movement offset
    Vector2 movementOffset =
        (gridPoint - currentGridPosition) * grid.gridSize.toDouble();
    double duration = (100 + movementOffset.length) / (5.0 * grid.gridSize);

    Completer<void> completer = Completer<void>();
    priority = 10;

    final effect = SequenceEffect(
      [
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(duration: 0.3, alternate: true),
        ),
        MoveEffect.by(
          movementOffset,
          EffectController(duration: duration, alternate: true),
        ),
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(duration: 0.3, alternate: true),
        ),
      ],
      onComplete: () {
        priority = 1; // ✅ Reset priority after movement completes
        completer.complete();
      },
    );

    Future.delayed(Duration.zero, () {
      add(effect);
    });

    await completer.future;
  }

  void blink() {
    priority = 10;
    const scale = 0.2;

    final moveEffect = SequenceEffect(
      [
        MoveEffect.by(
          Vector2(-topLeft.x, -topLeft.y) * scale,
          EffectController(duration: 0.3, alternate: true, repeatCount: 5),
        ),
      ],
    );

    add(moveEffect);

    final scaleEffect = SequenceEffect(
      [
        ScaleEffect.by(
          Vector2.all(1 + scale),
          EffectController(duration: 0.3, alternate: true, repeatCount: 5),
        ),
      ],
      onComplete: () => priority = 1,
    );

    Future.delayed(Duration.zero, () {
      add(scaleEffect);
    });
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!isDraggable) return;
    priority = 10;
    lastValidPosition = position.clone();
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    final Vector2 newPosition = position + event.delta;
    position = newPosition;
    position = clampToGrid(
      position: newPosition, grid: grid, polygonWidth: size.x, // ✅ Add width
      polygonHeight: size.y,
    );
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDraggable) return;
    priority = 1;
    final Vector2 snappedPosition =
        getClosestGridPoint(position: position, grid: grid);
    position = snappedPosition;

    bool hasOverlap = false;
    for (var component in grid.children) {
      if (component is InterfaceSnappableShape && component != this) {
        if (checkOverlap(component, this)) {
          hasOverlap = true;
          break;
        }
      }
    }

    if (hasOverlap && lastValidPosition != null) {
      position = lastValidPosition!;
    }
    gameRef.suiteBloc.add(PolygonMoved(
      questionIndex: questionIndex,
      polygonIndex: polygonIndex,
      newPosition: (position) / grid.gridSize.toDouble(),
    ));

    super.onDragEnd(event);
  }
}
