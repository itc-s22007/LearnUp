// lib/format/FormatScreen.dart
import 'package:flutter/material.dart';
import '../InputQuestions/InputScreen.dart';
import '../choiceQuestions/ChoiceScreen.dart';
import '../models/problem.dart';
import 'dart:math';

class FormatScreen extends StatefulWidget {
  const FormatScreen({super.key, required List<Problem> problems});

  @override
  State<FormatScreen> createState() => _FormatScreenState();
}

class _FormatScreenState extends State<FormatScreen> {
  bool showChoice = true; // true: 選択問題, false: 入力問題
  List<Problem> _problems = [];
  bool _isGenerating = true;

  final List<String> templates = [
    '{name}は{a}個のリンゴを持っています。{name}がさらに{b}個のリンゴを買いました。{name}は今、リンゴをいくつ持っていますか？',
    '{name}は{a}本の鉛筆を持っています。{name}が友達から{b}本の鉛筆をもらいました。{name}は今、鉛筆をいくつ持っていますか？',
    'クラスに{a}人の生徒がいます。新しく{b}人の生徒が入学しました。クラスには今、何人の生徒がいますか？',
    '{name}は{a}ページの本を読みました。次の日にさらに{b}ページ読みました。{name}は合計で何ページ読みましたか？',
    '箱に{a}本の鉛筆があります。{b}本の鉛筆が取り出されました。箱には今、鉛筆がいくつ残っていますか？'
  ];

  final List<String> names = ['アリス', 'ボブ', 'チャーリー', 'ダイアナ', 'エヴァ'];

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  void _generateProblems() async {
    // 問題生成の模擬的な遅延
    await Future.delayed(const Duration(seconds: 1));

    List<Problem> generatedProblems = [];

    for (int i = 0; i < 30; i++) {
      final template = templates[Random().nextInt(templates.length)];
      final name = names[Random().nextInt(names.length)];
      final a = Random().nextInt(20) + 1; // 1から20
      final b = Random().nextInt(20) + 1; // 1から20

      String question = template
          .replaceAll('{name}', name)
          .replaceAll('{a}', a.toString())
          .replaceAll('{b}', b.toString());

      double answer = 0;

      // 問題に応じて答えを計算（ここでは単純な加算）
      if (template.contains('リンゴ') ||
          template.contains('鉛筆') ||
          template.contains('生徒') ||
          template.contains('ページ')) {
        answer = a + b.toDouble();
      }

      generatedProblems.add(Problem(question: question, answer: answer));
    }

    setState(() {
      _problems = generatedProblems;
      _isGenerating = false;
    });
  }

  void _toggleFormat() {
    setState(() {
      showChoice = !showChoice;
    });
  }

  void _navigateToNextScreen() {
    if (_problems.isEmpty) return;

    if (showChoice) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChoiceScreen(problems: _problems),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputScreen(problems: _problems),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isGenerating) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('形式選択'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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


// import 'package:flutter/material.dart';
// import '../InputQuestions/InputScreen.dart';
// import '../choiceQuestions/ChoiceScreen.dart';
// import '../models/problem.dart';
//
// class FormatScreen extends StatefulWidget {
//   final List<Problem> problems;
//
//   const FormatScreen({super.key, required this.problems});
//
//   @override
//   State<FormatScreen> createState() => _FormatScreenState();
// }
//
// class _FormatScreenState extends State<FormatScreen> {
//   bool showChoice = true;
//
//   void _toggleFormat() {
//     setState(() {
//       showChoice = !showChoice;
//     });
//   }
//
//   void _navigateToNextScreen() {
//     if (showChoice) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceScreen(problems: widget.problems),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => InputScreen(problems: widget.problems),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('形式選択'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, animation) {
//                 return SlideTransition(
//                   position: Tween<Offset>(
//                     begin: const Offset(0, 1),
//                     end: const Offset(0, 0),
//                   ).animate(animation),
//                   child: child,
//                 );
//               },
//               child: Container(
//                 key: ValueKey<bool>(showChoice),
//                 width: 300,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   color: showChoice ? Colors.red : Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     showChoice ? '選択問題' : '入力問題',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _toggleFormat,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('切り替え'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _navigateToNextScreen,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('決定'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
