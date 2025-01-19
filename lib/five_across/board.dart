import 'dart:async';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/five_across/cell.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Board extends PositionComponent {
  final OperationsBloc operationsBloc;
  final int questionIndex;

  Board({
    required this.questionIndex,
    required this.operationsBloc,
  });

  @override
  FutureOr<void> onLoad() {
    int newRows = 5;
    int newColumns = 5;
    int leftPadding = 40;
    int topPadding = 40;

    for (int i = 0; i < newRows; i++) {
      for (int j = 0; j < newColumns; j++) {
        final Cell square = Cell(
          operationsBloc: operationsBloc,
          row: i,
          column: j,
          cellValue: operationsBloc.state.boardValues[i][j],
          questionIndex: questionIndex,
        )
          ..size = Vector2(60, 60)
          ..position = Vector2(j * 69.0 + leftPadding, i * 69.0 + topPadding)
          ..anchor = Anchor.topLeft;
        add(square);
      }
    }
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      fillBlue,
    );
    super.render(canvas);
  }
}
