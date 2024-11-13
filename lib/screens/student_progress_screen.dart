import 'package:flutter/material.dart';
import '../widgets/progress_chart.dart';
import '../widgets/advice_section.dart';

class StudentProgressScreen extends StatelessWidget {
  final String studentId;

  StudentProgressScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('学習進捗管理')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('成績推移', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: ProgressChart(studentId: studentId)),
            SizedBox(height: 20),
            Text('個別アドバイス', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AdviceSection(studentId: studentId),
          ],
        ),
      ),
    );
  }
}
