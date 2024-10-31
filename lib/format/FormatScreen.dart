import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('問題形式を選んでください'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }

  Widget _buildFormatButton(BuildContext context, String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}


