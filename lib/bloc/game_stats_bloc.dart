import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_stats_event.dart';
part 'game_stats_state.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState> {
  GameStatsBloc() : super(GameStatsState.empty()) {
    on<ScoreEventAdded>(
      (event, emit) => emit(
        state.copyWith(
            score: state.score + event.score,
            status: (state.score + event.score) >= state.lives
                ? GameStatus.gameOver
                : GameStatus.initial),
      ),
    );

    on<BlockEventAdded>((event, emit) {
      print("Adding block value: ${event.blockValue}");
      print("Current blockValue: ${state.blockValue}");
      emit(
        state.copyWith(
          blockValue: state.blockValue + event.blockValue,
        ),
      );
      print("Updated blockValue: ${state.blockValue}");
    });

    on<PlayerRespawned>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.respawned),
      ),
    );

    on<PlayerDied>((event, emit) {
      if (state.lives > 1) {
        emit(
          state.copyWith(
            lives: state.lives - 1,
            status: GameStatus.respawn,
          ),
        );
      } else {
        emit(
          state.copyWith(
            lives: 0,
            status: GameStatus.gameOver,
          ),
        );
      }
    });

    on<GameReset>(
      (event, emit) => emit(
        GameStatsState.empty(),
      ),
    );
  }
}
