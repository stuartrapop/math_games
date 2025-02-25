import 'package:equatable/equatable.dart';
import 'package:first_math/geometric_suite/suite/data/questions.dart';
import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'suite_event.dart';
part 'suite_state.dart';

class SuiteBloc extends Bloc<SuiteEvent, SuiteState> {
  SuiteBloc({required List<QuestionData> questions})
      : super(SuiteInitial(questionList: questions)) {
    on<GameReset>((event, emit) {
      final newState = SuiteState(
        questionList: List.from(state.questionList), // Ensure a new list
        questionStatus:
            List.filled(state.questionList.length, QuestionStatus.unanswered),
        currentQuestionIndex: 0,
      );
      emit(newState); // 🔥 Ensure state is emitted
    });

    on<QuestionAnswered>((event, emit) async {
      int questionIndex = event.questionIndex;
      bool isCorrect = event.isCorrect;

      List<QuestionStatus> updatedStatus = List.from(state.questionStatus);
      updatedStatus[questionIndex] =
          isCorrect ? QuestionStatus.correct : QuestionStatus.incorrect;

      emit(
        state.copyWith(
          questionList: state.questionList,
          questionStatus: updatedStatus,
          currentQuestionIndex: state.currentQuestionIndex,
        ),
      ); // 🔥 Ensure state is emitted
    });

    on<NextQuestion>((event, emit) {
      print("🔥 NextQuestion received → Updating to index: ${event.nextIndex}");

      // Prevent out-of-bounds errors
      if (event.nextIndex >= state.questionList.length) return;
      if (event.nextIndex < 0) return;
      emit(state.copyWith(currentQuestionIndex: event.nextIndex));
    });

    on<PolygonMoved>((event, emit) {
      print(
          "📌 Polygon Moved: Q${event.questionIndex} P${event.polygonIndex} → ${event.newPosition}");

      // ✅ Create a deep copy of the answers list to trigger Bloc state change
      List<List<Vector2>> updatedQuestionPositions = state
          .currentQuestionPositions
          .map(
              (innerList) => innerList.map((vector) => vector.clone()).toList())
          .toList();

      // ✅ Update only the moved polygon
      updatedQuestionPositions[event.questionIndex][event.polygonIndex] =
          event.newPosition;

      // ✅ Emit the new state
      emit(state.copyWith(currentQuestionPositions: updatedQuestionPositions));
    });
  }
}
