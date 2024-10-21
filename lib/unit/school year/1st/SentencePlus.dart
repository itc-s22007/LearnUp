import 'package:flutter/material.dart';
import 'dart:math';
import '../../../choiceQuestions/ChoiceScreen.dart';
import '../../../models/problem.dart';

class SentencePlus extends StatefulWidget {
  const SentencePlus({Key? key, required String format}) : super(key: key);

  @override
  State<SentencePlus> createState() => _Calculations1State();
}

class _Calculations1State extends State<SentencePlus> {
  List<Problem> _problems = [];
  bool _isGenerating = true;

  final List<String> templates = [
    '{name}は{a}このリンゴをもっています。おかあさんが{b}このリンゴをくれました。いま{name}はリンゴをいくつもっていますか？',
    '{name}は{a}ほんのえんぴつをもっています。ともだちが{b}ほんのえんぴつをくれました。いまえんぴつはなんぼんありますか？',
    'クラスにはじめに{a}にんのこどもがいます。あたらしく{b}にんのこどもがクラスにきました。いま、クラスにはなんにんいますか？',
    '{name}は{a}ページのほんをよみました。つぎの日に{b}ページよみました。ぜんぶでなんページよみましたか？',
    '{name}のはこに{a}このキャンディがあります。ともだちからさらに{b}このキャンディをもらいました。いま、キャンディはいくつありますか？',
    '{name}はおかしを{a}こもっています。ともだちに{b}こもらいました。いま、おかしはいくつありますか？',
    'さくひんてんに、さいしょに{a}このえがかざってあります。さらに{b}このえがかざられました。いま、えはなんこかざられていますか？',
    '{name}はほんだなに{a}さつのほんをおいています。おとうさんが{b}さつのほんをあたえました。ぜんぶでほんはなんさつありますか？',
    'つくえのうえに{a}このえんぴつけずりがあります。おかあさんが{b}このえんぴつけずりをもってきました。つくえのうえにはなんこありますか？',
    '{name}はけいとを{a}まきもっています。ばあばがさらに{b}まきあげました。いま、けいとはなんまきありますか？'
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

      double answer = a + b.toDouble();

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
        title: const Text('Calculations 1st Grade'),
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

