import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AngleMenu extends StatelessWidget {
  const AngleMenu({
    super.key,
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
                    context.go('/angle/measurement');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Measurement'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay

                    context.go('/angle/slide');

                    // Navigate to Moving Containers
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: const Text('Angle Slide Bar'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Hide the overlay

                    context.go('/');

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
