import 'package:first_math/geometric_suite/tiled_menu/overlays/text_overlay.dart';
import 'package:first_math/geometric_suite/tiled_menu/tiled_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TileMenuContainer extends StatefulWidget {
  final Function returnHome;
  const TileMenuContainer({super.key, required this.returnHome});

  @override
  State<TileMenuContainer> createState() => _TileMenuContainerState();
}

class _TileMenuContainerState extends State<TileMenuContainer> {
  late TiledGame game;

  @override
  void initState() {
    super.initState();

    game = TiledGame(returnHome: widget.returnHome);
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      key: UniqueKey(),
      game: game,
      overlayBuilderMap: {
        'text-overlay': (BuildContext context, TiledGame game) {
          return TextOverlay(game: game);
        },
      },
    );
  }

  @override
  void dispose() {
    print("Disposing TileMenuContainer");
    game.onDispose();
    super.dispose();
  }
}
