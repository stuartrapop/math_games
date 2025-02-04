part of 'match_stats_bloc.dart';

abstract class MatchStatsEvent extends Equatable {
  const MatchStatsEvent();
}

class ScoreEventAdded extends MatchStatsEvent {
  const ScoreEventAdded(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}

class LeftCardVisibilityUpdate extends MatchStatsEvent {
  const LeftCardVisibilityUpdate(this.leftVisible);

  final List<bool> leftVisible;

  @override
  List<Object?> get props => [leftVisible];
}

class RightCardVisibilityUpdate extends MatchStatsEvent {
  const RightCardVisibilityUpdate(this.rightVisible);

  final List<bool> rightVisible;

  @override
  List<Object?> get props => [rightVisible];
}

class BlockEventAdded extends MatchStatsEvent {
  const BlockEventAdded(this.blockValue);

  final int blockValue;

  @override
  List<Object?> get props => [blockValue];
}

class PlayerDied extends MatchStatsEvent {
  const PlayerDied();

  @override
  List<Object?> get props => [];
}

class PlayerRespawned extends MatchStatsEvent {
  const PlayerRespawned();

  @override
  List<Object?> get props => [];
}

class GameReset extends MatchStatsEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}
