import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/progress_data.dart';

class ProgressChart extends StatelessWidget {
  final List<ProgressData> progressData;

  const ProgressChart({Key? key, required this.progressData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 10,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(), // 左の数値ラベル
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}', // 下の数値ラベル
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        lineBarsData: [
          // スコアのグラフ
          LineChartBarData(
            spots: progressData.map((data) => FlSpot(data.date.day.toDouble(), data.score.toDouble())).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
          // 学習時間のグラフ
          LineChartBarData(
            spots: progressData.map((data) => FlSpot(data.date.day.toDouble(), data.duration.toDouble())).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
