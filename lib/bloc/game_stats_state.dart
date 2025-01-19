part of 'game_stats_bloc.dart';

enum GameStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

class GameStatsState extends Equatable {
  final int score;
  final int lives;
  final GameStatus status;
  final int blockValue;

  const GameStatsState({
    required this.score,
    required this.lives,
    required this.status,
    required this.blockValue,
  });

  GameStatsState.empty()
      : this(
          score: 0,
          lives: Random().nextInt(30) + 1,
          status: GameStatus.initial,
          blockValue: 0,
        );

  GameStatsState copyWith({
    int? score,
    int? lives,
    GameStatus? status,
    int? blockValue,
  }) {
    return GameStatsState(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      blockValue: blockValue ?? this.blockValue,
    );
  }

  @override
  List<Object?> get props => [score, lives, blockValue, status];
}
