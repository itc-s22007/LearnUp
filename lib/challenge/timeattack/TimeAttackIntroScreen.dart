import 'package:flutter/material.dart';
import '../rank.dart';
import 'TimeAttackScreen.dart';

class TimeAttackIntroScreen extends StatelessWidget {
  final String operation;

  const TimeAttackIntroScreen({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイムアタックへようこそ'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'タイムアタックでは、30秒間でできるだけ多くの計算問題を解きましょう！',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '正しい答えを入力すると得点が増えます。\n間違った場合は次の問題に進みます。',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeAttackScreen(operation: operation),
                  ),
                );
              },
              child: const Text('スタート！'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RankScreen(operation: operation),
                  ),
                );
              },
              child: const Text('ランキングを見る'),
            ),
          ],
        ),
      ),
    );
  }
}
