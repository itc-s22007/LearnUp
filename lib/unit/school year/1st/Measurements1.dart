import 'package:flutter/material.dart';
import 'dart:math';
import '../../../format/element/ChoiceScreen.dart';
import '../../../models/problem.dart';

class Measurements1 extends StatefulWidget {
  @override
  _Measurements1State createState() => _Measurements1State();
}

class _Measurements1State extends State<Measurements1> {
  List<Map<String, dynamic>> _problems = [];
  bool _isGenerating = true;
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<int> _currentOptions = [];

  final List<String> templates = [
    '{a}cmのリボンに{b}cmを足すと何cm？',
    '{a}cmのテープに{b}cm足すと何cm？',
    '{a}cmのひもから{b}cmを切ると何cm？',
    '{a}cmの棒から{b}cmを切り取ると何cm？',
  ];

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, dynamic>> generatedProblems = [];

    for (int i = 0; i < 10; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final a = Random().nextInt(30) + 1;
      final b = Random().nextInt(20) + 1;
      String question = template
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      int answer;
      if (template.contains('足す')) {
        answer = a + b;
      } else {
        answer = a - b;
      }

      generatedProblems.add({'question': question, 'answer': answer});
    }

    setState(() {
      _problems = generatedProblems;
      _isGenerating = false;
    });

    _generateOptions();
  }

  void _generateOptions() {
    final correctAnswer = _problems[_currentQuestionIndex]['answer'];
    _currentOptions = _generateOptionsList(correctAnswer);
  }

  List<int> _generateOptionsList(int correctAnswer) {
    List<int> options = [correctAnswer];
    Random rand = Random();
    while (options.length < 4) {
      int wrongAnswer = correctAnswer + rand.nextInt(10) - 5;
      if (wrongAnswer != correctAnswer && wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();
    return options;
  }

  void _checkAnswer(int selectedAnswer) {
    final correctAnswer = _problems[_currentQuestionIndex]['answer'];
    bool isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '正解！' : '不正解'),
        content: Text(isCorrect
            ? 'せいかいです！'
            : 'ざんねん、まちがいです。こたえは$correctAnswerです。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_currentQuestionIndex < _problems.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _isAnswered = false;
                  _isCorrect = false;
                });
                _generateOptions();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoiceScreen(problems: const [], onAnswerSelected: (Problem problem, double userAnswer) {  }, unit: null, onAnswerEntered: (Problem problem, double userAnswer) {  },),
                  ),
                );
              }
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = _problems.isNotEmpty ? _problems[_currentQuestionIndex] : {'question': ''};

    return Scaffold(
      appBar: AppBar(
        title: Text('長さの測定'),
        centerTitle: true,
      ),
      body: _isGenerating
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              problem['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: _currentOptions.map((option) {
                return ElevatedButton(
                  onPressed: _isAnswered ? null : () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: Text('$option cm', style: const TextStyle(fontSize: 18)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

