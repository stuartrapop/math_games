import 'package:first_math/geometry_game/geometryGame.dart';
import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeometryGameContainer extends StatefulWidget {
  final Function returnHome;
  const GeometryGameContainer({super.key, required this.returnHome});

  @override
  State<GeometryGameContainer> createState() => _GeometryGameContainerState();
}

class _GeometryGameContainerState extends State<GeometryGameContainer> {
  FlameGame? game;

  @override
  void initState() {
    super.initState();
    // Initialize the game
    print('GeometryGameContainer initState');
    game = GeometryGame(
        matchStatsBloc: context.read<MatchStatsBloc>(),
        returnHome: widget.returnHome);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchStatsBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: game!,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up game resources
    game?.onRemove();
    super.dispose();
  }
}
