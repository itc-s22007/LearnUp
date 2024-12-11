import 'package:flutter/material.dart';
import '../../../../format/element/ChoiceScreen.dart';
import '../../../../models/problem.dart';
import '../../../../Result/QuestionResults/ChoiceResultScreen.dart';

class MultiplicationProblems extends StatefulWidget {
  final int selectedTable;

  const MultiplicationProblems({Key? key, required this.selectedTable}) : super(key: key);

  @override
  State<MultiplicationProblems> createState() => _MultiplicationProblemsState();

  static List<Problem> generateProblems(int table) {
    List<Problem> problems = [];
    for (int i = 1; i <= 10; i++) {
      String question = '$table × $i = ?';
      String formula = '$table * $i';
      double answer = (table * i).toDouble();

      problems.add(Problem(question: question, answer: answer, isInputProblem: false, formula: formula));
    }
    return problems;
  }
}

class _MultiplicationProblemsState extends State<MultiplicationProblems> {
  late List<Problem> _problems;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _problems = MultiplicationProblems.generateProblems(widget.selectedTable);
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
    return ChoiceScreen(
      problems: _problems,
      onAnswerSelected: _handleAnswerSelected,
      unit: null,
      onAnswerEntered: (Problem problem, double userAnswer) {},
    );
  }
}
