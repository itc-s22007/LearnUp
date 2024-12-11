import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnup/Result/reviewResult/ReviewInputResult.dart';

class ReviewInput extends StatefulWidget {
  @override
  _ReviewInputState createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _reviewQuestions = [];
  List<Map<String, dynamic>> _questionResults = [];
  int _correctAnswers = 0;
  bool _hasStarted = false;
  bool _isCountingDown = false;
  int _countdown = 3;
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;

  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReviewQuestions();
  }

  Future<void> _loadReviewQuestions() async {
    final snapshot = await _firestore.collection('input_questions').get();
    setState(() {
      _reviewQuestions = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _startQuiz() async {
    setState(() {
      _isCountingDown = true;
    });

    for (int i = _countdown; i > 0; i--) {
      setState(() {
        _countdown = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isCountingDown = false;
      _hasStarted = true;
    });
  }

  void _checkAnswer() {
    if (_isAnswered) return;

    final currentQuestion = _reviewQuestions[_currentQuestionIndex];
    final correctFormula = currentQuestion['correctFormula'] ?? '';
    final correctAnswer = currentQuestion['correctAnswer'] ?? '';
    final userFormula = _formulaController.text.trim();
    final userAnswer = _answerController.text.trim();

    final isCorrect = userAnswer == correctAnswer;
    _questionResults.add({
      'result': isCorrect ? '正解' : '不正解',
      'question': currentQuestion['question'],
      'userFormula': userFormula,
      'correctFormula': correctFormula,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
    });

    if (isCorrect) _correctAnswers++;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '正解！' : '不正解'),
        content: Text(isCorrect
            ? 'せいかいです！'
            : 'ざんねん、まちがいです。\n正しい式: $correctFormula\n正しい答え: $correctAnswer'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex++;
                _formulaController.clear();
                _answerController.clear();
                _isAnswered = false;

                if (_currentQuestionIndex >= _reviewQuestions.length) {
                  _showResultsScreen();
                }
              });
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }

  void _skipQuestion() {
    setState(() {
      final currentQuestion = _reviewQuestions[_currentQuestionIndex];
      final correctFormula = currentQuestion['correctFormula'] ?? 'なし';
      final correctAnswer = currentQuestion['correctAnswer'] ?? 'なし';

      _questionResults.add({
        'result': 'スキップ',
        'question': currentQuestion['question'],
        'userFormula': 'なし',
        'correctFormula': correctFormula,
        'userAnswer': 'なし',
        'correctAnswer': correctAnswer,
      });

      _currentQuestionIndex++;
      _formulaController.clear();
      _answerController.clear();
      _isAnswered = false;

      if (_currentQuestionIndex >= _reviewQuestions.length) {
        _showResultsScreen();
      }
    });
  }


  void _showResultsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewInputResult(
          totalQuestions: _reviewQuestions.length,
          correctAnswers: _correctAnswers,
          questionResults: _questionResults,
          onRetry: _retryQuiz,
        ),
      ),
    );
  }

  void _retryQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _questionResults.clear();
      _hasStarted = false;
    });
  }

  void _addOperator(String operator) {
    _formulaController.text = _formulaController.text + operator;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStarted) {
      return Scaffold(
        body: Center(
          child: _isCountingDown
              ? Text(
            _countdown > 0 ? '$_countdown' : 'スタート！',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )
              : ElevatedButton(
            onPressed: _startQuiz,
            child: const Text('開始'),
          ),
        ),
      );
    }

    if (_reviewQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentProblem = _reviewQuestions[_currentQuestionIndex];

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
                  currentProblem['question'] ?? '問題なし',
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
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '問題 ${_currentQuestionIndex + 1}/${_reviewQuestions.length}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    for (var operator in ['+', '-', '×', '÷'])
                      ElevatedButton(
                        onPressed: !_isAnswered ? () => _addOperator(operator) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(
                              side: BorderSide(color: Colors.black, width: 1)),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Text(
                          operator,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                  ],
                ),
              ],
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
              readOnly: _isAnswered,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                labelText: '答えを入力してください',
              ),
              onFieldSubmitted: (_) => !_isAnswered ? _checkAnswer() : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: !_isAnswered ? _checkAnswer : null,
                  child: const Text('答え合わせ'),
                    ),
                    ElevatedButton(
                      onPressed: !_isAnswered ? _skipQuestion : null,
                      child: const Text('スキップ'),
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