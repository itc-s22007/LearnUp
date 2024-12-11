import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class ParenthesisProblems extends StatefulWidget {
  const ParenthesisProblems({Key? key, required String format}) : super(key: key);

  @override
  State<ParenthesisProblems> createState() => _ParenthesisProblemsState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      // ランダムな数字を生成
      int a = Random().nextInt(9) + 1; // 1～9
      int b = Random().nextInt(9) + 1; // 1～9
      int c = Random().nextInt(9) + 1; // 1～9

      // ランダムに括弧の位置を決定
      int randomPattern = Random().nextInt(2); // 0または1

      String question;
      String formula;
      double answer;

      if (randomPattern == 0) {
        // パターン1: (a + b) * c
        question = "(${a} + ${b}) × ${c} = ?";
        formula = "(${a} + ${b}) * ${c}";
        answer = (a + b) * c.toDouble();
      } else {
        // パターン2: a + (b * c)
        question = "${a} + (${b} × ${c}) = ?";
        formula = "${a} + (${b} * ${c})";
        answer = a + (b * c).toDouble();
      }

      problems.add(Problem(
        question: question,
        formula: formula,
        answer: answer,
        isInputProblem: false, // 選択肢形式
      ));
    }
    return problems;
  }
}

class _ParenthesisProblemsState extends State<ParenthesisProblems> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = ParenthesisProblems.generateProblems();

    setState(() {
      _problems = generatedProblems;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceScreen(
          problems: _problems,
          onAnswerSelected: _handleAnswerSelected,
          unit: null,
          onAnswerEntered: (Problem problem, double userAnswer) {},
        ),
      ),
    );
  }

  void _handleAnswerSelected(Problem problem, double userAnswer) {
    if (problem.answer == userAnswer) {
      _correctAnswers++;
    }

    int currentIndex = _problems.indexOf(problem);
    if (currentIndex >= 0 && currentIndex == _problems.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChoiceResultsScreen(
            correctAnswers: _correctAnswers,
            totalQuestions: _problems.length,
            questionResults: const [],
            onRetry: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}

