import 'package:flutter/material.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  final String studentId;

  const ProgressScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // サンプルデータ
    final List<Map<String, dynamic>> progressData = [
      {'date': '2024-11-20', 'score': 85},
      {'date': '2024-11-21', 'score': 90},
      {'date': '2024-11-22', 'score': 80},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('進捗管理・学習履歴'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ProgressChart(progressData: progressData),
            ),
          ],
        ),
      ),
    );
  }
}