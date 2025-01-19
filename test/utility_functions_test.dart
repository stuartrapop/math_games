// Import the test package and Counter class

import 'package:collection/collection.dart';
import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/utils/memoryMatch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test start, increment, decrement', () {
    test(
        'cardSet with 6 rows and 4 columns should be an array with 6 items each of which has 4 items',
        () {
      final List<List<CardState>> cardSet = createCardSet(rows: 3, columns: 4);

      expect(cardSet.length, 3);
      expect(cardSet[0].length, 4);
    });
  });

  test('Each card value appears exactly twice', () {
    // Generate a card set
    final List<List<CardState>> cardSet = createCardSet(rows: 3, columns: 4);

    // Flatten the 2D list into a single list of CardState objects
    final flattenedCards = cardSet.expand((row) => row).toList();

    // Group by card value
    final groupedByValue =
        groupBy(flattenedCards, (CardState card) => card.value);

    // Assert that every value has exactly two occurrences
    for (final entry in groupedByValue.entries) {
      expect(
        entry.value.length,
        2,
        reason: 'Value ${entry.key} does not appear exactly twice',
      );
    }
  });
}
