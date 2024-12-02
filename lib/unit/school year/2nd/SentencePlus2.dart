import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class SentencePlus2 extends StatefulWidget {
  final String format;
  const SentencePlus2({Key? key, required this.format}) : super(key: key);

  @override
  State<SentencePlus2> createState() => _SentencePlusState();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は最初に{a}個のりんごを持っていました。お母さんがさらに{b}個のりんごをくれました。今、{name}はりんごを何個持っていますか？',
      '{name}は{a}冊の本を持っています。友だちが{b}冊の本を貸してくれました。合わせて本は何冊になりましたか？',
      '{name}は財布の中に{a}円持っています。買い物のお釣りで{b}円もらいました。財布の中には全部でいくら入っていますか？',
      'パーティーで{a}個のケーキを用意しました。さらに、{b}個のケーキを買い足しました。全部でケーキは何個ありますか？',
      '{name}のお弁当に{a}個のおにぎりが入っています。お母さんが追加で{b}個のおにぎりを作ってくれました。おにぎりは全部で何個になりましたか？',
      '{name}は最初に{a}個のチョコレートを持っていました。友だちが{b}個のチョコレートをくれました。チョコレートは全部で何個になりましたか？',
      '{name}は{a}個のボールを持っています。弟が{b}個のボールを貸してくれました。今、{name}はボールを全部で何個持っていますか？',
      '公園には{a}本の花が咲いています。さらに{b}本の花が植えられました。公園に咲いている花は全部で何本になりましたか？',
      '{name}は{a}色のクレヨンを持っています。新しいセットを買い、{b}色増えました。クレヨンは全部で何色ありますか？',
      '果物屋さんに{a}個のオレンジがあります。店員さんがさらに{b}個追加しました。オレンジは全部で何個になりましたか？',
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', 'ショーン', '上盛いしき','nyannyannyan','寺本凛'];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(90) + 10;
      final b = Random().nextInt(a) + 10;

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
        title: const Text('足し算のお話もんだい(２ケタ)'),
        centerTitle: true,
      ),
      body: const Center(child: Text('問題を表示するUIをここに追加')),
    );
  }
}

class _SentencePlusState extends State<SentencePlus2> {
  List<Problem> _problems = [];

  @override
  void initState() {
    super.initState();
    _problems = SentencePlus2.generateProblems();
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
    );
  }
}
