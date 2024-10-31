import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '/rewards_system.dart';

class RewardChart extends StatelessWidget {
  final RewardSystem rewardSystem;

  RewardChart({required this.rewardSystem});

  @override
  Widget build(BuildContext context) {
    // グラフデータの作成
    final data = [
      ChartData(1, rewardSystem.getPoints()), // ポイントをカテゴリー1とする
      ChartData(2, rewardSystem.level),       // レベルをカテゴリー2とする
    ];

    final series = [
      charts.Series<ChartData, num>(
        id: 'Rewards',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData data, _) => data.category, // num型に変更
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('報酬システムのチャート'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: charts.LineChart(
          series,
          animate: true,
          behaviors: [
            charts.ChartTitle('ポイントとレベルの推移',
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification:
                charts.OutsideJustification.start),
            charts.ChartTitle('ポイント/レベル',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                charts.OutsideJustification.middle),
            charts.ChartTitle('カテゴリー',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                charts.OutsideJustification.middle),
          ],
        ),
      ),
    );
  }
}

// ChartDataクラス
class ChartData {
  final num category; // num型に変更
  final num value;

  ChartData(this.category, this.value);
}
