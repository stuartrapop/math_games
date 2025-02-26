import 'package:first_math/geometric_suite/match_polygon/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/match_polygon/data/questions.dart';
import 'package:first_math/geometric_suite/match_polygon/match_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchContainer extends StatefulWidget {
  final Function returnHome;
  const MatchContainer({super.key, required this.returnHome});

  @override
  State<MatchContainer> createState() => _MatchContainerState();
}

class _MatchContainerState extends State<MatchContainer> {
  late MatchGame suiteGame;
  late GameBloc matchBloc;
  @override
  void initState() {
    super.initState();
    matchBloc = GameBloc(questions: questionData);
    suiteGame = MatchGame(
      returnHome: widget.returnHome,
      gameBloc: matchBloc, // ✅ Use a single instance
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: matchBloc, // ✅ Use existing bloc
      child: GameWidget(game: suiteGame), // ✅ Use existing game
    );
  }

  @override
  void dispose() {
    matchBloc.close(); // ✅ Cleanup bloc when widget is removed
    super.dispose();
  }
}
