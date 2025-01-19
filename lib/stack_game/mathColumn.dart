import 'dart:math';

import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/constants/constants.dart';
import 'package:first_math/stack_game/cube.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';

class MathColumn extends PositionComponent
    with TapCallbacks, CollisionCallbacks, HasPaint, HasGameRef {
  int power;
  int number;
  bool isHovered = false;
  final GameStatsBloc gameStatsBloc;
  int _number;

  Paint fillPaint = Paint()
    ..color = const Color.fromARGB(255, 0, 176, 29)
    ..style = PaintingStyle.fill;
  MathColumn({
    this.number = 0,
    this.power = 0,
    int priority = 15,
    required this.gameStatsBloc,
  })  : _number = number,
        super(priority: priority);
  final double collisionThreshold = 30.0; // Adjust this as needed
  // text rendering const
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 16.0,
      fontFamily: 'Awesome Font',
    ),
  );
  late TextComponent numberText;
  @override
  Future<void> onLoad() async {
    paint = Paint()
      ..color = const Color.fromARGB(
          255, 233, 230, 230) // Opaque color for the outline
      ..style = PaintingStyle.stroke // Outline only
      ..strokeWidth = 2;
    await super.onLoad();
    // Initialize number based on the current blockValue in the bloc state
    _updateColumn();
    add(RectangleHitbox()
      ..size = Vector2(10, size.y)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.topCenter
      ..priority = 40);

    numberText = TextComponent(
      size: Vector2(50, 50),
      text: _number.toString(),
      position: Vector2(size.x / 2, size.y + 30), // Position text at the bottom
      anchor: Anchor.center,
    );

    add(numberText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calculate the new number
    final newNumber =
        (gameStatsBloc.state.blockValue / pow(10, power)).floor() % 10;

    // Update the text only if the number changes
    if (newNumber != _number) {
      _number = newNumber;

      // Update the text directly
      numberText.text = _number.toString();
      _updateColumn(); // Update the column based on the new number
    }
  }

  @override
  void onMount() {
    super.onMount();
    // Initialize with current bloc state after mounting
    if (isMounted) {
      _initializeWithCurrentState();
    }
  }

  void _initializeWithCurrentState() {
    // Initialize number based on the current blockValue in the bloc state
    if (!isMounted) return;
    final initialState = gameStatsBloc.state;
    number = (initialState.blockValue / pow(10, power)).floor() % 10;
  }

  dynamic correctArticle(int number) {
    if (number == 1) {
      return Constants.unitArticles[number];
    } else {
      return number;
    }
  }

  // Detects long press start
  @override
  void onLongTapDown(TapDownEvent event) {
    Utils.speak('''Cette colonne represente les ${Constants.units[power]}.
        Dix ${Constants.units[power]} égal  ${Constants.dixUnits[power]}.
        ${Constants.unitsForTenth[power]} égal dix ${Constants.oneTenthUnits[power]}.
        Dans la colonne de ${Constants.units[power]} il y a actuellement ${correctArticle(number)} ${Constants.units[power]}.

        ''', isRandom: true);
    super.onLongTapDown(event);
  }

  void onBoxDropped() {
    // Trigger any specific action here, e.g., updating score or UI
    gameStatsBloc.add(BlockEventAdded(pow(10, power).toInt()));
    print(gameStatsBloc.state.blockValue);
  }

  @override
  bool containsPoint(Vector2 point) {
    // Check if a given point is within this column's bounds
    return toRect().contains(point.toOffset());
  }

  void setHovered(bool value) {
    isHovered = value;

    fillPaint = Paint()
      ..color = isHovered
          ? const Color.fromARGB(255, 112, 150, 0)
          : const Color.fromARGB(255, 0, 176, 29)
      ..style = PaintingStyle.fill;
    print(fillPaint.color);
    position = position.clone();
    priority = isHovered ? 20 : 15;
  }

  void _updateColumn() {
    // Calculate square size
    double squareSize = size.x * 0.85;

    // Get the latest number from the bloc state
    final updatedNumber =
        (gameStatsBloc.state.blockValue / pow(10, power)).floor() % 10;

    // Clear existing cubes
    final cubesToRemove = children.whereType<Cube>().toList();
    for (final cube in cubesToRemove) {
      cube.removeFromParent(); // Remove all Cube children
    }

    // Add cubes for the updated number
    for (int i = 0; i < updatedNumber; i++) {
      add(
        Cube(
          number: 1,
          priority: 100,
          isDraggable: false, // Only make the top cube draggable
        )
          ..size = Vector2(squareSize, squareSize)
          ..position = Vector2(
            size.x / 2, // Center horizontally
            size.y -
                (squareSize * 1.2) * (i + 1) +
                squareSize / 2, // Stack vertically
          ),
      );
    }

    // Update `number` for consistency
    number = updatedNumber;

    // Reset hover state
    isHovered = false;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      fillPaint,
    );
    // Width of the outline
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    super.render(canvas);
  }
}
