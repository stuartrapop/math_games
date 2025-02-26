import 'package:first_math/geometric_suite/rotate_polygon/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/rotate_polygon/data/questions.dart';
import 'package:first_math/geometric_suite/rotate_polygon/rotate_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RotateContainer extends StatefulWidget {
  final Function returnHome;
  const RotateContainer({super.key, required this.returnHome});

  @override
  State<RotateContainer> createState() => _RotateContainerState();
}

class _RotateContainerState extends State<RotateContainer> {
  late RotateGame rotateGame;
  late GameBloc rotateBloc;
  @override
  void initState() {
    super.initState();
    rotateBloc = GameBloc(questions: questionData);
    rotateGame = RotateGame(
      returnHome: widget.returnHome,
      gameBloc: rotateBloc, // ✅ Use a single instance
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: rotateBloc, // ✅ Use existing bloc
      child: GameWidget(game: rotateGame), // ✅ Use existing game
    );
  }

  @override
  void dispose() {
    rotateBloc.close(); // ✅ Cleanup bloc when widget is removed
    super.dispose();
  }
}
