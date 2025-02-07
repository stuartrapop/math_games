part of 'suite_bloc.dart';

sealed class SuiteEvent extends Equatable {
  const SuiteEvent();

  @override
  List<Object> get props => [];
}

class CorrectMatch extends SuiteEvent {
  const CorrectMatch(this.partBPosition);

  final int partBPosition;

  @override
  List<Object> get props => [partBPosition];
}

class GameReset extends SuiteEvent {
  const GameReset();

  @override
  List<Object> get props => [];
}
