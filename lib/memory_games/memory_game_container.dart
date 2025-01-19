import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/memory_games.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoryGameContainer extends StatelessWidget {
  final Function returnHome;
  const MemoryGameContainer({super.key, required this.returnHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemoryMatchBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: MemoryGames(
              memoryMatchBloc: context.read<MemoryMatchBloc>(),
              returnHome: returnHome,
            ),
          );
        },
      ),
    );
  }
}
