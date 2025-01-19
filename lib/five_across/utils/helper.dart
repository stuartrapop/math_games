import 'package:first_math/five_across/bloc/operations_bloc.dart';

List<Question> getFilteredUnansweredQuestions(
    List<Question> questions, List<List<CellValue>> boardValues) {
  return questions.where((question) {
    // Ensure the question is unanswered
    if (question.questionStatus != QuestionStatus.unanswered) {
      return false;
    }

    // Calculate the correct answer for the question
    final correctAnswer = OperationsState.getQuestionValue(question);

    // Check if the correct answer exists on the board
    final hasAnswerOnBoard = boardValues.any((row) {
      return row.any(
        (cell) =>
            cell.value == correctAnswer &&
            cell.answerStatus == AnswerStatus.hasNotBeenSelected,
      );
    });

    return hasAnswerOnBoard;
  }).toList();
}

bool hasWon({required List<List<CellValue>> boardValues}) {
  int size = boardValues.length;
  for (int i = 0; i < 5; i++) {
    if (boardValues[i]
        .every((cell) => cell.answerStatus == AnswerStatus.correct)) {
      return true;
    }
  }
  for (int i = 0; i < 5; i++) {
    if (boardValues
        .every((row) => row[i].answerStatus == AnswerStatus.correct)) {
      return true;
    }
  }
  // Check top-left to bottom-right diagonal
  if (List.generate(size, (i) => boardValues[i][i])
      .every((cell) => cell.answerStatus == AnswerStatus.correct)) {
    return true;
  }

  // Check top-right to bottom-left diagonal
  if (List.generate(size, (i) => boardValues[i][size - i - 1])
      .every((cell) => cell.answerStatus == AnswerStatus.correct)) {
    return true;
  }
  return false;
}
