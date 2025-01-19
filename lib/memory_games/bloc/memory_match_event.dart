part of 'memory_match_bloc.dart';

abstract class MemoryMatchEvent extends Equatable {
  const MemoryMatchEvent();
}

class CardClickedEvent extends MemoryMatchEvent {
  const CardClickedEvent({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  @override
  List<Object?> get props => [row, column];
}

class GameReset extends MemoryMatchEvent {
  final int rows;
  final int columns;
  const GameReset({required this.rows, required this.columns});

  @override
  List<Object?> get props => [rows, columns];
}
