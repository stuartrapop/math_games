part of 'cuisenaire_bloc.dart';

abstract class CuisenaireEvent extends Equatable {
  const CuisenaireEvent();
}

class AddRegletteEvent extends CuisenaireEvent {
  final RegletteBlock reglette;
  final bool isLeft;

  AddRegletteEvent({required this.reglette, required this.isLeft});

  @override
  List<Object?> get props => [reglette, isLeft];
}

class RemoveRegletteEvent extends CuisenaireEvent {
  final RegletteBlock reglette;
  final bool isLeft;

  RemoveRegletteEvent({required this.reglette, required this.isLeft});

  @override
  List<Object?> get props => [reglette, isLeft];
}

class GameReset extends CuisenaireEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}

class ClearRightBoard extends CuisenaireEvent {
  const ClearRightBoard();

  @override
  List<Object?> get props => [];
}

class RefactorFirstBoard extends CuisenaireEvent {
  final int value;
  final bool isHorizontal;
  final RectangleResult leftTableRectangleValue;
  const RefactorFirstBoard(
      {required this.value,
      required this.isHorizontal,
      required this.leftTableRectangleValue});

  @override
  List<Object?> get props => [value, isHorizontal, leftTableRectangleValue];
}
