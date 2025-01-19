part of 'memory_match_bloc.dart';

enum GameStatus {
  running,
  blocked,
  gameOver,
}

enum CardStatus {
  hidden,
  activeFirst,
  matched,
}

class CardState {
  int value;
  CardStatus status;
  bool cardVisibility;

  CardState({
    required this.value,
    required this.status,
    required this.cardVisibility,
  });
}

class MemoryMatchState extends Equatable {
  final List<List<CardState>> boardValues;
  final GameStatus gameStatus;
  final int turnCount;

  const MemoryMatchState({
    required this.boardValues,
    required this.gameStatus,
    required this.turnCount,
  });

  factory MemoryMatchState.empty({
    required int rows,
    required int columns,
  }) {
    final boardValues = createCardSet(rows: rows, columns: columns);

    return MemoryMatchState(
      boardValues: boardValues,
      gameStatus: GameStatus.running,
      turnCount: Random().nextInt(100),
    );
  }

  MemoryMatchState copyWith({
    List<List<CardState>>? boardValues,
    GameStatus? gameStatus,
    int? turnCount,
  }) {
    return MemoryMatchState(
      boardValues: boardValues ?? this.boardValues,
      gameStatus: gameStatus ?? this.gameStatus,
      turnCount: turnCount ?? this.turnCount,
    );
  }

  @override
  List<Object?> get props => [
        boardValues,
        gameStatus,
        turnCount,
      ];
}
