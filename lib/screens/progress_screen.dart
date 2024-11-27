import 'package:flutter/material.dart';
import '../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  final String studentId;

  const ProgressScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('進捗管理・学習履歴'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressChart(studentId: studentId),
      ),
    );
  }
}
