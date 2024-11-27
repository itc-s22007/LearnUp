import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputResultsScreen extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<String> questionResults;
  final VoidCallback onRetry;

  const InputResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
    required this.onRetry,
  });

  @override
  _InputResultsScreenState createState() => _InputResultsScreenState();
}

class _InputResultsScreenState extends State<InputResultsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<int, bool> _isCheckedMap = {};

  Future<void> _saveQuestionToFirebase(int questionNumber, String question, String correctFormula, String correctAnswer, String userFormula, String userAnswer) async {
    await _firestore.collection('checked_questions').add({
      'questionNumber': questionNumber,
      'question': question,
      'correctFormula': correctFormula,
      'correctAnswer': correctAnswer,
      'userFormula': userFormula,
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
                    final questionNumber = index + 1;
                    final isCorrect = resultData.isNotEmpty && resultData[0] == '○';
                    final question = resultData.length > 1 ? resultData[1] : 'N/A';
                    final userFormula = resultData.length > 3 ? resultData[3] : 'N/A';
                    final userAnswer = resultData.length > 5 ? resultData[5] : 'N/A';
                    final correctFormula = resultData.length > 7 ? resultData[7] : 'N/A';
                    final correctAnswer = resultData.length > 9 ? resultData[9] : 'N/A';

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
                              child: Column(
                                children: [
                                  const Text(
                                    '自分の解答',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '式: $userFormula',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '答え: $userAnswer',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    '正答',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '式: $correctFormula',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '答え: $correctAnswer',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isCorrect ? '○' : '×',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isCorrect ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                          correctFormula,
                                          correctAnswer,
                                          userFormula,
                                          userAnswer,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1, height: 20),
                      ],
                    );
                  }

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