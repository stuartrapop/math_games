import 'dart:async';

import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/memory_match_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ExperimentWorld extends World {
  MemoryMatchBloc memoryMatchBloc;
  ExperimentWorld({required this.memoryMatchBloc, required this.returnHome});
  double borderWidth = 10.0;
  final Function returnHome;

  @override
  Future<void> onLoad() async {
    add(MemoryMatchComponent(
        memoryMatchBloc: memoryMatchBloc, returnHome: returnHome));
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
