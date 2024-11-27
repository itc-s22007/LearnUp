import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class SentenceDivide extends StatefulWidget {
  final String format;
  const SentenceDivide({Key? key, required this.format}) : super(key: key);

  @override
  State<SentenceDivide> createState() => _SentenceDivideState();

  static List<Problem> generateProblems() {
    final List<String> templates = [
      '{name}は{a}こりんごを{b}にんでわけました。1にんあたり、何こずつもっているでしょうか？',
      '{name}は{a}えんぴつを{b}にんでわけました。1にんあたり、何ぼんずつわけたでしょうか？',
      '{name}は{a}個のキャンディを{b}人でわけました。1人あたりいくつもらえますか？',
    ];

    final List<String> names = ['ぎんじ', 'かに', 'りおん', 'ショーン', '上盛いしき','nyannyannyan','寺本凛'];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(100) + 1;
      final b = Random().nextInt(10) + 1;

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = (a / b).toDouble();
      String formula = '$a ÷ $b';

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

class _SentenceDivideState extends State<SentenceDivide> {
  List<Problem> _problems = [];

  @override
  void initState() {
    super.initState();
    _problems = SentenceDivide.generateProblems();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
