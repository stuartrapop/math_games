part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameReset extends GameEvent {
  const GameReset();

  @override
  List<Object> get props => [];
}

class QuestionAnswered extends GameEvent {
  final int questionIndex;
  final bool isCorrect;
  const QuestionAnswered(
      {required this.questionIndex, required this.isCorrect});

  @override
  List<Object> get props => [questionIndex, isCorrect];
}

class NextQuestion extends GameEvent {
  final int nextIndex;
  const NextQuestion({required this.nextIndex});

  @override
  List<Object> get props => [nextIndex];
}
