import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../format/element/InputScreen.dart';

class SentencePlus extends StatefulWidget {
  final String format;
  const SentencePlus({Key? key, required this.format}) : super(key: key);

  @override
  State<SentencePlus> createState() => _SentencePlusState();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は{a}このリンゴをもっています。おかあさんが{b}このリンゴをくれました。いま{name}はリンゴをいくつもっていますか？',
      '{name}は{a}ほんのえんぴつをもっています。ともだちが{b}ほんのえんぴつをくれました。いまえんぴつはなんぼんありますか？',
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', 'ショーン', '上盛いしき','nyannyannyan','寺本凛'];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(20) + 1;

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = (a + b).toDouble();
      String formula = '$a + $b';

      generatedProblems.add(Problem(
        question: question,
        formula: formula,
        answer: answer,
        isInputProblem: true,
      ));
    }

    return generatedProblems;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('たしざんのおはなしもんだい'),
        centerTitle: true,
      ),
      body: const Center(child: Text('問題を表示するUIをここに追加')),
    );
  }
}

class _SentencePlusState extends State<SentencePlus> {
  List<Problem> _problems = [];

  @override
  void initState() {
    super.initState();
    _problems = SentencePlus.generateProblems();
  }

  void _handleChoiceAnswer(Problem problem, double userAnswer) {
    final correctAnswer = problem.answer;
    bool isCorrect = userAnswer == correctAnswer;
    _showResultDialog(isCorrect, correctAnswer, userAnswer);
  }

  void _handleInputAnswer(Problem problem, String userFormula, double userAnswer) {
    final correctAnswer = problem.answer;
    bool isCorrect = userAnswer == correctAnswer;
    _showResultDialog(isCorrect, correctAnswer, userAnswer, userFormula: userFormula);
  }

  void _showResultDialog(bool isCorrect, double correctAnswer, double userAnswer, {String? userFormula}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '正解！' : '不正解'),
        content: Text(
          isCorrect
              ? 'おめでとうございます！正解です。'
              : '残念、不正解です。正しい答えは$correctAnswerです。${userFormula != null ? '\nあなたの式: $userFormula' : ''}\nあなたの答え: $userAnswer',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('たしざんのおはなしもんだい'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoiceScreen(
                    problems: _problems,
                    onAnswerSelected: _handleChoiceAnswer, onAnswerEntered: (Problem problem, double userAnswer) {  },
                  ),
                ),
              );
            },
            child: const Text('選択問題へ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputScreen(
                    problems: _problems,
                    onAnswerEntered: _handleInputAnswer,
                  ),
                ),
              );
            },
            child: const Text('入力問題へ'),
          ),
        ],
      ),
    );
  }
}

