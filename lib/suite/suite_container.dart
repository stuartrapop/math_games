import 'package:first_math/suite/bloc/suite_bloc.dart';
import 'package:first_math/suite/data/questions.dart';
import 'package:first_math/suite/suite_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuiteContainer extends StatefulWidget {
  final Function returnHome;
  const SuiteContainer({super.key, required this.returnHome});

  @override
  State<SuiteContainer> createState() => _SuiteContainerState();
}

class _SuiteContainerState extends State<SuiteContainer> {
  late SuiteGame suiteGame;
  late SuiteBloc suiteBloc;
  @override
  void initState() {
    super.initState();
    suiteBloc = SuiteBloc(questions: questionData);
    suiteGame = SuiteGame(
      returnHome: widget.returnHome,
      suiteBloc: suiteBloc, // ✅ Use a single instance
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: suiteBloc, // ✅ Use existing bloc
      child: GameWidget(game: suiteGame), // ✅ Use existing game
    );
  }

  @override
  void dispose() {
    suiteBloc.close(); // ✅ Cleanup bloc when widget is removed
    super.dispose();
  }
}
