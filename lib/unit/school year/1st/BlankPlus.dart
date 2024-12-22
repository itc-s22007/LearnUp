import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class BlankPlus extends StatelessWidget {
  final String format;

  const BlankPlus({super.key, required this.format});

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    Random rand = Random();
    int total = rand.nextInt(16) + 5;

    Set<String> usedProblems = {};
    for (int i = 0; i < 10; i++) {
      int a;
      int b;

      do {
        a = rand.nextInt(total + 1);
        b = total - a;
      } while (usedProblems.contains('$a,$b') || b < 0);

      usedProblems.add('$a,$b');

      // `formula` を計算して追加
      String formula = '$a + $b = $total'; // ここで計算式を定義

      problems.add(Problem(
        question: '$a + □ = $totalいくつでしょうか？',
        answer: b.toDouble(),
        formula: formula, // formula を渡す
        isInputProblem: false, // 必要に応じて適切な値を渡す
      ));
    }

    return problems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなうめもんだい'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ここで新しい画面に遷移する際に、`isInputProblem` を渡す
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NextScreen(isInputProblem: false), // isInputProblem を渡す
              ),
            );
          },
          child: const Text('問題を始める'),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final bool isInputProblem;

  const NextScreen({super.key, required this.isInputProblem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('次の画面'),
      ),
      body: Center(
        child: Text('isInputProblem: $isInputProblem'),
      ),
    );
  }
}

