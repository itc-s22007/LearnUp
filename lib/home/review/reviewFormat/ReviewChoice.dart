import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Result/reviewResult/ReviewChoiceResult.dart';

class ReviewChoice extends StatefulWidget {
  @override
  _ReviewChoiceState createState() => _ReviewChoiceState();
}

class _ReviewChoiceState extends State<ReviewChoice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _reviewQuestions = [];
  List<Map<String, dynamic>> _questionResults = [];
  bool _hasStarted = false;
  bool _isCountingDown = false;
  int _countdown = 3;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadReviewQuestions();
  }

  Future<void> _loadReviewQuestions() async {
    final snapshot = await _firestore.collection('Choice_questions').get();
    setState(() {
      _reviewQuestions = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> _submitAnswer(String selectedAnswer, Map<String, dynamic> questionData) async {
    final correctAnswer = questionData['correctAnswer'];
    final questionId = questionData['id'];
    final isCorrect = selectedAnswer == correctAnswer;

    // 結果を保存
    _questionResults.add({
      'question': questionData['question'],
      'userAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
    });

    // 次の問題または結果画面へ
    if (_currentQuestionIndex < _reviewQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewChoiceResult(
            totalQuestions: _reviewQuestions.length,
            correctAnswers: _questionResults.where((result) => result['isCorrect']).length,
            questionResults: _questionResults,
            onRetry: _retryQuiz,
          ),
        ),
      );
    }
  }


  void _retryQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_hasStarted
          ? Center(
        child: _isCountingDown
            ? Text(
          _countdown > 0 ? '$_countdown' : 'スタート！',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        )
            : ElevatedButton(
          onPressed: _startQuiz,
          child: const Text('開始'),
        ),
      )
          : _reviewQuestions.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _buildQuestionLayout(_reviewQuestions[_currentQuestionIndex]),
    );
  }

  Widget _buildQuestionLayout(Map<String, dynamic> questionData) {
    final questionNumber = questionData['questionNumber'];
    final question = questionData['question'];
    final correctAnswer = questionData['correctAnswer'];

    final options = [
      correctAnswer,
      '選択肢1',
      '選択肢2',
      '選択肢3',
    ]..shuffle();

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '問${_currentQuestionIndex + 1}: $question',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Container(
          color: Colors.brown,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 5.0,
            ),
            itemBuilder: (context, index) {
              final option = options[index];
              return ElevatedButton(
                onPressed: () => _submitAnswer(option, questionData),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}