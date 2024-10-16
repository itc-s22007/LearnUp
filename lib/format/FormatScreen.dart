import 'package:flutter/material.dart';
import '../InputQuestions/InputScreen.dart';
import '../choiceQuestions/ChoiceScreen.dart';
import '../models/problem.dart';

class FormatScreen extends StatefulWidget {
  final List<Problem> problems;

  const FormatScreen({super.key, required this.problems});

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

  void _navigateToNextScreen() {
    if (showChoice) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChoiceScreen(problems: widget.problems),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputScreen(problems: widget.problems),
        ),
      );
    }
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
