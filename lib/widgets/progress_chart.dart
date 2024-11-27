import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ProgressChart extends StatelessWidget {
  final String studentId;
  final FirestoreService _firestoreService = FirestoreService();

  ProgressChart({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getStudyProgress(studentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<FlSpot> dataPoints = [];
        snapshot.data!.docs.asMap().forEach((index, doc) {
          int score = doc['score'];
          dataPoints.add(FlSpot(index.toDouble(), score.toDouble()));
        });

        if (dataPoints.isEmpty) {
          return Center(child: Text('データがありません'));
        }

        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
            ),
          ),
        );
      },
    );
  }
}
