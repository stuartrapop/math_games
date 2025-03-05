import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flutter/material.dart';

class TextOverlay extends StatelessWidget {
  const TextOverlay({
    Key? key,
    required this.game,
  }) : super(key: key);

  final TiledGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 500,
              height: 70,
              alignment: Alignment.center,
              color: const Color.fromARGB(210, 218, 218, 218),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Extreme Accessiblity',
                  style: const TextStyle(
                    fontSize: 37,
                    color: Colors.black45,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                color: const Color.fromARGB(210, 218, 218, 218),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        'Level: 0',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black45,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        'Score: 45',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black45,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
