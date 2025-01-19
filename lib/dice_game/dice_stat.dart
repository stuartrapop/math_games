import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiceStat extends StatelessWidget {
  const DiceStat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameStatsBloc, GameStatsState>(
      builder: (context, state) {
        return Positioned(
          top: 30,
          left: 350,
          child: Container(
            height: 150,
            width: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Somme des dés',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Points: ${state.score}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(width: 50),
                    Text(
                      'Cible: ${state.lives}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == GameStatus.gameOver,
      listener: (context, state) {
        final bloc = context.read<GameStatsBloc>();
        showDialog<void>(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 230,
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      bloc.state.score == bloc.state.lives
                          ? Text(
                              'Tu as gagné!',
                              style: Theme.of(context).textTheme.displayMedium,
                            )
                          : Text(
                              'Tu as dépassé la cible. \nEssaie de nouveau!',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          bloc.add(const GameReset());
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Recommencer',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
