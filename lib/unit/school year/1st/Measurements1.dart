import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';

class Measurements1 extends StatefulWidget {
  final String format;
  const Measurements1({Key? key, required this.format}) : super(key: key);

  @override
  _Measurements1State createState() => _Measurements1State();

  static List<Problem> generateProblem() {
    final List<String> templates = [
      '{a}cmのリボンに{b}cmを足すと何cm？',
      '{a}cmのテープに{b}cm足すと何cm？',
      '{a}cmのひもから{b}cmを切ると何cm？',
      '{a}cmの棒から{b}cmを切り取ると何cm？',
    ];
    List<Problem> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final a = Random().nextInt(20) + 1;
      final b = Random().nextInt(a) + 1;

      String question = template
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = a - b.toDouble();

      generatedProblems.add(Problem(question: question, answer: answer));
    }

    return generatedProblems;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ながさのもんだい'),
        centerTitle: true,
      ),
      body: const Center(child: Text('問題を表示するUIをここに追加')),
    );
  }
}

class _Measurements1State extends State<Measurements1> {
  List<Problem> _problems = [];
  @override
  void initState() {
    super.initState();
    _problems = Measurements1.generateProblem();
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
