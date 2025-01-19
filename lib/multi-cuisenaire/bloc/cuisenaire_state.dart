part of 'cuisenaire_bloc.dart';

enum BoardStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

class RegletteBlock {
  final int value;
  final int startRow;
  final int startColumn;
  final bool isHorizontal;

  const RegletteBlock({
    required this.value,
    required this.startRow,
    required this.startColumn,
    required this.isHorizontal,
  });

  /// Calculates the end row and column based on the start and orientation.
  Vector2 getEndPosition() {
    final endRow = isHorizontal ? startRow : startRow + value - 1;
    final endColumn = isHorizontal ? startColumn + value - 1 : startColumn;

    return Vector2(endColumn.toDouble(), endRow.toDouble());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegletteBlock &&
        other.value == value &&
        other.startRow == startRow &&
        other.startColumn == startColumn &&
        other.isHorizontal == isHorizontal;
  }

  @override
  int get hashCode => Object.hash(value, startRow, startColumn, isHorizontal);

  @override
  String toString() {
    return 'RegletteBlock(value: $value, startRow: $startRow, startColumn: $startColumn, isHorizontal: $isHorizontal)';
  }
}

class CuisenaireState extends Equatable {
  final List<RegletteBlock> leftBoard;
  final List<RegletteBlock> rightBoard;

  const CuisenaireState({
    this.leftBoard = const [],
    this.rightBoard = const [],
  });

  factory CuisenaireState.empty() {
    final List<RegletteBlock> leftBoard = [];
    final List<RegletteBlock> rightBoard = [];

    return CuisenaireState(
      leftBoard: leftBoard,
      rightBoard: rightBoard,
    );
  }

  CuisenaireState copyWith({
    List<RegletteBlock>? leftBoard,
    List<RegletteBlock>? rightBoard,
  }) {
    return CuisenaireState(
      leftBoard: leftBoard ?? this.leftBoard,
      rightBoard: rightBoard ?? this.rightBoard,
    );
  }

  @override
  List<Object?> get props => [leftBoard, rightBoard];
}
