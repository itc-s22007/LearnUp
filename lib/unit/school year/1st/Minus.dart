import 'package:flutter/material.dart';
import 'dart:math';
import '../../../choiceQuestions/ChoiceScreen.dart';
import '../../../models/problem.dart';

class Calculations2 extends StatefulWidget {
  const Calculations2({Key? key, required String format}) : super(key: key);

  @override
  State<Calculations2> createState() => _Calculations2State();
}

class _Calculations2State extends State<Calculations2> {
  List<Problem> _problems = [];
  bool _isGenerating = true;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() async {
    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final a = Random().nextInt(9) + 1;
      final b = Random().nextInt(a);

      String question = '$a - $b = ?';
      double answer = a - b.toDouble();

      generatedProblems.add(Problem(question: question, answer: answer));
    }

    setState(() {
      _problems = generatedProblems;
      _isGenerating = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceScreen(problems: _problems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculations 2nd Grade - Subtraction'),
        centerTitle: true,
      ),
      body: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : const Text('問題を生成中...'),
      ),
    );
  }
}


