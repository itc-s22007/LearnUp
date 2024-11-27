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
  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  List<String> _answerResults = [];

  @override
  void dispose() {
    _formulaController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userFormula = _formulaController.text;
    final userInput = _answerController.text;
    final userAnswer = double.tryParse(userInput);
    final currentProblem = widget.problems[_currentQuestionIndex];
    final correctAnswer = currentProblem.answer;

    if (userFormula.isEmpty || userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('式と答えを両方入力してください。')),
      );
      return;
    }

    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な数値を入力してください。')),
      );
      return;
    }

    setState(() {
      _isAnswered = true;
      _isCorrect = (userFormula == currentProblem.formula) && (userAnswer == correctAnswer);
      if (_isCorrect) _correctAnswersCount++;
      _answerResults.add(
          '${_isCorrect ? "○" : "×"}: ${currentProblem.question} : あなたの式: $userFormula : あなたの答え: $userAnswer : 正しい式: ${currentProblem.formula} : 正しい答え: $correctAnswer'
      );
    });
    widget.onAnswerEntered(currentProblem, userFormula, userAnswer);
    _showResultDialog(_isCorrect, correctAnswer, userAnswer, userFormula: userFormula);
  }

  void _showResultDialog(bool isCorrect, double correctAnswer, double userAnswer, {String? userFormula}) {
    final correctFormula = widget.problems[_currentQuestionIndex].formula;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(isCorrect ? '正解！' : '不正解'),
            content: Text(isCorrect
                ? 'おめでとうございます！正解です。'
                : '残念！\n正しい式:$correctFormula\n正しい答え:$correctAnswer\nあなたの式: $userFormula\nあなたの答え: $userAnswer'),
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
        builder: (context) =>
            ResultsScreen(
              totalQuestions: widget.problems.length,
              correctAnswers: _correctAnswersCount,
              questionResults: _answerResults,
              onRetry: _retryQuiz,
            ),
      ),
    );
  }

  void _retryQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _isAnswered = false;
      _isCorrect = false;
      _answerResults.clear();
      _formulaController.clear();
      _answerController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final currentProblem = widget.problems[_currentQuestionIndex];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  currentProblem.question,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.brown,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '問題 ${_currentQuestionIndex + 1}/${widget.problems.length}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _formulaController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                    labelText: '式を入力',
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  readOnly: _isAnswered,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _answerController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                    labelText: '答えを入力してください',
                  ),
                  style: const TextStyle(fontSize: 20),
                  readOnly: _isAnswered,
                  onFieldSubmitted: (_) => !_isAnswered ? _checkAnswer() : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isAnswered ? null : _checkAnswer,
                      child: const Text('回答'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _answerResults.add(
                            '×: ${currentProblem.question} : ${currentProblem.answer} : スキップ',
                          );
                          if (
                            _currentQuestionIndex < widget.problems.length - 1) {
                            _currentQuestionIndex++;
                            _isAnswered = false;
                            _isCorrect = false;
                            _formulaController.clear();
                            _answerController.clear();
                          } else {
                            _showCompletionDialog();
                          }
                        });
                      },
                      child: const Text('スキップ'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_isAnswered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isCorrect ? '正解です！' : '不正解です。',
                        style: TextStyle(
                            color: _isCorrect ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
