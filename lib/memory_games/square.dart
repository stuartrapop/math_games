import 'dart:ui';

import 'package:first_math/components/sized_text_box.dart';
import 'package:first_math/l10n/strings.g.dart';
import 'package:first_math/memory_games/bloc/memory_match_bloc.dart';
import 'package:first_math/memory_games/sprite_management.dart';
import 'package:first_math/utils/constants.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Square extends PositionComponent
    with TapCallbacks, HoverCallbacks, HasGameRef {
  int column;
  int row;
  final SpriteLoader spriteLoader;
  MemoryMatchBloc memoryMatchBloc;
  late CardStatus cardStatus;
  late SizedTextBox sizedTextBox;

  Square({
    required this.column,
    required this.row,
    required this.spriteLoader,
    required this.memoryMatchBloc,
  });
  double margin = 5;
  late SpriteComponent spriteComponent;
  bool isTappable = true;
  bool showCard = false;
  int cardValue = 0;
  late String description;
  bool showBlue = false;
  Paint colorBack = fillRed;

  @override
  void onLoad() async {
    try {
      cardValue = memoryMatchBloc.state.boardValues[row][column].value;
      cardStatus = memoryMatchBloc.state.boardValues[row][column].status;
    } catch (e) {
      print(" $e row column $row $column");
    }
    anchor = Anchor.topLeft;
    priority = 10;
    final spriteType = SpriteType.values[cardValue];

    final sprite = spriteLoader.getSprite(spriteType);
    description = spriteLoader.getDescription(spriteType);
    parent?.parent?.children.whereType<SizedTextBox>().forEach((child) {
      child.removeFromParent();
    });

    spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(50, 50),
      position: Vector2(size.x / 2, size.y / 2),
    )..anchor = Anchor.center;
    // _updateSpriteVisibility(force: true);

    return super.onLoad();
  }

  @override
  void update(double dt) async {
    super.update(dt);
    _updateSpriteVisibility();
    // Bounds check
  }

  @override
  void onHoverEnter() {
    // TODO: implement onHoverEnter
    print("hovering on row/column $row $column");
    colorBack = fillHoverRed;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    print("hovering exit on row/column $row $column");
    colorBack = fillRed;
    super.onHoverExit();
  }

  @override
  void onTapDown(TapDownEvent event) async {
    // final english = AppLocale.en.build();
    // final french = AppLocale.fr.build();
    isTappable = memoryMatchBloc.state.gameStatus == GameStatus.running;
    if (!isTappable) {
      return;
    }
    print("tapped on value $cardValue");
    print("description: $description");
    LocaleSettings.setLocale(AppLocale.fr);
// Fetch the translation
    final t = await AppLocale.fr.build();
    Utils.speak(
      t.a["$description"]!,
      isRandom: false,
      language: 'fr-FR',
    );
    sizedTextBox = SizedTextBox(
      t.a["$description"]!,
      size: Vector2(500, 499),
      timePerChar: 0.1,
      fontSize: 50,
    )..position = Vector2(250, 510);
    gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
      child.removeFromParent();
    });
    print("gammeref ${gameRef.world}");
    gameRef.world.add(sizedTextBox);
    Future.delayed(Duration(seconds: 3), () {
      if (gameRef.world.children.contains(sizedTextBox)) {
        print("removing sizedTextBox");
        gameRef.world.remove(sizedTextBox);
      }
      // parent!.add(sizedTextBox);
    });

    memoryMatchBloc.add(CardClickedEvent(row: row, column: column));
  }

  void _updateSpriteVisibility({bool force = false}) {
    // Only update if the card status has changed or a force update is requested
    try {
      showCard = memoryMatchBloc.state.boardValues[row][column].cardVisibility;
      if (showCard) {
        // Show the sprite if visible or matched
        if (!children.contains(spriteComponent)) {
          add(spriteComponent);
        }
      } else {
        // Remove the sprite if hidden
        if (children.contains(spriteComponent)) {
          remove(spriteComponent);
        }
      }
    } catch (e) {
      print("Error $e in updateSpriteVisibility: row: $row, column: $column");
    }
  }

  @override
  void render(Canvas canvas) {
    double margin = 5;
    try {
      showBlue = memoryMatchBloc.state.boardValues[row][column].status ==
          CardStatus.matched;
    } catch (e) {}

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          margin,
          margin,
          size.x - 2 * margin,
          size.y - 2 * margin,
        ),
        Radius.circular(size.x * 0.2), // 10% of the rectangle's width
      ),
      showBlue ? fillBlue : colorBack,
    );
    super.render(canvas);
  }
}
