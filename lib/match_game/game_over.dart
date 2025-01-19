import 'package:first_math/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/match_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final RouterComponent router;
  final MatchGame game;
  final MatchStatsBloc matchStatsBloc;
  final Function returnHome;

  const GameOver({
    super.key,
    required this.router,
    required this.game,
    required this.matchStatsBloc,
    required this.returnHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(
            255, 93, 69, 122), // Full-screen black background
        child: Center(
          child: Container(
            width: 350,
            height: double.infinity,
            padding: const EdgeInsets.all(20), // Add padding for inner content
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                  195, 54, 54, 0.8), // Semi-transparent red overlay
            ), // Semi-transparent black overlay
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Félication, tu as gagné !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for visibility
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    matchStatsBloc.add(GameReset());
                    await Future.delayed(const Duration(milliseconds: 100));
                    game.overlays.remove('game-over');

                    // Navigate to Moving Containers
                    router.pushNamed('match-game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Jouer Match game'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay

                    returnHome();

                    // Navigate to Moving Containers
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
