import 'package:flutter/material.dart';

class ChoicesScreen extends StatefulWidget {
  const ChoicesScreen({super.key});

  @override
  State<ChoicesScreen> createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選択問題'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    // テキストや他のウィジェット
                    children: List.generate(
                      30,
                          (index) => Text(
                        'テキスト ${index + 1}',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 50.0,
              childAspectRatio: 4.5,
              children: List.generate(4, (index) {
                return ElevatedButton(
                  onPressed: () {
                    // 選択肢ボタン押下時の処理
                  },
                  child: Text('選択肢 ${index + 1}'),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                // 回答ボタン押下時の処理
              },
              child: const Text('回答'),
            ),
          ),
        ],
      ),
    );
  }
}
