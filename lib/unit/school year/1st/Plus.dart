import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../screens/results_screen.dart';

class Calculations1 extends StatefulWidget {
  const Calculations1({Key? key, required String format}) : super(key: key);

  @override
  State<Calculations1> createState() => _Calculations1State();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(a);

      String question = '$a + $b = ?';
      double answer = a + b.toDouble();

      problems.add(Problem(question: question, answer: answer));
    }
    return problems;
  }
}

class _Calculations1State extends State<Calculations1> {
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

      String question = '$a + $b = ?';
      double answer = a + b.toDouble();

      generatedProblems.add(Problem(question: question, answer: answer));
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

    int currentIndex = _problems.indexOf(problem);
    if (currentIndex >= 0 && currentIndex == _problems.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            correctAnswers: _correctAnswers,
            totalQuestions: _problems.length,
            questionResults: [],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('たしざんのけいさん'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isGenerating
              ? const CircularProgressIndicator()
              : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'これからたしざんのけいさんをはじめます！',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _generateProblems,
                child: const Text('問題を始める'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
