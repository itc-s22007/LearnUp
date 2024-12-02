// lib/screens/progress_screen.dart
import 'package:flutter/material.dart';
import '../models/progress_data.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ダミーデータ (仮のデータ。後ほどFirebaseから取得する形に変更)
    final List<ProgressData> progressData = [
      ProgressData(date: DateTime(2024, 11, 20), score: 85, duration: 60),
      ProgressData(date: DateTime(2024, 11, 21), score: 90, duration: 45),
      ProgressData(date: DateTime(2024, 11, 22), score: 80, duration: 50),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('進捗管理・学習履歴')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'スコアと学習時間の推移',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ProgressChart(progressData: progressData),
            ),
          ],
        ),
      ),
    );
  }
}
