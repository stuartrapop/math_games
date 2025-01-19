import 'dart:async';

import 'package:first_math/components/decorate_rectangle_component.dart';
import 'package:first_math/five_across/bloc/operations_bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Cell extends DecoratedRectangleComponent with HasGameRef, TapCallbacks {
  CellValue cellValue;
  final OperationsBloc operationsBloc;
  int row;
  int column;
  final int questionIndex;

  Cell({
    required this.operationsBloc,
    required this.cellValue,
    required this.row,
    required this.column,
    required this.questionIndex,
    Vector2? position,
    Vector2? scale,
    double angle = 0.0,
    Anchor anchor = Anchor.center,
    List<Component> children = const [],
    int priority = 0,
    Paint? paint,
    Key? key,
  }) : super(
          shadowOffset: Vector2(3, 3),
          shadowPaint: Paint()
            ..color = Colors.white70
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
          radius: 10,
        );
  late Paint backgroundPaint;

  @override
  FutureOr<void> onLoad() async {
    backgroundPaint = Paint()..color = Colors.white70;
    _updateCellText();
    // TODO: implement onLoad
    return super.onLoad();
  }

  bool isValidAnswer(int cellValue, List<Question> questions) {
    // Filter unanswered questions
    final unansweredQuestions = questions.where(
      (question) => question.questionStatus == QuestionStatus.unanswered,
    );

    // Check if the cellValue matches the result of any unanswered question
    return unansweredQuestions.any((question) {
      final correctAnswer = OperationsState.getQuestionValue(question);
      return cellValue == correctAnswer;
    });
  }

  void _updateCellText() async {
    children.whereType<TextComponent>().forEach(remove);
    final checkMarkSprite = await gameRef.loadSprite('check-mark.png');
    final crossSprite = await gameRef.loadSprite('cancel.png');

    if (cellValue.answerStatus == AnswerStatus.correct) {
      add(SpriteComponent(
        sprite: checkMarkSprite,
        size: Vector2(28, 28),
        position: size / 2,
      )..anchor = Anchor.center);
    } else if (cellValue.answerStatus == AnswerStatus.incorrect) {
      add(SpriteComponent(
        sprite: crossSprite,
        size: Vector2(30, 30),
        position: size / 2,
      )..anchor = Anchor.center);
    } else {
      add(TextComponent(
        textRenderer: TextPaint(
            style: TextStyle(
          fontSize: 24,
          color: isValidAnswer(cellValue.value, operationsBloc.state.questions)
              ? Colors.black
              : Colors.grey,
        )),
        text: cellValue.value.toString(),
      )
        ..anchor = Anchor.center
        ..position = size / 2);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {}

  @override
  void onTapDown(TapDownEvent event) {
    if (cellValue.answerStatus != AnswerStatus.hasNotBeenSelected ||
        !isValidAnswer(cellValue.value, operationsBloc.state.questions)) {
      return;
    }
    print(
        "is valid answer ${isValidAnswer(cellValue.value, operationsBloc.state.questions)}");
    final Question question = operationsBloc.state.questions[questionIndex];
    print(
        "Tapped down ${cellValue.value} ${OperationsState.getQuestionValue(question)}");
    operationsBloc.add(
        OnCellClick(row: row, column: column, questionIndex: questionIndex));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
