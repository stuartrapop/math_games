import 'dart:async';

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

class SnappableCircle extends CircleComponent
    with HasGameRef<SuiteGame>, DragCallbacks
    implements InterfaceSnappableShape {
  final bool isDraggable;
  Vector2? lastValidPosition;
  @override
  double scaleWidth = 1.0;

  @override
  double scaleHeight = 1.0;

  @override
  double rotation = 0.0;

  @override
  bool flipVertical = false;

  @override
  bool flipHorizontal = false;
  @override
  int polygonIndex;
  @override
  Function? updateActivePolygonIndex;

  double pixelToUnitRatio;
  Vector2? upperLeftPosition;

  late final Paint borderPaint;
  Color color;

  GridComponent _grid; // ✅ Use a private variable

  @override
  GridComponent get grid => _grid; // ✅ Getter returns the private variable

  @override
  set grid(GridComponent value) {
    _grid = value; // ✅ Set the private variable, avoiding infinite recursion
  }

  int questionIndex;
  SnappableCircle({
    required GridComponent grid,
    this.isDraggable = true,
    this.questionIndex = -1,
    this.polygonIndex = -1,
    this.pixelToUnitRatio = 50,
    this.upperLeftPosition,
    this.color = Colors.white,
    Color borderColor = Colors.white54,
    double borderWidth = 4,
    double radius = 2,
  })  : _grid = grid,
        super(
          radius: radius * grid.gridSize.toDouble(),
        ) {
    borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
  }

  @override
  SnappableCircle copyWith({
    Vector2? upperLeftPosition,
    Function? updateActivePolygonIndex,
    double? pixelToUnitRatio,
    Color? color,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    bool? flipVertical,
    bool? flipHorizontal,
    int? questionIndex,
    int? polygonIndex,
    bool? isDraggable,
    GridComponent? grid,
  }) {
    final double newPixelToUnitRatio =
        pixelToUnitRatio ?? this.pixelToUnitRatio;

    final Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();

    final Vector2 updatedPosition = newUpperLeftPosition * newPixelToUnitRatio;

    SnappableCircle circle = SnappableCircle(
      grid: grid ?? this.grid,
      polygonIndex: polygonIndex ?? this.polygonIndex,
      questionIndex: questionIndex ?? this.questionIndex,
      color: color ?? this.color, // ✅ Correctly update color
      borderColor: borderColor ?? borderPaint.color,
      borderWidth: borderWidth ?? borderPaint.strokeWidth,
      radius: radius ?? this.radius,
      pixelToUnitRatio: newPixelToUnitRatio,
      upperLeftPosition: newUpperLeftPosition,
      isDraggable: isDraggable ?? this.isDraggable,
    )..position = updatedPosition;

    // ✅ Set the correct paint color after creation
    circle.paint.color = color ?? this.color;

    return circle;
  }

  @override
  Future<void> onLoad() async {
    position = (upperLeftPosition ?? Vector2.zero()) * grid.gridSize.toDouble();
    debugMode = false;
    paint.color = color;
    return super.onLoad();
  }

  Future<void> demoMoveTo({required Vector2 gridPoint}) async {
    GridComponent answerGrid = gameRef.suiteWorld.answerGrid;

    SnappableCircle correspondingCircle =
        answerGrid.children.whereType<SnappableCircle>().toList().firstWhere(
              (element) => element.polygonIndex == polygonIndex,
              orElse: () => this,
            );

    print(
        "gridPoint: $gridPoint, current position: ${position / grid.gridSize.toDouble()}");
    if (gridPoint == (position / grid.gridSize.toDouble())) {
      return;
    }

    correspondingCircle.blink();

    Vector2 currentGridPosition = position / grid.gridSize.toDouble();
    print("Current Grid Position: $currentGridPosition, Target: $gridPoint");

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
        priority = 1;
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
      position: newPosition,
      grid: grid,
      polygonWidth: size.x,
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
    print("Snapped Position: $snappedPosition");

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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(radius, radius), radius, borderPaint);
  }
}
