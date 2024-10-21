import 'package:flutter/material.dart';
import 'dart:math';

class Measurements1 extends StatefulWidget {
  @override
  _Measurements1State createState() => _Measurements1State();
}

class _Measurements1State extends State<Measurements1> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<int> _currentOptions = [];

  final List<Map<String, dynamic>> _problems = [
    {'question': '10cmのリボンに8cmを足すと何cm？', 'answer': 18},
    {'question': '20cmの棒から5cmを切り取ると何cm？', 'answer': 15},
    {'question': '5cmのテープに3cm足すと何cm？', 'answer': 8},
    {'question': '30cmのひもから10cmを切ると何cm？', 'answer': 20},
  ];

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _isAnswered = true;
      _isCorrect = selectedAnswer == correctAnswer;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isCorrect ? '正解！' : '不正解！')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < _problems.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _isAnswered = false;
          _isCorrect = false;
        });
        _generateOptions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('全ての問題が終了しました！')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final problem = _problems[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('長さの測定'),
        centerTitle: true,
      ),
      body: Padding(
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

