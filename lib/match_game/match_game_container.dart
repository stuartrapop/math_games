import 'package:first_math/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/match_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchGameContainer extends StatelessWidget {
  final Function returnHome;
  const MatchGameContainer({super.key, required this.returnHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchStatsBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: MatchGame(
              matchStatsBloc: context.read<MatchStatsBloc>(),
              returnHome: returnHome,
            ),
          );
        },
      ),
    );
  }
}
