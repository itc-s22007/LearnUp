import 'package:flutter/material.dart';
import '../models/problem.dart';
import 'dart:math';

class ChoiceScreen extends StatefulWidget {
  final List<Problem> problems;

  const ChoiceScreen({Key? key, required this.problems}) : super(key: key);

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<int> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  void _generateOptions() {
    final correctAnswer = widget.problems[_currentQuestionIndex].answer.toInt();
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
    final correctAnswer = widget.problems[_currentQuestionIndex].answer.toInt();
    bool isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _showSuccessAnimation();
    }

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
              if (_currentQuestionIndex < widget.problems.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _isAnswered = false;
                  _isCorrect = false;
                });
                _generateOptions();
              } else {
                _showCompletionDialog();
              }
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }

  void _showSuccessAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('せいかい！'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('終了'),
        content: const Text('すべての問題を終えました！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('選択問題 (${_currentQuestionIndex + 1}/${widget.problems.length})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              problem.question,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final option = _currentOptions[index];
                Color buttonColor;

                if (_isAnswered) {
                  if (option == problem.answer.toInt()) {
                    buttonColor = Colors.green;
                  } else {
                    buttonColor = Colors.red;
                  }
                } else {
                  buttonColor = Colors.blue;
                }

                return ElevatedButton(
                  onPressed: _isAnswered ? null : () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}