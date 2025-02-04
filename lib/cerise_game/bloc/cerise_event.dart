part of 'cerise_bloc.dart';

sealed class CeriseEvent extends Equatable {
  const CeriseEvent();

  @override
  List<Object> get props => [];
}

class CorrectMatch extends CeriseEvent {
  const CorrectMatch(this.partBPosition);

  final int partBPosition;

  @override
  List<Object> get props => [partBPosition];
}

class GameReset extends CeriseEvent {
  const GameReset();

  @override
  List<Object> get props => [];
}
