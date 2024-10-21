import 'package:flutter/material.dart';
import '../models/problem.dart';

class InputScreen extends StatefulWidget {
  final List<Problem> problems;

  const InputScreen({Key? key, required this.problems}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  final TextEditingController _controller = TextEditingController();

  void _checkAnswer() {
    final userInput = _controller.text;
    final userAnswer = double.tryParse(userInput);
    final correctAnswer = widget.problems[_currentQuestionIndex].answer;

    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な数値を入力してください。')),
      );
      return;
    }

    bool isCorrect = userAnswer == correctAnswer;

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
            ? 'おめでとうございます！正解です。'
            : '残念、不正解です。正しい答えは$correctAnswerです。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_currentQuestionIndex < widget.problems.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _isAnswered = false;
                  _isCorrect = false;
                  _controller.clear();
                });
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
            Text('正解！'),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProblemItem() {
    final problem = widget.problems[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '問題 ${_currentQuestionIndex + 1}/${widget.problems.length}:',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          problem.question,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '答えを入力してください',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 20),
          readOnly: _isAnswered,
          onFieldSubmitted: (_) => !_isAnswered ? _checkAnswer() : null,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isAnswered ? null : _checkAnswer,
          child: const Text('回答'),
        ),
        if (_isAnswered)
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                _isCorrect ? '正解です！' : '不正解です。',
                style: TextStyle(color: _isCorrect ? Colors.green : Colors.red),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('入力問題 (${_currentQuestionIndex + 1}/${widget.problems.length})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildProblemItem(),
      ),
    );
  }
}
