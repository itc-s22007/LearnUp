import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnup/Result/reviewResult/ReviewInputResult.dart';

import '../../../models/problem.dart';

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


  String _userFormula = "";
  String _userAnswer = "";
  bool _isFormulaMode = true;

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

  void _addInput(String value) {
    if (!_isAnswered) {
      setState(() {
        if (_isFormulaMode) {
          _userFormula += value;
        } else {
          _userAnswer += value;
        }
      });
    }
  }

  void _clearInput() {
    if (!_isAnswered) {
      setState(() {
        if (_isFormulaMode) {
          _userFormula = "";
        } else {
          _userAnswer = "";
        }
      });
    }
  }

  void _toggleInputMode() {
    setState(() {
      _isFormulaMode = !_isFormulaMode;
    });
  }


  void _addToFormula(String value) {
    if (!_isAnswered) {
      setState(() {
        _userFormula += value;
      });
    }
  }

  void _clearFormula() {
    if (!_isAnswered) {
      setState(() {
        _userFormula = "";
      });
    }
  }

  void _addAnswer(String value) {
    if (!_isAnswered) {
      setState(() {
        _userAnswer = value;
      });
    }
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 式
                      Text(
                        '式: $_userFormula',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      // 答え
                      Container(
                        width: 100, // 固定幅を設定
                        alignment: Alignment.center, // 中央揃え
                        child: Text(
                          '答え: $_userAnswer',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i <= 9; i++)
                      ElevatedButton(
                        onPressed: () => _addInput(i.toString()),
                        child: Text(
                            i.toString(), style: const TextStyle(fontSize: 20)),
                      ),
                    ElevatedButton(
                      onPressed: () => _addInput('+'),
                      child: const Text('+', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('-'),
                      child: const Text('-', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('×'),
                      child: const Text('×', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('÷'),
                      child: const Text('÷', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: _clearInput,
                      child: const Text('クリア', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: _toggleInputMode,
                      child: Text(
                        _isFormulaMode ? '現在: 式' : '現在: 答え',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
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
                      onPressed: _isAnswered ? null : _skipQuestion,
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