import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressChart extends StatelessWidget {
  final String studentId; // ここでstudentIdを受け取る

  const ProgressChart({Key? key, required this.studentId}) : super(key: key); // コンストラクタもstudentIdを受け取るように修正

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true), // 目盛りを表示
          titlesData: FlTitlesData(show: true), // タイトルの表示
          borderData: FlBorderData(show: true), // ボーダーの設定
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 1),
                FlSpot(2, 4),
                FlSpot(3, 2),
              ],
              isCurved: true,
              color: Colors.blue, // colorプロパティで指定
              dotData: FlDotData(show: false), // 点を非表示に
              belowBarData: BarAreaData(show: false), // グラフ下部の領域を非表示
            ),
          ],
        ),
      ),
    );
  }
}
