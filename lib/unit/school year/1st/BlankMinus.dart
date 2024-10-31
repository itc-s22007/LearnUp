import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';

class BlankMinus extends StatefulWidget {
  const BlankMinus({super.key, required String format});

  @override
  _BlankMinusState createState() => _BlankMinusState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    Random rand = Random();

    int total = rand.nextInt(16) + 5;
    for (int i = 0; i < 10; i++) {
      int a = rand.nextInt(total + 1);
      int b = total - a;
      if (b >= 0) {
        problems.add(Problem(
          question: '$total - □ = $b いくつでしょうか？',
          answer: a.toDouble(),
        ));
      }
    }

    return problems;
  }
}

class _BlankMinusState extends State<BlankMinus> {
  late List<List<int>> numberPairs;
  int? lastA;
  int total = 0;
  Set<String> usedProblems = {};

  @override
  void initState() {
    super.initState();
    _generateRandomPairs();
  }

  void _generateRandomPairs() {
    List<List<int>> pairs = [];
    Random rand = Random();

    total = rand.nextInt(16) + 5;

    while (pairs.length < 10) {
      int a;

      do {
        a = rand.nextInt(total + 1);
      } while (a == lastA);
      int b = total - a;
      if (b >= 0) {
        String problemKey = '$total-$a';
        if (!pairs.contains([a, b]) && !pairs.contains([b, a]) && !usedProblems.contains(problemKey)) {
          pairs.add([a, b]);
          usedProblems.add(problemKey);
          lastA = a;
        }
      }
    }

    setState(() {
      numberPairs = pairs;
    });
  }

  void _startChoiceScreen() {
    List<Problem> problems = numberPairs.map((pair) {
      return Problem(
        question: '$total - □ = ${pair[1]} いくつでしょうか？',
        answer: pair[0].toDouble(),
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceScreen(
          problems: problems,
          onAnswerSelected: (Problem problem, double userAnswer) {},
          unit: null, onAnswerEntered: (Problem problem, double userAnswer) {  },
        ),
      ),
    ).then((value) {
      if (value == true) {
        _generateRandomPairs();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなうめもんだい（引き算）'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: numberPairs.isEmpty
              ? const CircularProgressIndicator()
              : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'これからあなうめもんだい（引き算）がはじまります！',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startChoiceScreen,
                child: const Text('問題を始める'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

