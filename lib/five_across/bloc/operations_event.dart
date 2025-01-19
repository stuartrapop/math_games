part of 'operations_bloc.dart';

abstract class OperationsEvent extends Equatable {
  const OperationsEvent();
}

class OnCellClick extends OperationsEvent {
  final int row;
  final int column;
  final int questionIndex;

  const OnCellClick(
      {required this.row, required this.column, required this.questionIndex});

  @override
  List<Object?> get props => [row, column, questionIndex];
}

class GameReset extends OperationsEvent {
  final int rows;
  final int columns;

  final Level level;
  final Operator operator;
  final int turns;
  const GameReset({
    required this.rows,
    required this.columns,
    required this.level,
    required this.operator,
    this.turns = 0,
  });

  @override
  List<Object?> get props => [rows, columns];
}
