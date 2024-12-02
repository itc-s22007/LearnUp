import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/progress_data.dart';

class ProgressChartSwitch extends StatefulWidget {
  final List<ProgressData> progressData;

  const ProgressChartSwitch({Key? key, required this.progressData}) : super(key: key);

  @override
  _ProgressChartSwitchState createState() => _ProgressChartSwitchState();
}

class _ProgressChartSwitchState extends State<ProgressChartSwitch> {
  // 表示するグラフタイプを管理する変数
  bool showScoreGraph = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // スイッチボタン
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showScoreGraph = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: showScoreGraph ? Colors.blue : Colors.grey,
              ),
              child: const Text('スコア'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showScoreGraph = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !showScoreGraph ? Colors.green : Colors.grey,
              ),
              child: const Text('学習時間'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 選択されたグラフを表示
        Expanded(
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: showScoreGraph ? 10 : 1,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.progressData
                      .map((data) => FlSpot(
                      data.date.day.toDouble(),
                      showScoreGraph ? data.score.toDouble() : data.duration.toDouble()))
                      .toList(),
                  isCurved: true,
                  color: showScoreGraph ? Colors.blue : Colors.green,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
