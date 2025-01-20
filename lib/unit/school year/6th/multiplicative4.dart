import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class Multiplicative4 extends StatefulWidget {
  const Multiplicative4({Key? key, required String format}) : super(key: key);

  @override
  State<Multiplicative4> createState() => _DivisionProblemsState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      final b = Random().nextInt(900) + 100;
      final a = b * (Random().nextInt(90) + 10);

      String question = '$a × $b = ?';
      String formula = '$a*$b';
      double answer = a.toDouble();

      problems.add(Problem(question: question, answer: answer, isInputProblem: false, formula: formula));
    }
    return problems;
  }
}

class _DivisionProblemsState extends State<Multiplicative4> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = Multiplicative4.generateProblems();

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
