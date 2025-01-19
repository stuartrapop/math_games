import 'dart:async';
import 'dart:ui' as ui; // Use dart:ui for Image;

import 'package:collection/collection.dart';
import 'package:first_math/multi-cuisenaire/bloc/cuisenaire_bloc.dart';
import 'package:first_math/multi-cuisenaire/board.dart';
import 'package:first_math/multi-cuisenaire/cell.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class Reglette extends PositionComponent
    with
        DragCallbacks,
        TapCallbacks,
        HasGameRef,
        FlameBlocReader<CuisenaireBloc, CuisenaireState> {
  int value;
  late Paint paint;
  late Paint outlinePaint;
  late Vector2 initialPosition;
  late Vector2 initialVerticalPosition;
  bool isHorizontal; // Tr
  int startRow;
  int startColumn;
  DateTime? _lastTapTime; // Track the last tap timestamp
  bool _isDraggedFromBoard = false;

  Reglette({
    required this.startRow,
    required this.startColumn,
    required this.value,
    required this.isHorizontal,
  }) {
    debugMode = false;
    debugColor = const Color.fromARGB(255, 48, 42, 42);
    priority = 20;
    initialVerticalPosition = Vector2(35.0 * value + 93, 50);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    outlinePaint = Paint()
      ..color = const ui.Color.fromARGB(255, 44, 41, 41) // Black outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    initialPosition = position.clone();
    paint = Paint()..color = regletteColors[value - 1];

    // Optionally add a visual indicator or hitbox
    final hitbox = RectangleHitbox()
      ..size = size
      ..position = Vector2(
        (size.x - 15) / 2, // Centered horizontally
        (size.y - 15) / 2, // Centered vertically
      )
      // ..position = Vector2.zero()
      ..anchor = Anchor.topLeft
      ..collisionType = CollisionType.passive
      ..priority = 100;
    add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (parent is Board) {
      outlinePaint.strokeWidth = 2.0;
    } else {
      outlinePaint.strokeWidth = 0.5;
    }
    super.update(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    // Remove the reglette from the board if it's currently a child of the board
    bool isLeft = true;
    if (parent is Board) {
      final board = parent as Board;
      _isDraggedFromBoard = true;
      print("parent ${(parent as Board).isLeft}");
      if (parent != null) {
        isLeft = (parent as Board).isLeft;
        (parent as Board).remove(this);
      }
      print("board position: ${board.position}");
      parent!.parent!.add(
        this
          ..position = Vector2(board.position.x + startColumn * 35,
              board.position.y + startRow * 35),
      );
      print("this ${this.toString()}");
      if (startColumn != -1 && startRow != -1) {
        final reglette = RegletteBlock(
          value: value,
          startRow: startRow,
          startColumn: startColumn,
          isHorizontal: isHorizontal,
        );
        bloc.add(RemoveRegletteEvent(reglette: reglette, isLeft: isLeft));
      }
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.delta;
    // print("position $position");
    final regletteHitbox = children.whereType<RectangleHitbox>().firstOrNull;
    if (regletteHitbox != null) {
      final hitboxBounds = Rect.fromLTWH(
        regletteHitbox.position.x,
        regletteHitbox.position.y,
        regletteHitbox.size.x,
        regletteHitbox.size.y,
      );

      // print("hitboxBounds $hitboxBounds");
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    // Find all boards in the parent
    final boards = parent!.children.whereType<Board>().toList();
    for (final board in boards) {
      print(
          "Board position: ${board.position}, size: ${board.size}, isLeft: ${board.isLeft}");
    }
    if (boards.isEmpty) {
      print('No boards found directly attached to parent.');
      return;
    }

    for (final board in boards) {
      // Check for overlap with cells inside the board
      final regletteHitbox = children.whereType<RectangleHitbox>().firstOrNull;
      if (regletteHitbox == null) continue;
      final overlappingCells = board.children.whereType<Cell>().where((cell) {
        final cellAbsolutePosition = board.position + cell.position;
        final regletteAbsolutePosition = position + regletteHitbox.position;

        // Create rectangles for overlap testing
        final cellRect = Rect.fromLTWH(cellAbsolutePosition.x,
            cellAbsolutePosition.y, cell.size.x, cell.size.y);

        final regletteRect = Rect.fromLTWH(
            regletteAbsolutePosition.x,
            regletteAbsolutePosition.y,
            regletteHitbox.size.x,
            regletteHitbox.size.y);

        return cellRect.overlaps(regletteRect);
      }).toList();
      print("overlappingCells $parent ${overlappingCells.length}");
      if (overlappingCells.isNotEmpty) {
        // Find the cell with the lowest column value
        int startColumn = 0;
        if (isHorizontal) {
          final targetCell =
              overlappingCells.reduce((a, b) => a.column < b.column ? a : b);
          startColumn =
              targetCell.column + value > 10 ? 10 - value : targetCell.column;
          startRow = targetCell.row;
        } else {
          final targetCell =
              overlappingCells.reduce((a, b) => a.row < b.row ? a : b);
          startRow = targetCell.row + value > 10 ? 10 - value : targetCell.row;
          startColumn = targetCell.column;
        }
        final reglette = RegletteBlock(
          value: value,
          startRow: startRow,
          startColumn: startColumn,
          isHorizontal: isHorizontal,
        );
        print("before add reglette ${reglette.toString()}");
        bloc.add(AddRegletteEvent(reglette: reglette, isLeft: board.isLeft));
      }
      // Determine the cells the Reglette would occupy
      if (_isDraggedFromBoard) {
        if (parent != null) {
          // Remove Reglette from its current parent
          removeFromParent();
        }
      }
    }
    add(
      MoveEffect.to(
        isHorizontal ? initialPosition : initialVerticalPosition,
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (parent is Board) {
      print("parent is board cannot rotate");
      return;
    }
    final currentTime = DateTime.now();

    if (_lastTapTime != null &&
        currentTime.difference(_lastTapTime!).inMilliseconds < 300) {
      // Double-tap detected
      _toggleOrientation();
    }

    _lastTapTime = currentTime;
  }

  void _toggleOrientation() {
    // Toggle orientation
    isHorizontal = !isHorizontal;

    final newSize = Vector2(size.y, size.x);

    size = newSize;

    // Reposition the Reglette to align correctly
    anchor = isHorizontal ? Anchor.topLeft : Anchor.topLeft;
    priority = isHorizontal ? 20 : 40;
    position = isHorizontal ? initialPosition : Vector2(35.0 * value + 93, 50);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
    // Adjust thickness of the outline

    // Draw the outline
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      outlinePaint,
    );

    super.render(canvas);
  }
}
