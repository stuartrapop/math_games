import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final VoidCallback onGoGame;
  final Function returnHome;
  final NumberLineGame game;

  const Home({
    super.key,
    required this.onGoGame,
    required this.game,
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
                  'Sum 10',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for visibility
                  ),
                ),
                const SizedBox(height: 30),
                AutoSizeText(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for visibility
                  ),
                ),

                const SizedBox(height: 30),
                AutoSizeText(
                  'Destroy the balls by forming pairs that add up to 10. One ball can destroy a group of balls with the same number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for visibility
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    print("hiding overlay");

                    // Navigate to Moving Containers
                    Future.delayed(const Duration(milliseconds: 300), () {
                      // game.resetGame();

                      onGoGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for visibility
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     // Add more routes as necessary
                //     print("number line game return home");
                //     returnHome();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.grey, // Button color
                //     foregroundColor: Colors.white, // Text color
                //   ),
                //   child: const Text('Home'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
