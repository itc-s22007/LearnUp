import 'package:flutter/material.dart';

class ReviewChoiceResult extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<Map<String, dynamic>> questionResults;
  final VoidCallback onRetry;

  const ReviewChoiceResult({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
    required this.onRetry
  });

  @override
  _ReviewChoiceResultState createState() => _ReviewChoiceResultState();
}

class _ReviewChoiceResultState extends State<ReviewChoiceResult> {

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
            // 問題ごとの結果表示部分
            Expanded(
              child: ListView.builder(
                itemCount: widget.questionResults.length,
                itemBuilder: (context, index) {
                  final result = widget.questionResults[index];
                  final questionNumber = index + 1;
                  final question = result['question'] ?? 'N/A';
                  final userAnswer = result['userAnswer'] ?? 'N/A';
                  final correctAnswer = result['correctAnswer'] ?? 'N/A';
                  final isCorrect = result['isCorrect'] ?? false;

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
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  userAnswer,
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
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  correctAnswer,
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
                              ],
                            ),
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
            // ボタン部分
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
