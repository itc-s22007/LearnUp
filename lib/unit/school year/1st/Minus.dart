import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class Minus1 extends StatefulWidget {
  const Minus1({Key? key, required String format}) : super(key: key);

  @override
  State<Minus1> createState() => _Calculations2State();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(a);

      String question = '$a - $b = ?';
      String fomula = '$a - $b';
      double answer = a + b.toDouble();

      problems.add(Problem(question: question, answer: answer, formula: fomula, isInputProblem: true));
    }
    return problems;
  }
}

class _Calculations2State extends State<Minus1> {
  List<Problem> _problems = [];
  bool _isGenerating = false;
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(a);

      String question = '$a - $b = ?';
      String fomula = '$a - $b';
      double answer = a - b.toDouble();

      generatedProblems.add(Problem(question: question, answer: answer, formula: fomula, isInputProblem: false));
    }

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
          unit: null, onAnswerEntered: (Problem problem, double userAnswer) {  },
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
            questionResults: [], onRetry: () {  },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}



