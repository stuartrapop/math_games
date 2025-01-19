import 'package:equatable/equatable.dart';
import 'package:first_math/multi-cuisenaire/refactor_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart';

part 'cuisenaire_event.dart';
part 'cuisenaire_state.dart';

class CuisenaireBloc extends Bloc<CuisenaireEvent, CuisenaireState> {
  CuisenaireBloc() : super(CuisenaireState.empty()) {
    on<AddRegletteEvent>(_onAddReglette);
    on<RemoveRegletteEvent>(_onRemoveReglette);
    on<GameReset>(_onGameReset);
    on<RefactorFirstBoard>(_onRefactorFirstBoard);
    on<ClearRightBoard>(_onClearRightBoard);
  }

  void _onRefactorFirstBoard(event, emit) {
    print("RefactorFirstBoard event fired");
    List<RegletteBlock> newRightBoard = [];
    for (int i = 0;
        i < event.leftTableRectangleValue.size.x;
        i += event.isHorizontal ? event.value as int : 1) {
      for (int j = 0;
          j < event.leftTableRectangleValue.size.y;
          j += event.isHorizontal ? 1 : event.value as int) {
        newRightBoard.add(RegletteBlock(
            value: event.value,
            startRow: event.leftTableRectangleValue.upperLeft.y + j,
            startColumn: event.leftTableRectangleValue.upperLeft.x + i,
            isHorizontal: event.isHorizontal));
      }
    }
    emit(state.copyWith(
      leftBoard: [...state.leftBoard],
      rightBoard: [...newRightBoard],
    ));
  }

  void _onGameReset(event, emit) {
    print("GameReset event fired");
    emit(
      CuisenaireState.empty(),
    );
  }

  void _onClearRightBoard(event, emit) {
    emit(state.copyWith(
      leftBoard: [...state.leftBoard],
      rightBoard: [],
    ));
  }

  void _onAddReglette(event, emit) {
    print("adding reglette: ${event}");
    if (_canPlaceReglette(event.reglette, event.isLeft)) {
      if (event.isLeft) {
        emit(state.copyWith(
          leftBoard: [...state.leftBoard, event.reglette],
          rightBoard: [...state.rightBoard],
        ));
      } else {
        emit(state.copyWith(
          leftBoard: [...state.leftBoard],
          rightBoard: [...state.rightBoard, event.reglette],
        ));
      }
    } else {
      // You can add logic here to handle invalid placements, such as emitting an error state.
      print("Cannot place reglette: overlaps or out of bounds.");
    }
  }

  void _onRemoveReglette(event, emit) {
    print("removing reglette: ${event.reglette.toString()}");
    if (event.isLeft) {
      emit(state.copyWith(
        leftBoard: state.leftBoard.where((r) => r != event.reglette).toList(),
        rightBoard: [...state.rightBoard],
      ));
    } else {
      emit(state.copyWith(
        leftBoard: [...state.leftBoard],
        rightBoard: state.rightBoard.where((r) => r != event.reglette).toList(),
      ));
    }
  }

  bool _canPlaceReglette(RegletteBlock reglette, bool isLeft) {
    print("new reglette: ${reglette.startRow}, ${reglette.startColumn}");
    if (isLeft) {
      for (final existing in state.leftBoard) {
        if (_overlaps(reglette, existing)) return false;
      }
    } else {
      for (final existing in state.rightBoard) {
        if (_overlaps(reglette, existing)) return false;
      }
    }

    return true;
  }

  bool _overlaps(RegletteBlock a, RegletteBlock b) {
    print("checking overlap newReglette ${a.toString()} and ${b.toString()}");
    int aHeight = a.isHorizontal ? 1 : a.value;
    int aLength = a.isHorizontal ? a.value : 1;
    int bHeight = b.isHorizontal ? 1 : b.value;
    int bLength = b.isHorizontal ? b.value : 1;
    return a.startRow < b.startRow + bHeight &&
        a.startRow + aHeight > b.startRow &&
        a.startColumn < b.startColumn + bLength &&
        a.startColumn + aLength > b.startColumn;
  }
}
