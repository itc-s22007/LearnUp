import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firestore_service.dart';

class ProgressChart extends StatelessWidget {
  final String studentId;
  final FirestoreService _firestoreService = FirestoreService();

  ProgressChart({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getStudyProgress(studentId),
      builder: (context, snapshot) {
        // Firestoreからデータを取得中
        if (!snapshot.hasData) {
          print('Firestoreからデータを取得中... スナップショットが空です');
          return const Center(child: CircularProgressIndicator());
        }

        // Firestoreにデータがない場合
        if (snapshot.data!.docs.isEmpty) {
          print('Firestoreにデータがありません');
          return const Center(child: Text('データがありません'));
        }

        // Firestoreから取得したデータをログに出力
        final docs = snapshot.data!.docs;
        print('Firestoreから取得したデータ:');
        for (var doc in docs) {
          print(doc.data());
        }

        // データポイントの作成
        final List<FlSpot> dataPoints = [];
        for (var i = 0; i < docs.length; i++) {
          final doc = docs[i];
          final score = doc['score'] as int;
          dataPoints.add(FlSpot(i.toDouble(), score.toDouble()));
        }

        // グラフを描画
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                barWidth: 3,
                dotData: FlDotData(show: true),
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: true),
          ),
        );
      },
    );
  }
}
