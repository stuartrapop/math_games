part of 'game_bloc.dart';

enum QuestionStatus { correct, incorrect, unanswered }

class GameState extends Equatable {
  final List<QuestionData> questionList;
  final List<QuestionStatus> questionStatus;

  final int currentQuestionIndex;

  GameState({
    required this.questionList,
    List<QuestionStatus>? questionStatus,
    int? currentQuestionIndex,
  })  : questionStatus = questionStatus ??
            List.filled(questionList.length, QuestionStatus.unanswered),
        currentQuestionIndex = currentQuestionIndex ?? 0;

  @override
  List<Object?> get props => [
        questionList
            .map((q) => q.toString())
            .toList(), // Ensures deep comparison
        List.of(questionStatus), // Ensures new reference
        currentQuestionIndex,
      ];

  @override
  String toString() {
    return 'GameState(questions: ${questionList.length}, status: $questionStatus, currentIndex: $currentQuestionIndex)';
  }

  GameState copyWith({
    List<QuestionData>? questionList,
    List<QuestionStatus>? questionStatus,
    int? currentQuestionIndex,
  }) {
    return GameState(
      questionList: questionList ?? List.from(this.questionList),
      questionStatus: questionStatus ?? List.from(this.questionStatus),
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}

final class SuiteInitial extends GameState {
  SuiteInitial({required super.questionList})
      : super(
          questionStatus:
              List.filled(questionList.length, QuestionStatus.unanswered),
          currentQuestionIndex: 0,
        );
}
