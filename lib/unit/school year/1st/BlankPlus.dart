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
      problems.add(Problem(
        question: '$a + □ = $totalいくつでしょうか？',
        answer: b.toDouble(),
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
          },
          child: const Text('問題を始める'),
        ),
      ),
    );
  }
}

