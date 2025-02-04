part of 'match_stats_bloc.dart';

enum MatchStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

List<int> _leftValues = [];
List<int> get leftValues => _leftValues;
List<int> _rightValues = [];
List<int> get rightValues => _rightValues;

class MatchStatsState extends Equatable {
  final List<int> leftValues;
  final List<int> rightValues;
  final List<bool> leftVisible;
  final List<bool> rightVisible;
  final int score;
  final MatchStatus status;

  const MatchStatsState({
    required this.leftValues,
    required this.rightValues,
    required this.leftVisible,
    required this.rightVisible,
    required this.score,
    required this.status,
  });

  MatchStatsState.empty()
      : this(
          leftValues: (() {
            _leftValues = Utils.generateLeftValues();
            _rightValues = [..._leftValues]..shuffle();
            return _leftValues;
          })(),
          rightValues: _rightValues,
          leftVisible: List.filled(5, true),
          rightVisible: List.filled(5, true),
          score: 0,
          status: MatchStatus.initial,
        );

  MatchStatsState copyWith({
    int? score,
    MatchStatus? status,
    List<int>? leftValues,
    List<int>? rightValues,
    List<bool>? leftVisible,
    List<bool>? rightVisible,
  }) {
    return MatchStatsState(
      leftValues: leftValues ?? this.leftValues,
      rightValues: rightValues ?? this.rightValues,
      leftVisible: leftVisible ?? this.leftVisible,
      rightVisible: rightVisible ?? this.rightVisible,
      score: score ?? this.score,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        score,
        status,
        leftValues,
        rightValues,
        rightVisible,
        leftVisible,
      ];
}
