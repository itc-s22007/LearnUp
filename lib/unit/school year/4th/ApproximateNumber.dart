import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class RoundingProblems extends StatefulWidget {
  const RoundingProblems({Key? key, required String format}) : super(key: key);

  @override
  State<RoundingProblems> createState() => _RoundingProblemsState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    final roundingPositions = [10, 100, 1000]; // 十の位、百の位、千の位
    final roundingLabels = ["十の位", "百の位", "千の位"];

    for (int i = 0; i < 10; i++) {
      int number = Random().nextInt(9000) + 100; // 100から9999の範囲のランダムな整数
      int roundingIndex = Random().nextInt(roundingPositions.length);
      int roundingBase = roundingPositions[roundingIndex];
      String roundingLabel = roundingLabels[roundingIndex];

      // 四捨五入した値を計算
      int roundedNumber = (number / roundingBase).round() * roundingBase;

      String question = '$number を $roundingLabel で四捨五入すると？';
      String formula = 'round($number, $roundingBase)';

      problems.add(Problem(
        question: question,
        formula: formula,
        answer: roundedNumber.toDouble(),
        isInputProblem: false, // 選択肢形式で出題
      ));
    }
    return problems;
  }
}

class _RoundingProblemsState extends State<RoundingProblems> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = RoundingProblems.generateProblems();

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
