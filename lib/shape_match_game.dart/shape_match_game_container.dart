import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/shape_match_game.dart/shape_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShapeMatchGameContainer extends StatelessWidget {
  final Function returnHome;
  const ShapeMatchGameContainer({super.key, required this.returnHome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OperationsBloc(),
      child: Builder(
        builder: (context) {
          // Use the correct context here to access OperationsBloc
          return GameWidget(
            game: ShapeMatchGame(
              operationsBloc: BlocProvider.of<OperationsBloc>(context),
              returnHome: returnHome,
            ),
          );
        },
      ),
    );
  }
}
