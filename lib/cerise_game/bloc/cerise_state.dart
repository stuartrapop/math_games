part of 'cerise_bloc.dart';

List<int> _partAValues = [];
List<int> get partAValues => _partAValues;
List<int> _partBValues = [];
List<int> get partBValues => _partBValues;

class CeriseState extends Equatable {
  final List<int> partA;
  final List<int> partB;
  final List<bool> matchStatus;

  const CeriseState({
    required this.partA,
    required this.partB,
    required this.matchStatus,
  });

  CeriseState.reset()
      : this(
          partA: (() {
            _partAValues = generatePartAValues(number: 3);
            _partBValues = generatePartBValues(leftValues: _partAValues);
            return _partAValues;
          })(),
          partB: _partBValues,
          matchStatus: List.filled(3, false),
        );

  CeriseState copyWith({
    List<int>? partA,
    List<int>? partB,
    List<bool>? matchStatus,
  }) {
    print("matchStatus: $matchStatus");
    return CeriseState(
      partA: partA ?? this.partA,
      partB: partB ?? this.partB,
      matchStatus: matchStatus ?? this.matchStatus,
    );
  }

  @override
  List<Object> get props => [partA, partB, matchStatus];
}

final class CeriseInitial extends CeriseState {
  const CeriseInitial({
    required super.partA,
    required super.partB,
    required super.matchStatus,
  });
}
