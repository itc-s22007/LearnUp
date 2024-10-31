import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<String> questionResults;

  const ResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成績画面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
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
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '問題結果',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: questionResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('問題 ${index + 1}'),
                    subtitle: Text('結果: ${questionResults[index]}'),
                    leading: CircleAvatar(
                      backgroundColor: questionResults[index] == '正解' ? Colors.green : Colors.red,
                      child: Text('${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
