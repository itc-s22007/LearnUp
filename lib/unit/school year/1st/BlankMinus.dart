import 'package:flutter/material.dart';
import 'dart:math';
import '../../../models/problem.dart';

class BlankMinus extends StatelessWidget {
  final String format;

  const BlankMinus({super.key, required this.format});

  static List<Problem> generateProblems() {
    List<Problem> problems = [];
    Random rand = Random();
    int total = rand.nextInt(16) + 5;

    Set<String> usedProblems = {};
    for (int i = 0; i < 10; i++) {
      int a;
      int b;

      do {
        a = rand.nextInt(total + 1);
        b = total - a;
      } while (usedProblems.contains('$a,$b') || b < 0);

      usedProblems.add('$a,$b');

      // `formula` を計算して定義
      String formula = '$a - $b = $total'; // ここで式を作成

      problems.add(Problem(
        question: '$a - □ = $totalいくつでしょうか？',
        answer: b.toDouble(),
        formula: formula, // formula を渡す
        isInputProblem: false, // isInputProblem を true に設定（必要に応じて変更）
      ));
    }

    return problems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなうめもんだい'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 新しい画面に遷移する際に `isInputProblem` を渡す
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NextScreen(isInputProblem: false), // isInputProblem を渡す
              ),
            );
          },
          child: const Text('問題を始める'),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final bool isInputProblem;

  const NextScreen({super.key, required this.isInputProblem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('次の画面'),
      ),
      body: Center(
        child: Text('isInputProblem: $isInputProblem'),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:math';
// import '../../../format/element/ChoiceScreen.dart';
// import '../../../models/problem.dart';
//
// class BlankMinus extends StatefulWidget {
//   const BlankMinus({super.key, required String format});
//
//   @override
//   _BlankMinusState createState() => _BlankMinusState();
//
//   static List<Problem> generateProblems() {
//     List<Problem> problems = [];
//     Random rand = Random();
//
//     int total = rand.nextInt(16) + 5;
//     for (int i = 0; i < 10; i++) {
//       int a = rand.nextInt(total + 1);
//       int b = total - a;
//       if (b >= 0) {
//         problems.add(Problem(
//           question: '$total - □ = $b いくつでしょうか？',
//           answer: a.toDouble(),
//         ));
//       }
//     }
//
//     return problems;
//   }
// }
//
// class _BlankMinusState extends State<BlankMinus> {
//   late List<List<int>> numberPairs;
//   int? lastA;
//   int total = 0;
//   Set<String> usedProblems = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _generateRandomPairs();
//   }
//
//   void _generateRandomPairs() {
//     List<List<int>> pairs = [];
//     Random rand = Random();
//
//     total = rand.nextInt(16) + 5;
//
//     while (pairs.length < 10) {
//       int a;
//
//       do {
//         a = rand.nextInt(total + 1);
//       } while (a == lastA);
//       int b = total - a;
//       if (b >= 0) {
//         String problemKey = '$total-$a';
//         if (!pairs.contains([a, b]) && !pairs.contains([b, a]) && !usedProblems.contains(problemKey)) {
//           pairs.add([a, b]);
//           usedProblems.add(problemKey);
//           lastA = a;
//         }
//       }
//     }
//
//     setState(() {
//       numberPairs = pairs;
//     });
//   }
//
//   void _startChoiceScreen() {
//     List<Problem> problems = numberPairs.map((pair) {
//       return Problem(
//         question: '$total - □ = ${pair[1]} いくつでしょうか？',
//         answer: pair[0].toDouble(),
//       );
//     }).toList();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChoiceScreen(
//           problems: problems,
//           onAnswerSelected: (Problem problem, double userAnswer) {},
//           unit: null, onAnswerEntered: (Problem problem, double userAnswer) {  },
//         ),
//       ),
//     ).then((value) {
//       if (value == true) {
//         _generateRandomPairs();
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('あなうめもんだい（引き算）'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: numberPairs.isEmpty
//               ? const CircularProgressIndicator()
//               : Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'これからあなうめもんだい（引き算）がはじまります！',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _startChoiceScreen,
//                 child: const Text('問題を始める'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

