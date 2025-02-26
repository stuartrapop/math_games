import 'dart:ui';

import 'package:first_math/geometric_suite/common/types/AbstractFlameGameClass.dart';
import 'package:first_math/geometric_suite/match_polygon/components/interface_clickable_shape.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

Future<void> simulateClick({
  required Vector2 labelPosition,
  required double pixelToUnitRatio,
  required GameWithFrameFeatures gameRef,
  required InterfaceClickableShape currentComponent,
}) async {
  currentComponent.isTapped = false;
  final hand = SpriteComponent(
    sprite: await gameRef.loadSprite('click.png'),
    size: Vector2.all(50),
    position: (labelPosition - Vector2(2, 2)) * pixelToUnitRatio,
    anchor: Anchor.center,
  );

// 🔹 Define movement effect (e.g., move slightly down and back)
  final moveEffect = MoveEffect.by(
    Vector2(2, 2) * pixelToUnitRatio,
    EffectController(duration: 1),
  );

  final darkenEffect = ColorEffect(
    const Color.fromARGB(255, 0, 0, 0),
    opacityFrom: 0,
    opacityTo: 1,
    EffectController(
      duration: 0.4,
      alternate: true,
      repeatCount: 1,
    ), // Alternate back to normal
  );
  final blinkEffect = SequenceEffect([
    OpacityEffect.to(0, EffectController(duration: 0.2)),
    OpacityEffect.to(1, EffectController(duration: 0.2)),
    OpacityEffect.to(0, EffectController(duration: 0.2)),
    OpacityEffect.to(1, EffectController(duration: 0.2)),
  ]);

  // 🔹 Wait 2 seconds before removing
  final removeAfterDelay = TimerComponent(
    period: 1,
    repeat: false,
    onTick: () => hand.removeFromParent(),
  );

  // 🔥 Chain Effects
  final sequence = SequenceEffect([
    moveEffect,
    darkenEffect,
    // blinkEffect // Move first
  ], onComplete: () {
    hand.add(removeAfterDelay);
    // After effects complete, start the timer to remove the hand
  });

  hand.add(sequence);
  currentComponent.add(hand);

  await Future.delayed(Duration(seconds: 1));
  currentComponent.toggleColor();
  await Future.delayed(Duration(milliseconds: 200));
  currentComponent.toggleColor();
  await Future.delayed(Duration(milliseconds: 200));
  currentComponent.toggleColor();
  await Future.delayed(Duration(milliseconds: 200));
  currentComponent.toggleColor();
}
