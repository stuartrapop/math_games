part of 'operations_bloc.dart';

enum BoardStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

enum Level {
  easy,
  medium,
  hard,
}

enum Operator {
  addition,
  subtraction,
  multiplication,
  division,
}

enum QuestionStatus {
  unanswered,
  correct,
  incorrect,
}

enum AnswerStatus {
  hasNotBeenSelected,
  correct,
  incorrect,
}

class Question {
  final int firstNumber;
  final int secondNumber;
  final Operator operator;
  QuestionStatus questionStatus;
  final int questionNumber;

  Question({
    required this.firstNumber,
    required this.secondNumber,
    required this.operator,
    required this.questionStatus,
    required this.questionNumber,
  });

  @override
  String toString() {
    return 'Question(number1: $firstNumber, number2: $secondNumber, operator: $operator, questionStatus: $questionStatus, questionNumber: $questionNumber)';
  }
}

class CellValue {
  final int value;
  final AnswerStatus answerStatus;

  const CellValue({
    required this.value,
    required this.answerStatus,
  });

  @override
  String toString() {
    return 'Answer(value: $value, isCorrect: $answerStatus)';
  }
}

class OperationsState extends Equatable {
  final List<List<CellValue>> boardValues;
  final List<Question> questions;
  final int turns;

  const OperationsState({
    this.questions = const [],
    this.boardValues = const [],
    this.turns = 0,
  });

  factory OperationsState.empty({
    required int rows,
    required int columns,
    required Level level,
    required Operator operator,
    required int turns,
  }) {
    final List<Question> questions = makeQuestions(
      rows: rows,
      columns: columns,
      level: level,
      operator: operator,
    );
    final List<List<CellValue>> boardValues = makeBoardValues(
      rows: rows,
      columns: columns,
      questions: questions,
    );
    int turns = 0;

    return OperationsState(
      boardValues: boardValues,
      questions: questions,
      turns: turns,
    );
  }

  OperationsState copyWith({
    List<List<CellValue>>? boardValues,
    List<Question>? questions,
    int? turns,
  }) {
    return OperationsState(
      boardValues: boardValues ?? this.boardValues,
      questions: questions ?? this.questions,
      turns: turns ?? this.turns,
    );
  }

  @override
  List<Object?> get props => [boardValues, questions, turns];

  static List<Question> makeQuestions({
    required int rows,
    required int columns,
    required Level level,
    required Operator operator,
  }) {
    int totalQuestions = rows * columns;
    Random random = Random();
    List<Question> questions = [];

    for (int i = 0; i < totalQuestions; i++) {
      int firstNumber;
      int secondNumber;

      if (level == Level.easy) {
        firstNumber = random.nextInt(10) + 1; // Easy numbers (1-10)
        secondNumber = random.nextInt(10) + 1;
      } else {
        firstNumber = random.nextInt(100) + 1; // Hard numbers (1-100)
        secondNumber = random.nextInt(100) + 1;
      }

      // Ensure valid numbers for division to result in whole numbers
      if (operator == Operator.division) {
        firstNumber = firstNumber * secondNumber; // Ensure divisibility
      }

      // Ensure valid numbers for subtraction to avoid negative results if desired
      if (operator == Operator.subtraction && level == Level.easy) {
        if (secondNumber > firstNumber) {
          int temp = firstNumber;
          firstNumber = secondNumber;
          secondNumber = temp;
        }
      }

      questions.add(Question(
        firstNumber: firstNumber,
        secondNumber: secondNumber,
        operator: operator,
        questionStatus: QuestionStatus.unanswered,
        questionNumber: i,
      ));
    }

    return questions;
  }

  static List<List<CellValue>> makeBoardValues(
      {required int rows,
      required int columns,
      required List<Question> questions}) {
    List<List<CellValue>> boardValues = [];

    for (int i = 0; i < rows; i++) {
      List<CellValue> rowValues = [];
      for (int j = 0; j < columns; j++) {
        Question question = questions[i * columns + j];
        int value = getQuestionValue(question);

        rowValues.add(CellValue(
          value: value,
          answerStatus: AnswerStatus.hasNotBeenSelected,
        ));
      }
      boardValues.add(rowValues);
    }

    return boardValues;
  }

  static int getQuestionValue(Question question) {
    int value = 0;
    if (question.operator == Operator.addition) {
      value = question.firstNumber + question.secondNumber;
    } else if (question.operator == Operator.subtraction) {
      value = question.firstNumber - question.secondNumber;
    } else if (question.operator == Operator.multiplication) {
      value = question.firstNumber * question.secondNumber;
    } else if (question.operator == Operator.division) {
      value = question.firstNumber ~/ question.secondNumber;
    }
    return value;
  }
}
