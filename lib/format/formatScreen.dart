import 'package:flutter/material.dart';
import '../InputQuestions/InputScreen.dart';
import '../choiceQuestions/choiceScreen.dart';

class FormatScreen extends StatefulWidget {
  const FormatScreen({super.key});

  @override
  State<FormatScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FormatScreen> {
  bool showCircle = true;

  void _toggleShape() {
    setState(() {
      showCircle = !showCircle;
    });
  }

  void _navigateToNextScreen() {
    if (showCircle) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChoicesScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InputScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('形式'),
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
                key: ValueKey<bool>(showCircle),
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: showCircle ? Colors.red : Colors.blue,
                  shape: showCircle ? BoxShape.circle : BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    showCircle ? '選択問題' : '入力問題',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _toggleShape,
              child: const Text('切り替え'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToNextScreen,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('決定'),
            ),
          ],
        ),
      ),
    );
  }
}
