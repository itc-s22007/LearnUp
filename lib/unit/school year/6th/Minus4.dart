import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class Minus4 extends StatefulWidget {
  const Minus4({Key? key, required String format}) : super(key: key);

  @override
  State<Minus4> createState() => _Calculations2State();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(9000) + 1000;
      final b = Random().nextInt(a - 1000) + 1000;

      String question = '$a - $b = ?';
      String formula = '$a - $b';
      double answer = a - b.toDouble();

      problems.add(Problem(question: question, answer: answer, formula: formula, isInputProblem: true));
    }
    return problems;
  }
}

class _Calculations2State extends State<Minus4> {
  List<Problem> _problems = [];
  bool _isGenerating = false;
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = Minus4.generateProblems();

    setState(() {
      _problems = generatedProblems;
      _isGenerating = false;
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

    if (_problems.indexOf(problem) == _problems.length - 1) {
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
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _isGenerating ? null : _generateProblems,
          child: _isGenerating
              ? const CircularProgressIndicator()
              : const Text('Start Problems'),
        ),
      ),
    );
  }
}
