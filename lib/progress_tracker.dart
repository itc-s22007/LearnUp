import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart' as charts;

class ProgressData {
  final DateTime date;
  final int score;
  final int studyTime;

  ProgressData({
    required this.date,
    required this.score,
    required this.studyTime,
  });
}

class ProgressTracker extends StatefulWidget {
  final String userId;

  const ProgressTracker({Key? key, required this.userId}) : super(key: key);

  @override
  _ProgressTrackerState createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  late Future<List<charts.Series<ProgressData, DateTime>>> _progressData;

  @override
  void initState() {
    super.initState();
    _progressData = _fetchProgressData(widget.userId);
  }

  Future<List<charts.Series<ProgressData, DateTime>>> _fetchProgressData(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .orderBy('date')
        .get();

    final progressData = snapshot.docs.map((doc) {
      final data = doc.data();
      return ProgressData(
        date: (data['date'] as Timestamp).toDate(),
        score: data['score'],
        studyTime: data['studyTime'],
      );
    }).toList();

    return [
      charts.Series<ProgressData, DateTime>(
        id: '成績推移',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ProgressData progress, _) => progress.date,
        measureFn: (ProgressData progress, _) => progress.score,
        data: progressData,
      ),
      charts.Series<ProgressData, DateTime>(
        id: '学習時間',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (ProgressData progress, _) => progress.date,
        measureFn: (ProgressData progress, _) => progress.studyTime,
        data: progressData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('進捗管理'),
      ),
      body: FutureBuilder<List<charts.Series<ProgressData, DateTime>>>(
        future: _progressData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('データがありません'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '成績推移と学習時間',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: charts.TimeSeriesChart(
                    snapshot.data!,
                    animate: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
