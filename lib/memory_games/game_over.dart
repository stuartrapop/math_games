import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/memory_games.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final VoidCallback onGoGame;
  final Function returnHome;
  final MemoryGames game;
  final MemoryMatchBloc memoryMatchBloc;

  const GameOver({
    super.key,
    required this.onGoGame,
    required this.game,
    required this.memoryMatchBloc,
    required this.returnHome,
  });

  @override
  Widget build(BuildContext context) {
    print("context in game over: $context");
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    print("hiding overlay");
                    memoryMatchBloc.add(
                      const GameReset(rows: 4, columns: 4),
                    );
                    // Navigate to Moving Containers
                    Future.delayed(const Duration(milliseconds: 300), () {
                      onGoGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Jouer à nouveau'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add more routes as necessary
                    returnHome();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Button color
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
