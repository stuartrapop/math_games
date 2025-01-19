import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/number_line_game/number_line_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberLineContainer extends StatefulWidget {
  final Function returnHome;
  const NumberLineContainer({super.key, required this.returnHome});

  @override
  State<NumberLineContainer> createState() => _NumberLineContainerState();
}

class _NumberLineContainerState extends State<NumberLineContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemoryMatchBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: NumberLineGame(returnHome: widget.returnHome),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    print("NumberLineContainer dispose");
    super.dispose();
  }
}
