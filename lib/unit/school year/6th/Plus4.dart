import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class Plus4 extends StatefulWidget {
  const Plus4({Key? key, required String format}) : super(key: key);

  @override
  State<Plus4> createState() => _Calculations1State();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(9000) + 1000;
      final b = Random().nextInt(9000) + 1000;

      String question = '$a + $b = ?';
      String formula = '$a + $b';
      double answer = a + b.toDouble();

      problems.add(Problem(question: question, answer: answer, isInputProblem: false, formula: formula));
    }
    return problems;
  }
}

class _Calculations1State extends State<Plus4> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(9000) + 1000; // Generate a 4-digit number for 'a'
      final b = Random().nextInt(9000) + 1000; // Generate a 4-digit number for 'b'

      String question = '$a + $b = ?';
      String formula = '$a + $b';
      double answer = a + b.toDouble();

      generatedProblems.add(Problem(question: question, formula: formula, answer: answer, isInputProblem: false));

    }

    setState(() {
      _problems = generatedProblems;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceScreen(
          problems: _problems,
          onAnswerSelected: _handleAnswerSelected,
          unit: null, onAnswerEntered: (Problem problem, double userAnswer) {  },
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
            questionResults: [], onRetry: () {  },
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
