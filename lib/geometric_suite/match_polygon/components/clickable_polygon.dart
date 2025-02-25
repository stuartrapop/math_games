import 'package:first_math/geometric_suite/common/components/BasePolygon.dart';
import 'package:first_math/geometric_suite/match_polygon/data/questions.dart';
import 'package:first_math/geometric_suite/match_polygon/match_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ClickablePolygon extends BasePolygon with HasGameRef<MatchGame> {
  int polygonIndex;
  Function? updateActivePolygonIndex;
  ClickablePolygon({
    required super.vertices,
    this.updateActivePolygonIndex,
    double pixelToUnitRatio = 50,
    double borderWidth = 1.0,
    super.innerVertices,
    super.flipHorizontal,
    super.flipVertical,
    super.scaleWidth,
    super.scaleHeight,
    super.rotation,
    Vector2? upperLeftPosition,
    super.color,
    this.polygonIndex = -1,
  }) : super(
          upperLeftPosition: upperLeftPosition,
          pixelToUnitRatio: pixelToUnitRatio,
          borderWidth: borderWidth,
        ) {
    position = (upperLeftPosition ?? Vector2.zero()) * pixelToUnitRatio;
  }
  @override
  ClickablePolygon copyWith({
    List<Vector2>? vertices,
    List<Vector2>? innerVertices,
    Color? color,
    double? scaleWidth,
    double? scaleHeight,
    double? rotation,
    Vector2? position,
    Vector2? size,
    bool? flipHorizontal,
    bool? flipVertical,
    Vector2? upperLeftPosition,
    double? pixelToUnitRatio,
    double? borderWidth,
    int? polygonIndex,
    Function? updateActivePolygonIndex,
  }) {
    // ✅ Ensure updated ratio is applied before computations
    final double newPixelToUnitRatio =
        pixelToUnitRatio ?? this.pixelToUnitRatio;

    // ✅ Ensure upperLeftPosition is correctly updated
    final Vector2 newUpperLeftPosition =
        upperLeftPosition ?? this.upperLeftPosition ?? Vector2.zero();

    // ✅ Compute new position
    final Vector2 updatedPosition = newUpperLeftPosition * newPixelToUnitRatio;

    ClickablePolygon copiedPolygon = ClickablePolygon(
      updateActivePolygonIndex:
          updateActivePolygonIndex ?? this.updateActivePolygonIndex,
      vertices: vertices ?? this.vertices.map((v) => v.clone()).toList(),
      innerVertices:
          innerVertices ?? this.innerVertices.map((v) => v.clone()).toList(),
      pixelToUnitRatio: newPixelToUnitRatio, // ✅ Apply new ratio
      upperLeftPosition: newUpperLeftPosition,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
      scaleWidth: scaleWidth ?? this.scaleWidth,
      scaleHeight: scaleHeight ?? this.scaleHeight,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      borderWidth: borderWidth ?? this.borderWidth,
      polygonIndex: polygonIndex ?? this.polygonIndex,
    )..position = updatedPosition;

    // print("borderWidth: $borderWidth");
    // 🔥 Recalculate adjusted vertices
    copiedPolygon.initializeAdjustedVertices();
    return copiedPolygon;
  }

  bool isTapped = false;

  @override
  Future<void> onLoad() {
    initializeAdjustedVertices();
    return super.onLoad();
  }

  void updatePaints() {
    fillPaint.color = color;
    outerPaint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0, 1],
      colors: [Color.alphaBlend(color.withOpacity(0.8), Colors.white), color],
    ).createShader(polygonPath.getBounds());
  }

  void resetColor() {
    isTapped = false;
    color = Colors.transparent;
    updatePaints();
  }

  void demoClick({required Vector2 labelPosition}) async {
    final hand = SpriteComponent(
      sprite: await gameRef.loadSprite('hand100.png'),
      size: Vector2.all(50),
      position: (labelPosition - Vector2(2, 2)) * pixelToUnitRatio,
      anchor: Anchor.center,
    );

// 🔹 Define movement effect (e.g., move slightly down and back)
    final moveEffect = MoveEffect.by(
      Vector2(2, 2) * pixelToUnitRatio,
      EffectController(duration: 1),
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
      blinkEffect // Move first
    ], onComplete: () {
      hand.add(removeAfterDelay);
      // After effects complete, start the timer to remove the hand
    });

    hand.add(sequence);
    add(hand);
    isTapped = false;
    Future.delayed(Duration(seconds: 1), () {
      toggleColor();
      Future.delayed(Duration(milliseconds: 200), () {
        toggleColor();
        Future.delayed(Duration(milliseconds: 200), () {
          toggleColor();
          Future.delayed(Duration(milliseconds: 200), () {
            toggleColor();
          });
        });
      });
    });
  }

  void toggleColor() {
    isTapped = !isTapped;
    color = isTapped ? question1.target.color : Colors.transparent;
    updatePaints();
  }

  @override
  void onTapDown(TapDownEvent event) {
    print("tap on polygon");

    if (updateActivePolygonIndex != null) {
      updateActivePolygonIndex!(polygonIndex);
    }

    super.onTapDown(event);
  }
}
