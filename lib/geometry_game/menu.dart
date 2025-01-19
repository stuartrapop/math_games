import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final RouterComponent router;
  final GeometryGame game;
  final Function returnHome;

  const Menu({
    super.key,
    required this.router,
    required this.game,
    required this.returnHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black, // Full-screen black background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for visibility
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Hide the overlay
                game.overlays.remove('home');
                // Navigate to Moving Containers
                router.pushNamed('moving-containers');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Play Moving Containers'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add more routes as necessary
                print("Other games not implemented yet!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Other Game Placeholder'),
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
    );
  }
}
