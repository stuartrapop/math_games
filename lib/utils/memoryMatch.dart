import 'dart:math';

import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:vector_math/vector_math_64.dart';

List<List<CardState>> createCardSet({required int rows, required int columns}) {
  int numberCards = rows * columns;

  if (numberCards % 2 != 0 || numberCards > 36 || numberCards < 4) {
    throw Exception(
        'The number of cards must be an even number between 4 and 36');
  }
  final random = Random();
  final Set<int> uniqueNumbers = {};

  while (uniqueNumbers.length < numberCards / 2) {
    uniqueNumbers.add(random.nextInt(31));
  }

  // Step 2: Create an array of numbers with each number duplicated
  final List<int> numbersList = uniqueNumbers.toList();
  final List<int> doubledNumbers = [...numbersList, ...numbersList];

  // Step 3: Shuffle the list of numbers randomly
  doubledNumbers.shuffle();

  // Step 4: Create the board
  List<List<CardState>> boardValues = List.generate(
    rows,
    (row) => List.generate(
      columns,
      (col) =>
          CardState(value: 0, status: CardStatus.hidden, cardVisibility: false),
    ),
  );
  int index = 0;
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < columns; col++) {
      boardValues[row][col].value = doubledNumbers[index++];
    }
  }

  return boardValues;
}

Vector2 findActiveFirstPosition({
  required List<List<CardState>> boardValues,
}) {
  for (int row = 0; row < boardValues.length; row++) {
    for (int column = 0; column < boardValues[row].length; column++) {
      if (boardValues[row][column].status == CardStatus.activeFirst) {
        return Vector2(column.toDouble(), row.toDouble());
      }
    }
  }
  return Vector2(-1, -1); // Return this if no activeFirst is found
}

bool hasGameEnded({
  required List<List<CardState>> boardValues,
}) {
  for (int x = 0; x < boardValues.length; x++) {
    for (int y = 0; y < boardValues[x].length; y++) {
      if (boardValues[x][y].status != CardStatus.matched) {
        return false;
      }
    }
  }
  return true;
}
