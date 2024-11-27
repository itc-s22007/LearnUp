import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChoiceResultsScreen extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<String> questionResults;
  final VoidCallback onRetry;

  const ChoiceResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
    required this.onRetry,
  });

  @override
  _ChoiceResultsScreenState createState() => _ChoiceResultsScreenState();
}

class _ChoiceResultsScreenState extends State<ChoiceResultsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<int, bool> _isCheckedMap = {};

  Future<void> _saveQuestionToFirebase(
      int questionNumber,
      String question,
      String correctAnswer,
      String userAnswer,
      ) async {
    await _firestore.collection('Choice_questions').add({
      'questionNumber': questionNumber,
      'question': question,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'timestamp': FieldValue.serverTimestamp(),
    });
    setState(() {
      _isCheckedMap[questionNumber] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalStars = ((widget.correctAnswers / widget.totalQuestions) * 5).round();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  const Text(
                    '成績',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.correctAnswers} / ${widget.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < totalStars ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.questionResults.length,
                itemBuilder: (context, index) {
                  final resultData = widget.questionResults[index].split(': ');
                  final isCorrect = resultData[0] == '○';
                  final questionNumber = index + 1;
                  final question = resultData[1];
                  final correctAnswer = resultData[2];
                  final userAnswer = resultData[3];

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '問$questionNumber.',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              question,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '自分の解答 | $userAnswer',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '正答 | $correctAnswer',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              isCorrect ? '○' : '×',
                              style: TextStyle(
                                fontSize: 18,
                                color: isCorrect ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Checkmark button
                          IconButton(
                            icon: Icon(
                              Icons.check,
                              color: _isCheckedMap[questionNumber] == true ? Colors.blue : Colors.grey,
                            ),
                            onPressed: () {
                              if (_isCheckedMap[questionNumber] != true) {
                                _saveQuestionToFirebase(
                                  questionNumber,
                                  question,
                                  correctAnswer,
                                  userAnswer,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, height: 20),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onRetry();
                  },
                  child: const Text('もう一度'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ホームに戻る'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

