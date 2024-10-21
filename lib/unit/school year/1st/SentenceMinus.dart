import 'package:flutter/material.dart';
import 'package:learnup/unit/school%20year/1st/SentencePlus.dart';
import 'dart:math';
import '../../../choiceQuestions/ChoiceScreen.dart';
import '../../../models/problem.dart';

class SentenceMinus extends StatefulWidget {
  const SentenceMinus({super.key, required String format});

  @override
  State<SentenceMinus> createState() => _Calculations1State();
}

class _Calculations1State extends State<SentenceMinus> {
  List<Problem> _problems = [];
  bool _isGenerating = true;

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

  final List<String> names = ['ぎんじ', 'かに', 'りおん', 'ショーン', '上盛いしき'];

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() async {
    await Future.delayed(const Duration(seconds: 1));

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
        title: const Text('Calculations 1st Grade (Subtraction)'),
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

