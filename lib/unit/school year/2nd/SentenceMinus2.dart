import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class SentenceMinus2 extends StatefulWidget {
  final String format;
  const SentenceMinus2({Key? key, required this.format}) : super(key: key);

  @override
  State<SentenceMinus2> createState() => _SentenceMinusState();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は{a}個のリンゴを持っています。お母さんが{b}個のリンゴを持っていきました。今、{name}はリンゴをいくつ持っていますか？',
      '{name}は{a}本の鉛筆を持っています。友だちに{b}本の鉛筆をあげました。今、鉛筆は何本ありますか？',
      'クラスにはじめに{a}人の子どもがいます。{b}人の子どもがクラスを出ました。今、クラスには何人いますか？',
      '{name}は{a}ページの本を読みました。そのあと{b}ページを返しました。今、何ページの本を持っていますか？',
      '{name}の箱に{a}個のキャンディがあります。友だちに{b}個のキャンディをあげました。今、キャンディはいくつありますか？',
      '{name}はお菓子を{a}個持っています。友だちに{b}個あげました。今、お菓子はいくつありますか？',
      '作品展に、最初に{a}個の絵が飾ってあります。{b}個の絵が外されました。今、絵は何個飾られていますか？',
      '{name}は本棚に{a}冊の本を置いています。お父さんが{b}冊の本を持っていきました。今、本棚には何冊の本がありますか？',
      '机の上に{a}個の鉛筆削りがあります。友だちが{b}個の鉛筆削りを持っていきました。机の上には何個ありますか？',
      '{name}は毛糸を{a}巻き持っています。おばあちゃんに{b}巻きあげました。今、毛糸は何巻きありますか？'
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', '上盛いしき'];
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

class _SentenceMinusState extends State<SentenceMinus2> {
  List<Problem> _problems = [];
  @override
  void initState() {
    super.initState();
    _problems = SentenceMinus2.generateProblems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('引き算のお話もんだい(２ケタ)'),
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
