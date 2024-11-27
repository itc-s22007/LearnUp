import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> progressData;

  const ProgressChart({Key? key, required this.progressData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true), // グリッド表示
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10, // 10ごとにラベルを表示
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1, // 1データごとにラベルを表示
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= progressData.length) {
                  return const SizedBox();
                }
                return Text(
                  progressData[index]['date'].substring(5), // "11-20"形式で表示
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true), // 外枠の設定
        minY: 0, // Y軸の最小値
        maxY: 100, // Y軸の最大値
        lineBarsData: [
          LineChartBarData(
            spots: progressData
                .asMap()
                .entries
                .map((entry) => FlSpot(
              entry.key.toDouble(), // X軸
              entry.value['score'].toDouble(), // Y軸
            ))
                .toList(),
            isCurved: true, // 曲線
            barWidth: 3, // 線の太さ
            color: Colors.blue, // 線の色
            belowBarData: BarAreaData(show: false), // 線の下を塗りつぶさない
            dotData: FlDotData(show: true), // データポイントを表示
          ),
        ],
      ),
    );
  }
}
