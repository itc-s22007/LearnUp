import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class SentenceMinus extends StatefulWidget {
  final String format;
  const SentenceMinus({Key? key, required this.format}) : super(key: key);

  @override
  State<SentenceMinus> createState() => _SentenceMinusState();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は{a}このリンゴをもっています。おかあさんが{b}このリンゴをもっていきました。いま{name}はリンゴをいくつもっていますか？',
      '{name}は{a}ほんのえんぴつをもっています。ともだちに{b}ほんのえんぴつをあげました。いまえんぴつはなんぼんありますか？',
      'クラスにはじめに{a}にんのこどもがいます。{b}にんのこどもがクラスをでました。いま、クラスにはなんにんいますか？',
      '{name}は{a}ページのほんをよみました。そのあと{b}ページをかえしました。いま、なんページのほんをもっていますか？',
      '{name}のはこに{a}このキャンディがあります。ともだちに{b}このキャンディをあげました。いま、キャンディはいくつありますか？',
      '{name}はおかしを{a}こもっています。ともだちに{b}こあげました。いま、おかしはいくつありますか？',
      'さくひんてんに、さいしょに{a}このえがかざってあります。{b}このえがはずされました。いま、えはなんこかざられていますか？',
      '{name}はほんだなに{a}さつのほんをおいています。おとうさんが{b}さつのほんをもっていきました。いま、ほんだなにはなんさつのほんがありますか？',
      'つくえのうえに{a}このえんぴつけずりがあります。ともだちが{b}このえんぴつけずりをもっていきました。つくえのうえにはなんこありますか？',
      '{name}はけいとを{a}まきもっています。ばあばに{b}まきあげました。いま、けいとはなんまきありますか？'
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', '上盛いしき'];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(9) + 1;
      final b = Random().nextInt(a) + 1;

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = a - b.toDouble();
      String formula = '$a - $b';

      generatedProblems.add(Problem(question: question, answer: answer, formula: formula, isInputProblem: true));
    }

    return generatedProblems;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ひきざんのおはなしもんだい'),
        centerTitle: true,
      ),
      body: const Center(child: Text('問題を表示するUIをここに追加')),
    );
  }
}

class _SentenceMinusState extends State<SentenceMinus> {
  List<Problem> _problems = [];
  @override
  void initState() {
    super.initState();
    _problems = SentenceMinus.generateProblems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ひきざんのおはなしもんだい'),
        centerTitle: true,
      ),
      body: _problems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _problems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_problems[index].question),
          );
        },
      ),
    );
  }
}
