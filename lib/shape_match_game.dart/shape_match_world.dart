import 'dart:ui';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/shape_match_game.dart/shape_match_game_component.dart';
import 'package:flame/components.dart';

class ShapeMatchWorld extends World {
  OperationsBloc operationsBloc;
  Function returnHome;
  ShapeMatchWorld({required this.operationsBloc, required this.returnHome});
  double borderWidth = 10.0;

  @override
  Future<void> onLoad() async {
    add(ShapeMatchGameComponent(
        operationsBloc: operationsBloc, returnHome: returnHome)
      ..size.setValues(600, 900)
      ..anchor = Anchor.topLeft);
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
