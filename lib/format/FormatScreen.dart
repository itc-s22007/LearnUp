import 'package:flutter/material.dart';
import 'package:learnup/home/HomeScreen.dart';
import 'package:learnup/home/LevelScreen.dart';
import 'element/ChoiceScreen.dart';
import 'element/InputScreen.dart';
import '../unit/Unit.dart';
import '../models/problem.dart';
class FormatScreen extends StatelessWidget {
  final Unit unit;
  final List<Problem> problems;

  const FormatScreen({Key? key, required this.unit, required this.problems}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '問題の形式を選択してください',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            _buildFormatButton(context, '選択問題', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoiceScreen(problems: problems, onAnswerSelected: (problem, score) {}, onAnswerEntered: (Problem problem, double userAnswer) {  },),
                ),
              );
            }),
            const SizedBox(height: 20),
            _buildFormatButton(context, '入力問題', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputScreen(
                    problems: problems,
                    onAnswerEntered: (Problem problem, String userFormula, double userAnswer) {
                      print('User entered formula: $userFormula with answer: $userAnswer for problem: ${problem.question}');
                    },
                  ),
                ),
              );
            }),
            const Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelScreen(onLevelSelected: (selectedLevel) {}),
                      ),
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
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.brown,
                  alignment: Alignment.center,
                  child: const Text(
                    "",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFormatButton(BuildContext context, String title, VoidCallback onPressed) {
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


