part of 'suite_bloc.dart';

sealed class SuiteEvent extends Equatable {
  const SuiteEvent();

  @override
  List<Object> get props => [];
}

class GameReset extends SuiteEvent {
  const GameReset();

  @override
  List<Object> get props => [];
}

class QuestionAnswered extends SuiteEvent {
  final int questionIndex;
  final bool isCorrect;
  const QuestionAnswered(
      {required this.questionIndex, required this.isCorrect});

  @override
  List<Object> get props => [questionIndex, isCorrect];
}

class NextQuestion extends SuiteEvent {
  final int nextIndex;
  const NextQuestion({required this.nextIndex});

  @override
  List<Object> get props => [nextIndex];
}

class PolygonMoved extends SuiteEvent {
  final int questionIndex;
  final int polygonIndex;
  final Vector2 newPosition;

  const PolygonMoved({
    required this.questionIndex,
    required this.polygonIndex,
    required this.newPosition,
  });

  @override
  List<Object> get props => [questionIndex, polygonIndex, newPosition];
}
