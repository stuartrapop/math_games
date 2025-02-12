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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuiteBloc(questions: questionData),
      child: Builder(
        builder: (context) {
          final suiteBloc = context.read<SuiteBloc>(); // ✅ Get SuiteBloc

          return GameWidget(
            game: SuiteGame(
              returnHome: widget.returnHome,
              suiteBloc: suiteBloc, // ✅ Pass the bloc instance
            ),
          );
        },
      ),
    );
  }
}
