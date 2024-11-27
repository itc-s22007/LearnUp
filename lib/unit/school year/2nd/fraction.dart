import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../screens/ChoiceResultScreen.dart';

class FractionCalculations1 extends StatefulWidget {
  const FractionCalculations1({Key? key, required String format}) : super(key: key);

  @override
  State<FractionCalculations1> createState() => _FractionCalculations1State();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      int numerator1 = random.nextInt(9) + 1;
      int denominator1 = random.nextInt(9) + 1;
      int numerator2 = random.nextInt(9) + 1;
      int denominator2 = random.nextInt(9) + 1;
      bool isAddition = random.nextBool();

      String operator = isAddition ? '+' : '-';
      String question = '$numerator1/$denominator1 $operator $numerator2/$denominator2 = ?';
      double answer;

      if (isAddition) {
        answer = (numerator1 * denominator2 + numerator2 * denominator1) /
            (denominator1 * denominator2);
      } else {
        answer = (numerator1 * denominator2 - numerator2 * denominator1) /
            (denominator1 * denominator2);
      }

      problems.add(Problem(
        question: question,
        formula: question,
        answer: double.parse(answer.toStringAsFixed(2)),
        isInputProblem: false,
      ));
    }

    return problems;
  }
}

class _FractionCalculations1State extends State<FractionCalculations1> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {
    });

    await Future.delayed(const Duration(seconds: 1));
    List<Problem> generatedProblems = FractionCalculations1.generateProblems();

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
            questionResults: [],
            onRetry: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}


