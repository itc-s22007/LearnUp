import 'package:flutter/material.dart';
import 'dart:math';
import '../models/problem.dart';
import '../format/FormatScreen.dart';

class MathProblemGenerator extends StatefulWidget {
  const MathProblemGenerator({super.key});

  @override
  State<MathProblemGenerator> createState() => _MathProblemGeneratorState();
}

class _MathProblemGeneratorState extends State<MathProblemGenerator> {
  List<Problem> _problems = [];
  bool _isGenerating = false;

  final List<String> templates = [
    '{name}は{a}個のリンゴを持っています。{name}がさらに{b}個のリンゴを買いました。{name}は今、リンゴをいくつ持っていますか？',
    '{name}は{a}本の鉛筆を持っています。{name}が友達から{b}本の鉛筆をもらいました。{name}は今、鉛筆をいくつ持っていますか？',
    'クラスに{a}人の生徒がいます。新しく{b}人の生徒が入学しました。クラスには今、何人の生徒がいますか？',
    '{name}は{a}ページの本を読みました。次の日にさらに{b}ページ読みました。{name}は合計で何ページ読みましたか？',
    '箱に{a}本の鉛筆があります。{b}本の鉛筆が取り出されました。箱には今、鉛筆がいくつ残っていますか？'
  ];

  final List<String> names = ['ぎんじ', 'ちばりゅう', 'りおん', 'ショーン', '上盛いしき'];

  void _generateProblems() {
    setState(() {
      _isGenerating = true;
    });

    List<Problem> generatedProblems = [];

    for (int i = 0; i < 30; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(20) + 1; // 1から20
      final b = Random().nextInt(20) + 1; // 1から20

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = 0;

      if (template.contains('リンゴ') ||
          template.contains('鉛筆') ||
          template.contains('生徒') ||
          template.contains('ページ')) {
        answer = a + b.toDouble();
      }

      generatedProblems.add(Problem(question: question, answer: answer));
    }

    setState(() {
      _problems = generatedProblems;
      _isGenerating = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormatScreen(problems: _problems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('問題集'),
        centerTitle: true,
      ),
      body: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _generateProblems,
          child: const Text('30問を生成'),
        ),
      ),
    );
  }
}

