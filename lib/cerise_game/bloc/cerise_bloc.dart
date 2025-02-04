import 'package:equatable/equatable.dart';
import 'package:first_math/cerise_game/helpers/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cerise_event.dart';
part 'cerise_state.dart';

class CeriseBloc extends Bloc<CeriseEvent, CeriseState> {
  CeriseBloc()
      : super(CeriseInitial(
            partA: [], partB: [], matchStatus: List.filled(3, false))) {
    on<CeriseEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GameReset>(
      (event, emit) => emit(
        CeriseState.reset(),
      ),
    );
    on<CorrectMatch>((event, emit) {
      int partBPosition = event.partBPosition;

      // Create a new list to ensure state change
      List<bool> updatedMatchStatus = List.from(state.matchStatus);
      updatedMatchStatus[partBPosition] = true;

      emit(
        state.copyWith(matchStatus: updatedMatchStatus),
      );
    });
  }
}
