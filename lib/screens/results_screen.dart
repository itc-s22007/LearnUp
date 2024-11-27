import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<String> questionResults;
  final VoidCallback onRetry;

  const ResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    int totalStars = ((correctAnswers / totalQuestions) * 5).round();

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
                    '$correctAnswers / $totalQuestions',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 星の表示
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
                itemCount: questionResults.length,
                itemBuilder: (context, index) {
                  final resultData = questionResults[index].split(': ');
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
                    onRetry();
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
