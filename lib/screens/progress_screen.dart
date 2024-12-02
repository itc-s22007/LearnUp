import 'package:flutter/material.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // サンプルデータ
    final scores = {
      DateTime(2024, 12, 1): 75.0,
      DateTime(2024, 12, 2): 80.0,
      DateTime(2024, 12, 3): 95.0,
    };

    final learningTimes = {
      DateTime(2024, 12, 1): 1.5,
      DateTime(2024, 12, 2): 2.0,
      DateTime(2024, 12, 3): 1.0,
    };

    return Scaffold(
      appBar: AppBar(title: Text("進捗管理・学習履歴")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressChart(scores: scores, learningTimes: learningTimes),
      ),
    );
  }
}
