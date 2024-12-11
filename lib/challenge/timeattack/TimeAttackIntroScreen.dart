import 'package:flutter/material.dart';
import '../../home/challenge.dart';
import '../rank.dart';
import 'TimeAttackScreen.dart';
import 'choose.dart';

class TimeAttackIntroScreen extends StatelessWidget {
  final String operation;

  const TimeAttackIntroScreen({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'タイムアタックでは、30秒間でできるだけ多くの計算問題を解きましょう！',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '正しい答えを入力すると得点が増えます。\n間違った場合は次の問題に進みます。',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildActionButton(
                  context,
                  'スタート！',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeAttackScreen(operation: operation),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  context,
                  'ランキングを見る',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RankScreen(operation: operation),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 85,
                          height: 20,
                          color: Colors.black87,
                          margin: const EdgeInsets.only(right: 5),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: Colors.brown,
                            width: 50,
                            height: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 73,
                          height: 7,
                          margin: const EdgeInsets.only(right: 10),
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
