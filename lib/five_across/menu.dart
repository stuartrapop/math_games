import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/five_across/five_accross_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final RouterComponent router;
  final FiveAcrossGame game;
  final OperationsBloc operationsBloc;
  final Function returnHome;

  const Menu({
    super.key,
    required this.router,
    required this.game,
    required this.operationsBloc,
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
                  'Menu',
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
                    operationsBloc.add(
                      const GameReset(
                        rows: 5,
                        columns: 5,
                        level: Level.easy,
                        operator: Operator.addition,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 100));
                    game.overlays.remove('menu');

                    // Navigate to Moving Containers
                    router.pushNamed('five-accross-game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Jouer à l\'addition'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    operationsBloc.add(
                      const GameReset(
                        rows: 5,
                        columns: 5,
                        level: Level.easy,
                        operator: Operator.subtraction,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 100));
                    game.overlays.remove('menu');

                    // Navigate to Moving Containers
                    router.pushNamed('five-accross-game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Substraction'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    operationsBloc.add(
                      const GameReset(
                        rows: 5,
                        columns: 5,
                        level: Level.easy,
                        operator: Operator.multiplication,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 100));
                    game.overlays.remove('menu');

                    // Navigate to Moving Containers
                    router.pushNamed('five-accross-game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Multiplication'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay
                    operationsBloc.add(
                      const GameReset(
                        rows: 5,
                        columns: 5,
                        level: Level.easy,
                        operator: Operator.division,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 100));
                    game.overlays.remove('menu');

                    // Navigate to Moving Containers
                    router.pushNamed('five-accross-game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Division'),
                ),
                const SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () async {
                //     // Hide the overlay

                //     returnHome();

                //     // Navigate to Moving Containers
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.deepPurple, // Button color
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
