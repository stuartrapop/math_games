import 'package:equatable/equatable.dart';
import 'package:first_math/geometric_suite/rotate_polygon/data/questions.dart';
import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required List<QuestionData> questions})
      : super(SuiteInitial(questionList: questions)) {
    on<GameReset>((event, emit) {
      final newState = GameState(
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
  }
}
