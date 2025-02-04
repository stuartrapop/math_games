import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final VoidCallback onGoGame;
  final Function returnHome;
  final NumberLineGame game;

  const GameOver({
    super.key,
    required this.onGoGame,
    required this.game,
    required this.returnHome,
  });

  @override
  Widget build(BuildContext context) {
    print("context in game over: $context");
    return Container(
      width: double.infinity,
      height: double.infinity,
      // Full-screen black background
      child: Center(
        child: Container(
          width: 350,
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(195, 54, 54, 0.8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Score: ${game.score}',
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

                  // Navigate to Moving Containers
                  Future.delayed(const Duration(milliseconds: 300), () {
                    game.resetGame();

                    onGoGame();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('Play Again'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add more routes as necessary
                  print("number line game return home");
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
    );
  }
}
