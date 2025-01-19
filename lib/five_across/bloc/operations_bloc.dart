import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'operations_event.dart';
part 'operations_state.dart';

class OperationsBloc extends Bloc<OperationsEvent, OperationsState> {
  OperationsBloc()
      : super(
          OperationsState.empty(
            rows: 5,
            columns: 5,
            turns: 0,
            level: Level.easy,
            operator: Operator.addition,
          ),
        ) {
    on<OnCellClick>(_onOnClick);
    on<GameReset>(_onReset);
  }
  void _onOnClick(event, emit) {
    final correctAnswer =
        OperationsState.getQuestionValue(state.questions[event.questionIndex]);
    final clickedValue = state.boardValues[event.row][event.column].value;
    print(
        "Clicked on cell: ${event.row}, ${event.column} ${state.boardValues[event.row][event.column].value} ${correctAnswer}");

    List<List<CellValue>> updatedBoardValues = List.from(state.boardValues);
    List<Question> updatedQuestions = List.from(state.questions);
    if (clickedValue == correctAnswer) {
      updatedBoardValues[event.row][event.column] = CellValue(
        value: clickedValue,
        answerStatus: AnswerStatus.correct,
      );
      updatedQuestions[event.questionIndex].questionStatus =
          QuestionStatus.correct;
    } else {
      updatedBoardValues[event.row][event.column] = CellValue(
        value: clickedValue,
        answerStatus: AnswerStatus.incorrect,
      );
      updatedQuestions[event.questionIndex].questionStatus =
          QuestionStatus.incorrect;
    }
    emit(
      state.copyWith(
        boardValues: updatedBoardValues,
        questions: updatedQuestions,
        turns: state.turns + 1,
      ),
    );
  }

  void _onReset(event, emit) {
    print(
        "GameReset event fired with rows: ${event.rows}, columns: ${event.columns}");
    emit(
      OperationsState.empty(
          rows: event.rows,
          columns: event.columns,
          level: event.level,
          operator: event.operator,
          turns: 0),
    );
  }
}
