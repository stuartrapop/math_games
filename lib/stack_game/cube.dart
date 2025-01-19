import 'package:collection/collection.dart';
import 'package:first_math/stack_game/mathColumn.dart';
import 'package:first_math/stack_game/stack_game.dart';
import 'package:first_math/stack_game/stack_game_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Cube extends PositionComponent
    with DragCallbacks, CollisionCallbacks, HasPaint, HasGameRef<StackGame> {
  int number;
  late Vector2 initialPosition;
  bool isDraggable;
  bool _isDragged = false; // To track the drag state
  MathColumn? currentHoveredColumn;

  // Original and Dragging colors
  final Paint normalFillPaint = Paint()
    ..color = const Color.fromARGB(255, 98, 82, 189)
    ..style = PaintingStyle.fill;
  final Paint dragFillPaint = Paint()
    ..color = const Color.fromARGB(255, 71, 49, 196)
    ..style = PaintingStyle.fill;

  Cube({this.isDraggable = true, this.number = 1, int priority = 10})
      : super(
          priority: priority,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    initialPosition = position.clone();
    anchor = Anchor.center;
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (isDraggable) {
      _isDragged = true;
      add(ScaleEffect.to(Vector2(1.1, 1.1), EffectController(duration: 0.1)));
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    priority = 20;
    print("event.delta: ${event}");
    if (!isDraggable) return;
    // position.add(event.localDelta);
    position += event.localDelta; // Update position with drag delta
    checkHoverState(); // Check for hovering over a column
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isDragged = false;
    priority = 10;

    // Reset size back to original
    add(ScaleEffect.to(Vector2(1.0, 1.0), EffectController(duration: 0.1)));
    checkIfDroppedInColumn();
    priority = 10;

    // Reset hover effect when dragging ends
    if (currentHoveredColumn != null) {
      currentHoveredColumn!.setHovered(false);
      currentHoveredColumn = null;
    }
  }

  void checkHoverState() {
    // Get the RouterComponent
    final router = gameRef.children.whereType<RouterComponent>().firstOrNull;

    if (router == null) {
      print(
          'RouterComponent not found in Base10Game. Skipping hover state check.');
      return;
    }

    // Access the current route
    final currentRoute = router.currentRoute;
    if (currentRoute == null) {
      print('No current route found in RouterComponent.');
      return;
    }

    // Attempt to find StackGame within the current route's children
    final stackGame = currentRoute.children.whereType<StackGame>().firstOrNull;

    if (stackGame == null) {
      print(
          'StackGame not found within the current route. Skipping hover state check.');
      return;
    }

    // Check for hovering over MathColumn
    MathColumn? newHoveredColumn = stackGame.columns.firstWhereOrNull(
      (column) => column.containsPoint(position),
    );

    if (newHoveredColumn != currentHoveredColumn) {
      currentHoveredColumn?.setHovered(false); // Reset hover on previous column
      newHoveredColumn?.setHovered(true); // Hover new column
      currentHoveredColumn = newHoveredColumn;
    }
  }

  void checkIfDroppedInColumn() {
    // Get the RouterComponent
    final router = gameRef.children.whereType<RouterComponent>().firstOrNull;

    if (router == null) {
      print('RouterComponent not found in Base10Game. Skipping drop check.');
      animateBackToOriginalPosition();
      return;
    }

    // Access the current route
    final currentRoute = router.currentRoute;
    if (currentRoute == null) {
      print('No current route found in RouterComponent.');
      animateBackToOriginalPosition();
      return;
    }

    // Attempt to find StackGame within the current route's children
    final stackGame =
        currentRoute.children.whereType<StackGameComponent>().firstOrNull;

    if (stackGame == null) {
      print(
          'StackGame not found within the current route. Skipping drop check.');
      animateBackToOriginalPosition();
      return;
    }

    // Check if the Cube was dropped in any column
    final droppedInColumn = stackGame.columns.any((column) {
      if (column.containsPoint(position)) {
        column.onBoxDropped(); // Trigger the action for the column
        return true;
      }
      return false;
    });

    animateBackToOriginalPosition();
  }

  void animateBackToOriginalPosition() {
    add(
      MoveEffect.to(
        initialPosition,
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    // Outline paint
    final outlinePaint = Paint()
      ..color = const Color(0xFFFFFFFF) // White color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Adjust outline thickness as needed

    final fillPaint = _isDragged ? dragFillPaint : normalFillPaint;

    // Draw white outline
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      outlinePaint,
    );

    // Draw solid rectangle inside
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      fillPaint,
    );

    super.render(canvas);
  }
}
