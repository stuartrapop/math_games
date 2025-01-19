import 'dart:async';

import 'package:first_math/components/home_position_component.dart';
import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/board.dart';
import 'package:first_math/memory_games/memory_games.dart';
import 'package:first_math/memory_games/sprite_management.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class MemoryMatchComponent extends PositionComponent
    with HasGameRef<MemoryGames> {
  final SpriteLoader spriteLoader = SpriteLoader();
  MemoryMatchBloc memoryMatchBloc;
  final Function returnHome;

  MemoryMatchComponent({
    required this.memoryMatchBloc,
    required this.returnHome,
  }) : super(priority: 10) {}

  final worldSize = Vector2(600, 900);
  late Board board;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print("onload memory match");
    add(HomePositionComponent(game: game, returnHome: returnHome)
      ..position = Vector2(50, 50)
      ..size = Vector2(50, 50));
    await spriteLoader.loadSprites();
    int actualBoardWidth = memoryMatchBloc.state.boardValues.length * 75;
    int actualBoardHeight = memoryMatchBloc.state.boardValues[0].length * 75;
    board = Board(
      spriteLoader: spriteLoader,
      memoryMatchBloc: memoryMatchBloc,
    )
      ..size =
          Vector2(actualBoardWidth.toDouble(), actualBoardHeight.toDouble())
      ..position = Vector2(worldSize.x / 2, worldSize.y / 2 + 40)
      ..anchor = Anchor.center;
    add(board);
    add(HomePositionComponent(game: game, returnHome: returnHome)
      ..position = Vector2(50, 50)
      ..size = Vector2(50, 50));
    List<LevelButton> levelButtons = [
      LevelButton(
        text: 'Facile',
        onPressed: () {
          memoryMatchBloc.add(GameReset(rows: 3, columns: 2));
        },
        borderColor: Color.fromARGB(255, 163, 167, 212),
        hoverColor: Color.fromARGB(255, 128, 135, 203),
        onPressedColor: Color.fromARGB(255, 147, 149, 173),
        shadowColor: Colors.white,
        shadowBlur: 4,
        shadowOffset: Vector2(5, 5),
        backgroundColor: fillBlue.color,
        radius: 10,
      )
        ..anchor = Anchor.center
        ..size = Vector2(150, 60)
        ..position = Vector2(worldSize.x / 2 - 200, 150),
      LevelButton(
        text: 'Intermédiaire',
        onPressed: () {
          memoryMatchBloc.add(GameReset(rows: 4, columns: 4));
        },
        borderColor: Color.fromARGB(255, 163, 167, 212),
        hoverColor: Color.fromARGB(255, 128, 135, 203),
        onPressedColor: Color.fromARGB(255, 147, 149, 173),
        shadowColor: Colors.white,
        shadowBlur: 4,
        shadowOffset: Vector2(5, 5),
        backgroundColor: fillBlue.color,
        radius: 10,
      )
        ..anchor = Anchor.center
        ..size = Vector2(150, 60)
        ..position = Vector2(worldSize.x / 2, 150),
      LevelButton(
        text: 'Difficile',
        onPressed: () {
          memoryMatchBloc.add(GameReset(rows: 5, columns: 6));
        },
        borderColor: Color.fromARGB(255, 163, 167, 212),
        hoverColor: Color.fromARGB(255, 128, 135, 203),
        onPressedColor: Color.fromARGB(255, 147, 149, 173),
        shadowColor: Colors.white,
        shadowBlur: 4,
        shadowOffset: Vector2(5, 5),
        backgroundColor: fillBlue.color,
        radius: 10,
      )
        ..anchor = Anchor.center
        ..size = Vector2(150, 60)
        ..position = Vector2(worldSize.x / 2 + 200, 150),
    ];
    addAll(levelButtons);
  }

  @override
  void update(double dt) {
    int actualBoardWidth = memoryMatchBloc.state.boardValues.length * 75;
    int actualBoardHeight = memoryMatchBloc.state.boardValues[0].length * 75;
    board
      ..size = Vector2(
          actualBoardWidth.toDouble(), actualBoardHeight.toDouble() + 40);
    super.update(dt);
  }

  @override
  Future<void> onRemove() async {
    print("Columns updated: ");
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, worldSize.x, worldSize.y),
    //   Paint()..color = const Color.fromARGB(255, 218, 107, 107),
    // );
    super.render(canvas);
  }
}

class LevelButton extends PositionComponent with TapCallbacks, HoverCallbacks {
  final String text;
  final VoidCallback onPressed;
  final Color shadowColor;
  final double shadowBlur;
  final Color hoverColor;
  final Vector2 shadowOffset;
  final Color backgroundColor;
  final Color borderColor;
  final Color onPressedColor;
  final double radius;
  LevelButton({
    required this.borderColor,
    required this.shadowColor,
    required this.shadowBlur,
    required this.hoverColor,
    required this.shadowOffset,
    required this.backgroundColor,
    required this.radius,
    required this.text,
    required this.onPressed,
    required this.onPressedColor,
  }) : super();
  late TextComponent numberText;
  final regular = TextPaint(
    style: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
  );
  late Color buttonColor;
  late Paint backgroundPaint;
  late Paint shadowPaint;
  late Paint outlinePaint;
  double borderWidth = 2; // Width of the white edge

  @override
  Future<void> onLoad() async {
    buttonColor = backgroundColor;
    backgroundPaint = Paint()..color = backgroundColor;
    shadowPaint = Paint()
      ..color = shadowColor.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
    outlinePaint = Paint()
      ..color = const Color.fromARGB(255, 163, 167, 212) // White color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    numberText = TextComponent(
      textRenderer: regular,
      size: Vector2(50, 50),
      text: text,
      position: Vector2(size.x / 2, size.y / 2), // Position text at the bottom
      anchor: Anchor.center,
    );

    add(numberText);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    buttonColor = onPressedColor;
    backgroundPaint.color = Color.lerp(backgroundColor, onPressedColor, 0.2)!;
    Future.delayed(Duration(milliseconds: 300), () {
      backgroundPaint.color = backgroundColor;
    });
    onPressed();
  }

  @override
  void onHoverEnter() {
    buttonColor = hoverColor;
    backgroundPaint.color = Color.lerp(backgroundColor, hoverColor, 0.2)!;
  }

  @override
  void onHoverExit() {
    buttonColor = backgroundColor;
    backgroundPaint.color = backgroundColor;
  }

  @override
  void render(Canvas canvas) {
// Define the rounded rectangle
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
      Radius.circular(radius), // 10% of the rectangle's width
    );

    canvas.drawRRect(roundedRect, outlinePaint);

    final Rect shadowRect = Rect.fromLTWH(
      shadowOffset.x,
      shadowOffset.y,
      size.x,
      size.y,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        shadowRect,
        Radius.circular(radius), // Adjust corner radius if needed
      ),
      shadowPaint,
    );

    // Draw background

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.x,
          size.y,
        ),
        Radius.circular(radius), // Match corner radius
      ),
      backgroundPaint,
    );

    super.render(canvas);
  }
}
