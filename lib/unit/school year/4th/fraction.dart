import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class FractionAddition extends StatefulWidget {
  const FractionAddition({Key? key}) : super(key: key);

  @override
  State<FractionAddition> createState() => _FractionAdditionState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    Random rand = Random();

    for (int i = 0; i < 10; i++) {
      int numerator1 = rand.nextInt(9) + 1; // 1〜9の分子
      int denominator1 = rand.nextInt(9) + 1; // 1〜9の分母
      int numerator2 = rand.nextInt(9) + 1;
      int denominator2 = rand.nextInt(9) + 1;

      int lcm = denominator1 * denominator2; // 分母の最小公倍数（簡略化）
      int adjustedNumerator1 = numerator1 * (lcm ~/ denominator1);
      int adjustedNumerator2 = numerator2 * (lcm ~/ denominator2);
      int resultNumerator = adjustedNumerator1 + adjustedNumerator2;

      String question =
          '$numerator1/$denominator1 + $numerator2/$denominator2 = ?';
      String formula =
          '$adjustedNumerator1/$lcm + $adjustedNumerator2/$lcm = $resultNumerator/$lcm';
      double answer = resultNumerator / lcm;

      problems.add(Problem(
          question: question,
          formula: formula,
          answer: answer,
          isInputProblem: false));
    }
    return problems;
  }
}

class _FractionAdditionState extends State<FractionAddition> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = FractionAddition.generateProblems();

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

  Widget _buildFraction(int numerator, int denominator) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          numerator.toString(),
          style: const TextStyle(fontSize: 24),
        ),
        Container(
          width: 40, // 横線の幅
          height: 2, // 横線の高さ
          color: Colors.black,
          margin: const EdgeInsets.symmetric(vertical: 4),
        ),
        Text(
          denominator.toString(),
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildFractionQuestion(int numerator1, int denominator1,
      int numerator2, int denominator2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFraction(numerator1, denominator1),
        const SizedBox(width: 16),
        const Text(
          '+',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 16),
        _buildFraction(numerator2, denominator2),
      ],
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
            onRetry: _retryQuiz,
          ),
        ),
      );
    }
  }

  void _retryQuiz() {
    setState(() {
      _correctAnswers = 0;
      _problems = FractionAddition.generateProblems();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分数の足し算'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generateProblems,
          child: const Text('問題を始める'),
        ),
      ),
    );
  }
}
