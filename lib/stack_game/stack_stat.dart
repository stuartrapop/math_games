import 'dart:async';

import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/components/sized_text_box.dart';
import 'package:first_math/utils/spelling_numbers.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StackStatHudComponent extends PositionComponent {
  late final TextComponent titleText;
  late final TextComponent valueText;
  final double hudWidth;
  final double hudHeight;
  final GameStatsBloc gameStatsBloc;
  late SizedTextBox numberInWords;
  late StreamSubscription<GameStatsState> _blocSubscription;

  StackStatHudComponent({
    required this.hudWidth,
    required this.hudHeight,
    required this.gameStatsBloc,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Title
    titleText = TextComponent(
      text: 'Stack Game',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      position: Vector2(hudWidth * 0.1, 30),
    );

    // Numeric Value
    valueText = TextComponent(
      text: 'Value: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      position: Vector2(hudWidth * 0.1, 80),
    );

    // Add components to the HudComponent
    add(titleText);
    add(valueText);
    numberInWords = SizedTextBox('', size: Vector2(200, 200))
      ..position = Vector2(hudWidth * 0.1, 130);
    add(numberInWords);

    // Listen for bloc state changes
    _blocSubscription = gameStatsBloc.stream.listen(_updateHud);
  }

  void _updateHud(GameStatsState state) {
    final formatter = NumberFormat('#,###,##0');
    final textValue = SpellingNumber(
      lang: 'fr',
      decimalSeperator: "-",
    ).convert(state.blockValue);

    // Update numeric value
    valueText.text = 'Value: ${formatter.format(state.blockValue)}';

    // Update text value
    // numberInWords.text = textValue;
    // numberInWords.redraw();
    final sizedTextBoxes = children.whereType<SizedTextBox>().toList();
    for (var textBox in sizedTextBoxes) {
      if (textBox.parent == this) {
        // Ensure the component has the correct parent
        remove(textBox);
      }
    }
    numberInWords = SizedTextBox(textValue, size: Vector2(200, 200))
      ..position = Vector2(hudWidth * 0.1, 130);
    add(numberInWords);

    // Speak the updated text
    Utils.speak(textValue, isRandom: true);
  }

  @override
  void onRemove() {
    // Cancel the subscription when the component is removed
    _blocSubscription.cancel();
    super.onRemove();
  }
}
