import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/memory_games.dart';
import 'package:first_math/memory_games/sprite_management.dart';
import 'package:first_math/memory_games/square.dart';
import 'package:first_math/utils/memoryMatch.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

final regular = TextPaint(
  style: TextStyle(
    fontSize: 48.0,
    color: BasicPalette.white.color,
  ),
);

class Board extends PositionComponent with HasGameRef<MemoryGames> {
  final MemoryMatchBloc memoryMatchBloc;
  final SpriteLoader spriteLoader;
  Board({
    required this.memoryMatchBloc,
    required this.spriteLoader,
  }) : super(priority: 10);
  late int startColumns;
  late int startRows;
  Vector2 activeFirst = Vector2(-1, -1);

  @override
  Future<void> onLoad() async {
    print("onload board ");
    // add(
    //   FlameBlocListener<MemoryMatchBloc, MemoryMatchState>(
    //     bloc: gameRef.memoryMatchBloc,
    //     onNewState: (state) => {print("new state $state")},
    //   ),
    // );
    startRows = memoryMatchBloc.state.boardValues.length;
    startColumns = memoryMatchBloc.state.boardValues[0].length;
    _updateBoard(force: true);

    super.onLoad();
  }

  @override
  void update(double dt) async {
    if (hasGameEnded(boardValues: memoryMatchBloc.state.boardValues)) {
      gameRef.router.pushOverlay('game-over');
    }
    super.update(dt);

    _updateBoard();
  }

  void _updateBoard({bool force = false}) {
    final newRows = memoryMatchBloc.state.boardValues.length;
    final newColumns = memoryMatchBloc.state.boardValues[0].length;
    if (!force && startColumns == newColumns && startRows == newRows) {
      return;
    }
    startColumns = newColumns;
    startRows = newRows;
    // Remove all existing children from the board

    children.whereType<Square>().forEach((square) => square.removeFromParent());
    for (int i = 0; i < newRows; i++) {
      for (int j = 0; j < newColumns; j++) {
        // Add the squares to the world

        final Square square = Square(
          column: j,
          row: i,
          spriteLoader: spriteLoader,
          memoryMatchBloc: memoryMatchBloc,
        )
          ..size = Vector2(75, 75)
          ..position = Vector2(j * 75.0, i * 75.0);
        add(square);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
