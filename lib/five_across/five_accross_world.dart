import 'dart:async';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/five_across/five_accross_component.dart';
import 'package:first_math/five_across/five_accross_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FiveAccrossWorld extends World with HasGameRef<FiveAcrossGame> {
  OperationsBloc operationsBloc;
  FiveAccrossWorld({required this.operationsBloc, required this.returnHome});
  double borderWidth = 10.0;
  final Function returnHome;

  @override
  Future<void> onLoad() async {
    Function returnMenu = () {
      gameRef.router.pushNamed("game-over");
    };
    add(FiveAccrossComponent(
        operationsBloc: operationsBloc, returnHome: returnMenu));
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw the red background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 600, 900),
      Paint()..color = const Color.fromARGB(255, 50, 50, 52),
    );

    super.render(canvas);
  }
}
