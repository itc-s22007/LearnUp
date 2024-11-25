import 'package:flutter/material.dart';

class ProblemSelectionScreen extends StatelessWidget {
  const ProblemSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('問題選択'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '選択したい問題の種類を選んでください:',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathProblemScreen(type: '計算問題')),
                );
              },
              child: const Text('計算問題'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathProblemScreen(type: '文章問題')),
                );
              },
              child: const Text('文章問題'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathProblemScreen(type: '図形問題')),
                );
              },
              child: const Text('図形問題'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathProblemScreen(type: 'お金の計算')),
                );
              },
              child: const Text('お金の計算'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathProblemScreen(type: '計算式穴埋め')),
                );
              },
              child: const Text('計算式穴埋め'),
            ),
          ],
        ),
      ),
    );
  }
}

class MathProblemScreen extends StatelessWidget {
  final String type;

  const MathProblemScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),
      body: Center(
        child: Text('ここに$typeの問題が表示されます。'),
      ),
    );
  }
}
