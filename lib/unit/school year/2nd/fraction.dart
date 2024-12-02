// import 'package:flutter/material.dart';
// import 'dart:math';
// import '../../../format/element/ChoiceScreen.dart';
// import '../../../models/problem.dart';
// import '../../../screens/ChoiceResultScreen.dart';
//
// class FractionCalculations1 extends StatefulWidget {
//   const FractionCalculations1({Key? key, required String format}) : super(key: key);
//
//   @override
//   State<FractionCalculations1> createState() => _FractionCalculations1State();
//
//   static List<Problem> generateProblems() {
//     List<Problem> problems = [];
//     Random random = Random();
//
//     for (int i = 0; i < 10; i++) {
//       // 分子と分母をランダムに生成
//       int numerator1 = random.nextInt(9) + 1; // 1〜9
//       int denominator1 = random.nextInt(9) + 1; // 1〜9
//       int numerator2 = random.nextInt(9) + 1; // 1〜9
//       int denominator2 = random.nextInt(9) + 1; // 1〜9
//       bool isAddition = random.nextBool();
//
//       String operator = isAddition ? '+' : '-';
//       String question = '$numerator1/$denominator1 $operator $numerator2/$denominator2 = ?';
//
//       // 通分処理と結果の計算
//       int commonDenominator = denominator1 * denominator2;
//       int adjustedNumerator1 = numerator1 * denominator2;
//       int adjustedNumerator2 = numerator2 * denominator1;
//
//       double answer;
//       if (isAddition) {
//         answer = (adjustedNumerator1 + adjustedNumerator2) / commonDenominator;
//       } else {
//         answer = (adjustedNumerator1 - adjustedNumerator2) / commonDenominator;
//       }
//
//       problems.add(Problem(
//         question: question,
//         formula: question,
//         answer: double.parse(answer.toStringAsFixed(2)), // 小数点以下2桁に固定
//         isInputProblem: false,
//       ));
//     }
//
//     return problems;
//   }
// }
//
// class _FractionCalculations1State extends State<FractionCalculations1> {
//   List<Problem> _problems = [];
//   int _correctAnswers = 0;
//
//   Future<void> _generateProblems() async {
//     setState(() {
//       _problems = []; // 初期化して空リストに
//     });
//
//     await Future.delayed(const Duration(seconds: 1)); // シミュレーションとして1秒待機
//
//     List<Problem> generatedProblems = FractionCalculations1.generateProblems();
//
//     setState(() {
//       _problems = generatedProblems;
//     });
//
//     // 問題が生成されてから画面遷移
//     if (_problems.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceScreen(
//             problems: _problems,
//             onAnswerSelected: _handleAnswerSelected,
//             unit: null,
//             onAnswerEntered: (Problem problem, double userAnswer) {},
//           ),
//         ),
//       );
//     }
//   }
//
//   void _handleAnswerSelected(Problem problem, double userAnswer) {
//     if ((problem.answer - userAnswer).abs() < 0.01) { // 許容誤差を考慮
//       _correctAnswers++;
//     }
//
//     int currentIndex = _problems.indexOf(problem);
//     if (currentIndex >= 0 && currentIndex == _problems.length - 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceResultsScreen(
//             correctAnswers: _correctAnswers,
//             totalQuestions: _problems.length,
//             questionResults: [],
//             onRetry: () {},
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('分数計算問題'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _generateProblems,
//           child: const Text('問題を開始'),
//         ),
//       ),
//     );
//   }
// }


