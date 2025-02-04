import 'package:first_math/cerise_game/bloc/cerise_bloc.dart';
import 'package:first_math/cerise_game/cerise_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CeriseContainer extends StatefulWidget {
  final Function returnHome;
  const CeriseContainer({super.key, required this.returnHome});

  @override
  State<CeriseContainer> createState() => _CeriseContainerState();
}

class _CeriseContainerState extends State<CeriseContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CeriseBloc(),
      child: Builder(
        builder: (context) {
          final ceriseBloc = context.read<CeriseBloc>();
          return GameWidget(
            game: CeriseGame(
                returnHome: widget.returnHome, ceriseBloc: ceriseBloc),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    print("CeriseContainer dispose");
    super.dispose();
  }
}
