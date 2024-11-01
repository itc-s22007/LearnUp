import 'package:flutter/material.dart';
import '../../models/problem.dart';
import '../../screens/results_screen.dart';

class InputScreen extends StatefulWidget {
  final List<Problem> problems;
  final Function(Problem problem, String userFormula, double userAnswer) onAnswerEntered;

  const InputScreen({
    Key? key,
    required this.problems,
    required this.onAnswerEntered,
  }) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _correctAnswersCount = 0;

  void _checkAnswer() {
    final userFormula = _formulaController.text;
    final userInput = _answerController.text;
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
      if (isCorrect) _correctAnswersCount++;
    });

    widget.onAnswerEntered(widget.problems[_currentQuestionIndex], userFormula, userAnswer);

    if (isCorrect) _showSuccessAnimation();

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
                  _formulaController.clear();
                  _answerController.clear();
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

  void _showCompletionDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          totalQuestions: widget.problems.length,
          correctAnswers: _correctAnswersCount,
          questionResults: const [],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formulaController.dispose();
    _answerController.dispose();
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
          controller: _formulaController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '式',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 20),
          readOnly: _isAnswered,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _answerController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '答えを入力してください',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
