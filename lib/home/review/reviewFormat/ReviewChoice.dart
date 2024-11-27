import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewChoice extends StatefulWidget {
  @override
  _ReviewChoiceState createState() => _ReviewChoiceState();
}

class _ReviewChoiceState extends State<ReviewChoice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _reviewQuestions = [];
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
    final snapshot = await _firestore.collection('checked_questions').get();
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

  void _submitAnswer(String selectedAnswer, Map<String, dynamic> questionData) {
    final correctAnswer = questionData['correctAnswer'];
    final isCorrect = selectedAnswer == correctAnswer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '正解！' : '不正解'),
        content: Text(isCorrect
            ? 'せいかいです！'
            : 'ざんねん、まちがいです。こたえは$correctAnswerです。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_currentQuestionIndex < _reviewQuestions.length - 1) {
                  _currentQuestionIndex++;
                } else {
                  // 全ての問題が終了
                  _hasStarted = false;
                  _currentQuestionIndex = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すべての問題が終了しました！')),
                  );
                }
              });
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );



    // 次の問題に進む
    setState(() {
      if (_currentQuestionIndex < _reviewQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // 全ての問題が終了
        _hasStarted = false;
        _currentQuestionIndex = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('すべての問題が終了しました！')),
        );
      }
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
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
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
                '問$questionNumber: $question',
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
