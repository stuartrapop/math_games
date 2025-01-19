import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:first_math/utils/memoryMatch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart';

part 'memory_match_event.dart';
part 'memory_match_state.dart';

class MemoryMatchBloc extends Bloc<MemoryMatchEvent, MemoryMatchState> {
  MemoryMatchBloc() : super(MemoryMatchState.empty(rows: 4, columns: 4)) {
    on<CardClickedEvent>((event, emit) async {
      final currentBoardValues = state.boardValues;
      final List<List<CardState>> updatedBoardValues =
          List.from(state.boardValues);
      Vector2 firstActive =
          findActiveFirstPosition(boardValues: currentBoardValues);
      int firstActiveRow = firstActive.y.round();
      int firstActiveColumn = firstActive.x.round();
      // case already matched
      print(
          "clicked event row: ${event.row}, column: ${event.column}  last active row: $firstActiveRow, last active column: $firstActiveColumn");
      print(
          "values going into function ${(event.column == firstActiveColumn && event.row == firstActiveRow)}");
      if (firstActiveColumn != -1)
        print(
            "current value for card ${currentBoardValues[event.row][event.column].value} active card ${currentBoardValues[firstActiveRow][firstActiveColumn].value}");

      if (currentBoardValues[event.row][event.column].status ==
          CardStatus.matched) {
        return;
      }
      if (firstActiveColumn == -1) {
        print("In no active card case");
        updatedBoardValues[event.row][event.column].status =
            CardStatus.activeFirst;
        updatedBoardValues[event.row][event.column].cardVisibility = true;
      } else if (event.column == firstActiveColumn &&
          event.row == firstActiveRow) {
        print("In same card case");
        updatedBoardValues[event.row][event.column].status = CardStatus.hidden;
        updatedBoardValues[event.row][event.column].cardVisibility = false;
      }
      // case 2 if there is a first card active and the second card has the same value
      else if (currentBoardValues[event.row][event.column].value ==
          currentBoardValues[firstActiveRow][firstActiveColumn].value) {
        print("In match case");
        print("firstActive in match: $firstActive");
        print(
            "CardClickedEvent in match row: ${event.row}, column: ${event.column} firstActive: $firstActive");
        updatedBoardValues[event.row][event.column].status = CardStatus.matched;
        updatedBoardValues[event.row][event.column].cardVisibility = true;
        updatedBoardValues[firstActiveRow][firstActiveColumn].status =
            CardStatus.matched;
        updatedBoardValues[firstActiveRow][firstActiveColumn].cardVisibility =
            true;
      } else if (currentBoardValues[event.row][event.column].value !=
          currentBoardValues[firstActiveRow][firstActiveColumn].value) {
        print("In not match case");
        print("firstActive in match: $firstActive");
        print(
            "CardClickedEvent in not match row: ${event.row}, column: ${event.column}");

        updatedBoardValues[event.row][event.column].cardVisibility = true;
        updatedBoardValues[firstActiveRow][firstActiveColumn].cardVisibility =
            true;
        emit(
          state.copyWith(
            boardValues: updatedBoardValues,
            gameStatus: GameStatus.blocked,
            turnCount: state.turnCount + 1,
          ),
        );
        await Future.delayed(Duration(seconds: 2), () {
          updatedBoardValues[event.row][event.column].cardVisibility = false;
          updatedBoardValues[firstActiveRow][firstActiveColumn].cardVisibility =
              false;
          updatedBoardValues[event.row][event.column].status =
              CardStatus.hidden;
          updatedBoardValues[firstActiveRow][firstActiveColumn].status =
              CardStatus.hidden;
          emit(
            state.copyWith(
              boardValues: updatedBoardValues,
              gameStatus: GameStatus.running,
            ),
          );
        });

        return;
      }

      print(
          "final value for card ${updatedBoardValues[event.row][event.column].status}");
      print("ending firstactive ${findActiveFirstPosition(
        boardValues: updatedBoardValues,
      )}");

      emit(
        state.copyWith(
          boardValues: updatedBoardValues,
          turnCount: state.turnCount + 1,
        ),
      );
    });

    on<GameReset>((event, emit) {
      print(
          "GameReset event fired with rows: ${event.rows}, columns: ${event.columns}");
      emit(
        MemoryMatchState.empty(rows: event.rows, columns: event.columns),
      );
    });
  }
}
