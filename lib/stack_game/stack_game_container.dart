import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/stack_game/stack_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StackGameContainer extends StatelessWidget {
  final Function returnHome;
  const StackGameContainer({super.key, required this.returnHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameStatsBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: StackGame(
              gameStatsBloc: context.read<GameStatsBloc>(),
              returnHome: returnHome,
            ),
          );
        },
      ),
    );
  }
}
