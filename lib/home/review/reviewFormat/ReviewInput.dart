import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewInput extends StatefulWidget {
  const ReviewInput({Key? key}) : super(key: key);

  @override
  State<ReviewInput> createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0;
  bool _isLoading = true;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<Map<String, dynamic>> _problems = [];
  List<String> _answerResults = [];

  @override
  void initState() {
    super.initState();
    _fetchProblems();
  }

  @override
  void dispose() {
    _formulaController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _fetchProblems() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wordProblems')
          .get();
      setState(() {
        _problems = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  void _checkAnswer() {
    final userFormula = _formulaController.text;
    final userInput = _answerController.text;
    final userAnswer = double.tryParse(userInput);
    final currentProblem = _problems[_currentQuestionIndex];
    final correctAnswer = currentProblem['answer'];
    final correctFormula = currentProblem['formula'];

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
      _isCorrect = (userFormula == correctFormula) && (userAnswer == correctAnswer);
      if (_isCorrect) _correctAnswersCount++;
      _answerResults.add(
        '${_isCorrect ? "○" : "×"}: ${currentProblem['question']} : '
            'あなたの式: $userFormula : あなたの答え: $userAnswer : '
            '正しい式: $correctFormula : 正しい答え: $correctAnswer',
      );
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _problems.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _isCorrect = false;
        _formulaController.clear();
        _answerController.clear();
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('結果'),
        content: Text('正解数: $_correctAnswersCount/${_problems.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_problems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('問題が見つかりませんでした。')),
      );
    }

    final currentProblem = _problems[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('文章問題 - 入力形式'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '問題 ${_currentQuestionIndex + 1}/${_problems.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              currentProblem['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _formulaController,
              decoration: const InputDecoration(
                labelText: '式を入力してください',
                border: OutlineInputBorder(),
              ),
              readOnly: _isAnswered,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: '答えを入力してください',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              readOnly: _isAnswered,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _isAnswered ? null : _checkAnswer,
                  child: const Text('回答'),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: const Text('次へ'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isAnswered)
              Text(
                _isCorrect ? '正解です！' : '不正解です。',
                style: TextStyle(
                  fontSize: 18,
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
