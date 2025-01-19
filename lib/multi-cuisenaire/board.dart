import 'dart:async';

import 'package:first_math/multi-cuisenaire/bloc/cuisenaire_bloc.dart';
import 'package:first_math/multi-cuisenaire/cell.dart';
import 'package:first_math/multi-cuisenaire/reglette.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class Board extends PositionComponent
    with FlameBlocListenable<CuisenaireBloc, CuisenaireState> {
  late List<int> rowCounts;
  late List<int> columnCounts;
  final int rows = 10;
  final int columns = 10;
  int leftPadding = 5;
  int topPadding = 5;
  bool isLeft;

  Board({required this.isLeft}) {
    rowCounts = List.filled(rows, 0);
    columnCounts = List.filled(columns, 0);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    priority = 1;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        final Cell square = Cell(radius: 4, row: i, column: j)
          ..size = Vector2(34, 34)
          ..position = Vector2(j * 35.0 + leftPadding, i * 35.0 + topPadding)
          ..anchor = Anchor.topLeft;
        add(square);
      }
      _updateCounts([]);
    }
  }

  @override
  void onNewState(CuisenaireState state) {
    // Handle state updates from the bloc
    updateReglettes(isLeft ? state.leftBoard : state.rightBoard);
    _updateCounts(isLeft ? state.leftBoard : state.rightBoard);
  }

  void updateReglettes(List<RegletteBlock> reglettes) {
    // Remove any previously displayed reglettes
    children.whereType<Reglette>().forEach(remove);

    // Add the new reglettes to the board
    for (final regletteBlock in reglettes) {
      _addRegletteToBoard(regletteBlock);
    }
  }

  void _addRegletteToBoard(RegletteBlock regletteBlock) {
    final position = Vector2(
      regletteBlock.startColumn * 35.0 + leftPadding, // Adjust with padding
      regletteBlock.startRow * 35.0 + topPadding, // Adjust with padding
    );

    final size = Vector2(
      (regletteBlock.isHorizontal ? regletteBlock.value : 1) *
          35, // Width based on `length`
      (regletteBlock.isHorizontal ? 1 : regletteBlock.value) *
          35.0, // Height based on `height`
    );

    final reglette = Reglette(
      value: regletteBlock.value,
      startRow: regletteBlock.startRow,
      startColumn: regletteBlock.startColumn,
      isHorizontal: regletteBlock.isHorizontal,
    )
      ..position = position
      ..size = size
      ..priority = 70;

    add(reglette);
  }

  void _updateCounts(List<RegletteBlock> reglettes) {
    // Reset counts
    rowCounts.fillRange(0, rowCounts.length, 0);
    columnCounts.fillRange(0, columnCounts.length, 0);
    int totalCount = 0;

    // Count occupied cells
    for (final reglette in reglettes) {
      int length = reglette.isHorizontal ? reglette.value : 1;
      int height = reglette.isHorizontal ? 1 : reglette.value;
      totalCount += reglette.value;
      for (int i = 0; i < height; i++) {
        rowCounts[reglette.startRow + i] += length;
      }
      for (int j = 0; j < length; j++) {
        columnCounts[reglette.startColumn + j] += height;
      }
    }

    // Remove all existing row and column counters
    children.whereType<TextComponent>().toList().forEach(remove);
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF000000),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    final totalText = TextComponent(
      text: "Total: $totalCount",
      position: Vector2(10, -20), // Adjust position for alignment
      anchor: Anchor.centerLeft,
      textRenderer: textPaint,
    );
    add(totalText);
  }

  @override
  void onRemove() {
    super.onRemove();
    removeAll(children);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
