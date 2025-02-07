part of 'suite_bloc.dart';

List<int> _partAValues = [];
List<int> get partAValues => _partAValues;
List<int> _partBValues = [];
List<int> get partBValues => _partBValues;

class SuiteState extends Equatable {
  final List<int> partA;
  final List<int> partB;
  final List<bool> matchStatus;

  const SuiteState({
    required this.partA,
    required this.partB,
    required this.matchStatus,
  });

  SuiteState.reset()
      : this(
          partA: (() {
            _partAValues = generatePartAValues(number: 3);
            _partBValues = generatePartBValues(leftValues: _partAValues);
            return _partAValues;
          })(),
          partB: _partBValues,
          matchStatus: List.filled(3, false),
        );

  SuiteState copyWith({
    List<int>? partA,
    List<int>? partB,
    List<bool>? matchStatus,
  }) {
    print("matchStatus: $matchStatus");
    return SuiteState(
      partA: partA ?? this.partA,
      partB: partB ?? this.partB,
      matchStatus: matchStatus ?? this.matchStatus,
    );
  }

  @override
  List<Object> get props => [partA, partB, matchStatus];
}

final class CeriseInitial extends SuiteState {
  const CeriseInitial({
    required super.partA,
    required super.partB,
    required super.matchStatus,
  });
}
