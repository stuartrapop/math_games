import 'package:first_math/geometric_suite/shape_tracer/bloc/game_bloc.dart';
import 'package:first_math/geometric_suite/shape_tracer/data/questions.dart';
import 'package:first_math/geometric_suite/shape_tracer/shape_tracer_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShapeTracerContainer extends StatefulWidget {
  final Function returnHome;
  const ShapeTracerContainer({super.key, required this.returnHome});

  @override
  State<ShapeTracerContainer> createState() => _ShapeTracerContainerState();
}

class _ShapeTracerContainerState extends State<ShapeTracerContainer> {
  late ShapeTracerGame game;
  late GameBloc shapeBloc;
  @override
  void initState() {
    super.initState();
    shapeBloc = GameBloc(questions: questionData);
    game = ShapeTracerGame(
      returnHome: widget.returnHome,
      gameBloc: shapeBloc, // ✅ Use a single instance
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: shapeBloc, // ✅ Use existing bloc
      child: GameWidget(game: game), // ✅ Use existing game
    );
  }

  @override
  void dispose() {
    shapeBloc.close(); // ✅ Cleanup bloc when widget is removed
    super.dispose();
  }
}
