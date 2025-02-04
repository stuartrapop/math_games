import 'dart:async';

import 'package:collection/collection.dart';
import 'package:first_math/components/sized_text_box.dart';
import 'package:first_math/match_game/bloc/match_stats_bloc.dart';
import 'package:first_math/match_game/feedback_message.dart';
import 'package:first_math/match_game/firework_animation.dart';
import 'package:first_math/match_game/right_card.dart';
import 'package:first_math/utils/constants.dart';
import 'package:first_math/utils/spelling_numbers.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class LeftCard extends PositionComponent
    with
        TapCallbacks,
        DragCallbacks,
        CollisionCallbacks,
        FlameBlocReader<MatchStatsBloc, MatchStatsState>,
        HasPaint,
        HasGameRef,
        HasVisibility {
  int number;
  late Vector2 initialPosition;
  bool isDraggable;
  bool hasFinished = false;
  double t = 0;
  RouterComponent router;

  late final StreamSubscription<MatchStatsState> _blocSubscription;

  LeftCard({
    required this.router,
    this.isDraggable = true,
    this.number = 1,
  }) : super();

  @override
  Future<void> onLoad() async {
    priority = 100;
    super.onLoad();
    initialPosition = position.clone();
    anchor = Anchor.center;
    add(RectangleHitbox(priority: 40)
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.topLeft);
    isVisible = bloc.state.leftVisible[number];
  }

  @override
  void onMount() {
    super.onMount();
    // Subscribe to the bloc's state changes
    _blocSubscription = bloc.stream.listen((state) {
      // Update visibility whenever the bloc's leftVisible changes
      isVisible = state.leftVisible[number];
    });
  }

  @override
  void update(double dt) async {
    super.update(dt);
    priority = 100;
    bool test = true;

    for (int i = 0; i < bloc.state.leftVisible.length; i++) {
      if (bloc.state.leftVisible[i] == true) {
        test = false;
      }
    }
    hasFinished = test;
    if (hasFinished) {
      // if (parent?.children != null) {
      //   parent?.removeAll(parent!.children);
      // }
      showFeedback("Bravo, tu as gagné !!!", Colors.red);
      await Future.delayed(Duration(seconds: 2), () {
        router.pushOverlay("game-over");
      });
      t += dt;
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (isDraggable) {
      add(ScaleEffect.to(Vector2(1.1, 1.1), EffectController(duration: 0.1)));
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isDraggable) {
      position.add(event.delta);
    }
    super.onDragUpdate(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    String numberText = SpellingNumber(
      lang: 'fr',
      decimalSeperator: "-",
    ).convert(bloc.state.leftValues[number]);
    print("tapped on left card $numberText");
    print("state ${bloc.state}");
    Utils.speak(numberText, isRandom: true);
    final textBox = SizedTextBox(
      numberText,
      size: Vector2(500, 499),
      timePerChar: 0.1,
      fontSize: 50,
    )..position = Vector2(300, 700);
    gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
      child.removeFromParent();
    });
    gameRef.world.add(textBox);
    Future.delayed(Duration(seconds: 3), () {
      gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
        child.removeFromParent();
      });
    });

    super.onTapDown(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 10;
    add(ScaleEffect.to(Vector2(1.0, 1.0), EffectController(duration: 0.1)));

    // Check if it overlaps with a right card and their values match
    final rightCard = _getMatchingRightCard();
    if (rightCard != null &&
        bloc.state.rightValues[rightCard.number] ==
            bloc.state.leftValues[number]) {
      // Show "Super" text, play sound, and animate fireworks if matched
      gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
        child.removeFromParent();
      });
      showFeedback("Super", Colors.green);
      Utils.speak("super", isRandom: true);

      // this.isVisible = false;
      List<bool> updatedLeftVisibility = List.from(bloc.state.leftVisible);
      updatedLeftVisibility[number] = false;
      bloc.add(LeftCardVisibilityUpdate(updatedLeftVisibility));
      // Remove LeftCard from screenWindow
      List<bool> updatedRightVisibility = List.from(bloc.state.rightVisible);
      updatedRightVisibility[rightCard.number] = false;
      bloc.add(RightCardVisibilityUpdate(
          updatedRightVisibility)); // Remove RightCard from screenWindow

      // Add firework animation (placeholder example)
      add(FireworkAnimation()..position = position.clone());
    } else {
      if (rightCard != null) {
        // Show "Essaie encore" if not matched and return to original position
        gameRef.world.children.whereType<SizedTextBox>().forEach((child) {
          child.removeFromParent();
        });
        showFeedback("Essaie encore", Colors.red);
        Utils.speak("Essaie encore", isRandom: true);
        MatchStatsState.empty();
      }
    }
    animateBackToOriginalPosition();
    print("LeftCard: ${bloc.state.leftVisible}");
  }

  RightCard? _getMatchingRightCard() {
    // Find all RightCard components
    final matchingCard = parent?.children.firstWhereOrNull((child) {
      if (child is RightCard) {
        // Check if the RightCard overlaps with this LeftCard
        final overlap = child.toRect().overlaps(toRect());
        return overlap;
      }
      return false;
    });

    return matchingCard as RightCard?;
  }

  void showFeedback(String text, Color color) {
    final feedbackMessage = FeedbackMessage(message: text)
      ..position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2)
      ..size = Vector2(600, 900)
      ..anchor = Anchor.center;

    gameRef.world.add(feedbackMessage);
    Future.delayed(
        const Duration(seconds: 2), feedbackMessage.removeFromParent);
  }

  void animateBackToOriginalPosition() {
    add(MoveEffect.to(
      initialPosition,
      EffectController(duration: 0.5, curve: Curves.easeOut),
    ));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      fillBlue,
    );
    text25White.render(canvas, "${bloc.state.leftValues[number]}",
        Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center);
    super.render(canvas);
  }
}
