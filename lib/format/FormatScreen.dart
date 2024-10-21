import 'package:flutter/material.dart';
import '../level/LevelScreen.dart';

class FormatScreen extends StatefulWidget {
  const FormatScreen({super.key, required List problems});

  @override
  State<FormatScreen> createState() => _FormatScreenState();
}

class _FormatScreenState extends State<FormatScreen> {
  bool showChoice = true;

  void _toggleFormat() {
    setState(() {
      showChoice = !showChoice;
    });
  }

  void _navigateToLevelScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelScreen(isChoice: showChoice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('形式選択'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: Container(
                key: ValueKey<bool>(showChoice),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: showChoice ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    showChoice ? '選択問題' : '入力問題',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _toggleFormat,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('切り替え'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToLevelScreen,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('決定'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        tooltip: '追加アクション',
        child: const Icon(Icons.add),
      ),
    );
  }
}