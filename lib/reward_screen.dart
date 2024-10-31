import 'package:flutter/material.dart';
import 'rewards_system.dart';
import 'package:learnup/rewardScreens/reward_chart.dart';

class RewardScreen extends StatefulWidget {
  final RewardSystem rewardSystem;

  const RewardScreen({Key? key, required this.rewardSystem}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  void initState() {
    super.initState();
    widget.rewardSystem.loadData().then((_) {
      setState(() {}); // データ読み込み後に画面を更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('報酬システム'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('現在のポイント: ${widget.rewardSystem.getPoints()}'),
            const SizedBox(height: 10),
            Text(widget.rewardSystem.getCurrentLevel()),
            const SizedBox(height: 20),
            const Text('取得したバッジ:'),
            for (var badge in widget.rewardSystem.getBadges())
              Text('- $badge'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.rewardSystem.addPoints(10); // 仮のポイント追加
                });
              },
              child: const Text('ポイントを追加'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RewardChart(rewardSystem: widget.rewardSystem),
                  ),
                );
              },
              child: const Text('チャートを表示'),
            ),
          ],
        ),
      ),
    );
  }
}
