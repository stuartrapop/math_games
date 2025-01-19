import 'package:equatable/equatable.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'match_stats_event.dart';
part 'match_stats_state.dart';

class MatchStatsBloc extends Bloc<MatchStatsEvent, MatchStatsState> {
  MatchStatsBloc() : super(MatchStatsState.empty()) {
    on<ScoreEventAdded>(
      (event, emit) => emit(
        state.copyWith(
          score: state.score + event.score,
        ),
      ),
    );
    on<LeftCardVisibilityUpdate>(
      (event, emit) => emit(
        state.copyWith(
          leftVisible: event.leftVisible,
        ),
      ),
    );
    on<RightCardVisibilityUpdate>(
      (event, emit) => emit(
        state.copyWith(
          rightVisible: event.rightVisible,
        ),
      ),
    );

    on<PlayerRespawned>(
      (event, emit) => emit(
        state.copyWith(status: MatchStatus.respawned),
      ),
    );

    on<GameReset>(
      (event, emit) => emit(
        MatchStatsState.empty(),
      ),
    );
  }
}
