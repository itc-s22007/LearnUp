import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class ParenthesisWordProblems extends StatefulWidget {
  const ParenthesisWordProblems({Key? key, required String format}) : super(key: key);

  @override
  State<ParenthesisWordProblems> createState() => _ParenthesisWordProblemsState();

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    List<String> templates = [
      "1袋に {a} 個のキャンディーが入っています。{b} 袋分を買い、さらに {c} 個もらいました。全部で何個のキャンディーがありますか？",
      "{a} 個のペンがあります。{b} セットずつまとめて箱に入れた場合、{c} 箱には全部でいくつのペンが入りますか？",
      "{a} 本の花を {b} 人の友達に均等に配り、残りを {c} 倍すると、何本になりますか？",
      "{a} 人の生徒が学校にいます。それぞれの生徒が {b} 枚のカードを持っており、さらに {c} 枚ずつ追加された場合、全部で何枚のカードがありますか？",
      "{a} 階建てのビルがあります。各階には {b} 部屋があり、さらに屋上に {c} 部屋が追加されました。ビル全体で何部屋ありますか？",
      "{a} 匹の魚が池にいます。{b} 匹ずつグループに分け、さらに {c} 匹を別の池に移した場合、残りは何匹になりますか？",
      "ある工場では1時間に {a} 個の部品を作ります。{b} 時間働き、その後、さらに {c} 個の部品を作った場合、合計で何個作りましたか？",
      "{a} 人が遊園地のチケットを買いました。1人が {b} 枚の乗り物券を購入し、さらにグループ全体で {c} 枚を追加購入しました。全部で何枚の乗り物券がありますか？",
      "{a} センチメートルのリボンがあります。このリボンを {b} センチメートルずつ切り分け、残りを {c} センチメートル長くした場合、何センチメートル残りますか？",
      "{a} 個の箱に {b} 個ずつリンゴを入れました。その後、さらに {c} 個のリンゴを追加した場合、全部で何個のリンゴがありますか？",
    ];

    for (int i = 0; i < 10; i++) {
      int a = Random().nextInt(9) + 1;
      int b = Random().nextInt(9) + 1;
      int c = Random().nextInt(9) + 1;

      String template = templates[Random().nextInt(templates.length)];
      String question = template
          .replaceAll("{a}", a.toString())
          .replaceAll("{b}", b.toString())
          .replaceAll("{c}", c.toString());
      String formula = "($a×$b) + $c";
      double answer = (a * b) + c.toDouble();

      problems.add(Problem(
        question: question,
        formula: formula,
        answer: answer,
        isInputProblem: false,
      ));
    }
    return problems;
  }
}

class _ParenthesisWordProblemsState extends State<ParenthesisWordProblems> {
  List<Problem> _problems = [];
  int _correctAnswers = 0;

  void _generateProblems() async {
    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = ParenthesisWordProblems.generateProblems();

    setState(() {
      _problems = generatedProblems;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceScreen(
          problems: _problems,
          onAnswerSelected: _handleAnswerSelected,
          unit: null,
          onAnswerEntered: (Problem problem, double userAnswer) {},
        ),
      ),
    );
  }

  void _handleAnswerSelected(Problem problem, double userAnswer) {
    if (problem.answer == userAnswer) {
      _correctAnswers++;
    }

    int currentIndex = _problems.indexOf(problem);
    if (currentIndex >= 0 && currentIndex == _problems.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChoiceResultsScreen(
            correctAnswers: _correctAnswers,
            totalQuestions: _problems.length,
            questionResults: const [],
            onRetry: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}
