import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class SentenceMultiplicative extends StatefulWidget {
  final String format;
  const SentenceMultiplicative({Key? key, required this.format}) : super(key: key);

  @override
  State<SentenceMultiplicative> createState() => _SentenceMultiplicative();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は{a}匹の犬を飼っています。1匹につき{b}個ずつおやつをあげます。いま{name}はおやつをいくつあげることができますか？',
      '{name}は{a}本の鉛筆を持っています。友達{b}人に同じ数ずつ配ると、全部で何本の鉛筆が必要ですか？',
      '{name}は1日に{a}ページの本を読みます。{b}日間で何ページ読むことになりますか？',
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', 'ショーン', '上盛いしき'];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(10) + 1;

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = (a * b).toDouble();
      String formula = '$a × $b';

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
    return const Scaffold(
      );
  }
}

class _SentenceMultiplicative extends State<SentenceMultiplicative> {

  @override
  void initState() {
    super.initState();
    _generateNewProblems();
  }

  void _generateNewProblems() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
