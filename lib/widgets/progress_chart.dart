import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressChart extends StatefulWidget {
  final Map<DateTime, double> scores;
  final Map<DateTime, double> learningTimes;

  const ProgressChart({
    Key? key,
    required this.scores,
    required this.learningTimes,
  }) : super(key: key);

  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  bool showScores = true; // true: スコア, false: 学習時間

  @override
  Widget build(BuildContext context) {
    final data = showScores ? widget.scores : widget.learningTimes;

    return Column(
      children: [
        // タイトル部分
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              showScores ? "スコア" : "学習時間",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: showScores,
              onChanged: (value) {
                setState(() {
                  showScores = value;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        // 棒グラフ本体
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: _createBarGroups(data),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(
                        "${date.month}/${date.day}",
                        style: TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: showScores ? 10 : 1,
                    getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _createBarGroups(Map<DateTime, double> data) {
    return data.entries.map((entry) {
      final timestamp = entry.key.millisecondsSinceEpoch.toDouble();
      return BarChartGroupData(
        x: timestamp.toInt(),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}
