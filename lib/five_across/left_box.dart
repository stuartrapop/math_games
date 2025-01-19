import 'dart:async';

import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:first_math/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LeftBox extends PositionComponent {
  final OperationsBloc operationsBloc;
  int questionIndex;

  LeftBox({
    required this.questionIndex,
    required this.operationsBloc,
  });

  @override
  Color backgroundColor() => const Color(0xFFeeeeee);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    print("LeftBox onLoad");
    print("${TextStyle().fontFamily}");
    addQuestionToBoard();
    return super.onLoad();
  }

  void addQuestionToBoard() {
    if (questionIndex == -1) {
      return;
    }
    final Question question = operationsBloc.state.questions[questionIndex];
    TextComponent firstText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text: question.firstNumber.toString(),
    )
      ..anchor = Anchor.centerRight
      ..position = Vector2(size.x / 2 + 10, 70);
    add(firstText);
    TextComponent secondText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text: question.secondNumber.toString(),
    )
      ..anchor = Anchor.centerRight
      ..position = Vector2(size.x / 2 + 10, 105);
    add(secondText);
    TextComponent operatorText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text: getOperatorString(question.operator),
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2 - 35, 105);
    add(operatorText);
    final line = RectangleComponent(
      paint: Paint()
        ..color = Colors.white
        ..strokeWidth = 2,
    )
      ..position = Vector2(size.x / 2 + 25, 125)
      ..size = Vector2(70, 2)
      ..anchor = Anchor.topRight;
    add(line);
    TextComponent questionMarkText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text: "?",
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, 150);
    add(questionMarkText);

    TextComponent correctAnswersText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text:
          "Corrects : ${operationsBloc.state.boardValues.expand((element) => element).where((element) => element.answerStatus == AnswerStatus.correct).length}",
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, 340);
    add(correctAnswersText);
    TextComponent falseAnswersText = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      text:
          "Fausses : ${operationsBloc.state.boardValues.expand((element) => element).where((element) => element.answerStatus == AnswerStatus.incorrect).length}",
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, 365);
    add(falseAnswersText);
  }

  String getOperatorString(Operator operator) {
    switch (operator) {
      case Operator.addition:
        return "+";
      case Operator.subtraction:
        return "-";
      case Operator.multiplication:
        return "x";
      case Operator.division:
        return "/";
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      fillRed,
    );
    super.render(canvas);
  }
}
