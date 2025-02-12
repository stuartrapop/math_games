part of 'suite_bloc.dart';

enum QuestionStatus { correct, incorrect, unanswered }

class SuiteState extends Equatable {
  final List<QuestionData> questionList;
  final List<QuestionStatus> questionStatus;
  final List<List<Vector2>> initialQuestionPositions;
  final List<List<Vector2>> currentQuestionPositions;
  final List<List<Vector2>> answerPositions;
  final int currentQuestionIndex;

  SuiteState({
    required this.questionList,
    List<QuestionStatus>? questionStatus,
    List<List<Vector2>>? currentQuestionPositions,
    int? currentQuestionIndex,
  })  : questionStatus = questionStatus ??
            List.filled(questionList.length, QuestionStatus.unanswered),
        currentQuestionIndex = currentQuestionIndex ?? 0,
        initialQuestionPositions =
            questionList.map((q) => q.questionPositions).toList(),
        currentQuestionPositions = currentQuestionPositions ??
            questionList.map((q) => q.questionPositions).toList(),
        answerPositions = questionList.map((q) => q.answerPositions).toList();

  @override
  List<Object?> get props => [
        questionList
            .map((q) => q.toString())
            .toList(), // Ensures deep comparison
        List.of(questionStatus), // Ensures new reference
        currentQuestionIndex,
        currentQuestionPositions,
      ];

  @override
  String toString() {
    return 'SuiteState(questions: ${questionList.length}, status: $questionStatus, currentIndex: $currentQuestionIndex)';
  }

  SuiteState copyWith({
    List<QuestionData>? questionList,
    List<QuestionStatus>? questionStatus,
    List<List<Vector2>>? currentQuestionPositions,
    int? currentQuestionIndex,
  }) {
    return SuiteState(
      questionList: questionList ?? List.from(this.questionList),
      questionStatus: questionStatus ?? List.from(this.questionStatus),
      currentQuestionPositions:
          currentQuestionPositions ?? List.from(this.currentQuestionPositions),
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}

final class SuiteInitial extends SuiteState {
  SuiteInitial({required super.questionList})
      : super(
          questionStatus:
              List.filled(questionList.length, QuestionStatus.unanswered),
          currentQuestionIndex: 5,
        );
}
