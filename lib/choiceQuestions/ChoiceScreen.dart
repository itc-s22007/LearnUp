// lib/choiceQuestions/ChoiceScreen.dart
import 'package:flutter/material.dart';
import '../models/problem.dart';
import 'dart:math';

class ChoiceScreen extends StatefulWidget {
  final List<Problem> problems;

  const ChoiceScreen({Key? key, required this.problems}) : super(key: key);

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<double> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  // 選択肢を生成
  void _generateOptions() {
    final correctAnswer = widget.problems[_currentQuestionIndex].answer;
    _currentOptions = _generateOptionsList(correctAnswer);
  }

  List<double> _generateOptionsList(double correctAnswer) {
    List<double> options = [correctAnswer];
    Random rand = Random();

    while (options.length < 4) {
      double wrongAnswer = correctAnswer + rand.nextInt(10) - 5 + rand.nextDouble();
      wrongAnswer = double.parse(wrongAnswer.toStringAsFixed(2));
      if (wrongAnswer != correctAnswer && wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    options.shuffle();
    return options;
  }

  // 回答をチェック
  void _checkAnswer(double selectedAnswer) {
    final correctAnswer = widget.problems[_currentQuestionIndex].answer;
    bool isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
    });

    // 正解時にアニメーションを表示
    if (isCorrect) {
      _showSuccessAnimation();
    }

    // ダイアログでフィードバックを表示
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '正解！' : '不正解'),
        content: Text(isCorrect
            ? 'おめでとうございます！正解です。'
            : '残念、不正解です。正しい答えは$correctAnswerです。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ダイアログを閉じる
              if (_currentQuestionIndex < widget.problems.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _isAnswered = false;
                  _isCorrect = false;
                });
                _generateOptions();
              } else {
                // 全問終了
                _showCompletionDialog();
              }
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }

  // 正解時のアニメーション
  void _showSuccessAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('正解！'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 全問終了時のダイアログ
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('終了'),
        content: const Text('すべての問題を終えました！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ダイアログを閉じる
              Navigator.pop(context); // ChoiceScreenを閉じる
            },
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('選択問題 (${_currentQuestionIndex + 1}/${widget.problems.length})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              problem.question,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final option = _currentOptions[index];
                Color buttonColor;

                if (_isAnswered) {
                  if (option == problem.answer) {
                    buttonColor = Colors.green;
                  } else {
                    buttonColor = Colors.red;
                  }
                } else {
                  buttonColor = Colors.blue;
                }

                return ElevatedButton(
                  onPressed: _isAnswered ? null : () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../models/problem.dart';
// import 'dart:math';
//
// class ChoiceScreen extends StatefulWidget {
//   final List<Problem> problems;
//
//   const ChoiceScreen({Key? key, required this.problems}) : super(key: key);
//
//   @override
//   State<ChoiceScreen> createState() => _ChoiceScreenState();
// }
//
// class _ChoiceScreenState extends State<ChoiceScreen> {
//   int _currentQuestionIndex = 0;
//   bool _isAnswered = false;
//   bool _isCorrect = false;
//   List<double> _currentOptions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _generateOptions();
//   }
//
//   void _generateOptions() {
//     final correctAnswer = widget.problems[_currentQuestionIndex].answer;
//     _currentOptions = _generateOptionsList(correctAnswer);
//   }
//
//   List<double> _generateOptionsList(double correctAnswer) {
//     List<double> options = [correctAnswer];
//     Random rand = Random();
//
//     while (options.length < 4) {
//       double wrongAnswer = correctAnswer + rand.nextInt(10) - 5 + rand.nextDouble();
//       wrongAnswer = double.parse(wrongAnswer.toStringAsFixed(2));
//       if (wrongAnswer != correctAnswer && wrongAnswer > 0 && !options.contains(wrongAnswer)) {
//         options.add(wrongAnswer);
//       }
//     }
//
//     options.shuffle();
//     return options;
//   }
//
//   void _checkAnswer(double selectedAnswer) {
//     final correctAnswer = widget.problems[_currentQuestionIndex].answer;
//     bool isCorrect = selectedAnswer == correctAnswer;
//
//     setState(() {
//       _isAnswered = true;
//       _isCorrect = isCorrect;
//     });
//
//     if (isCorrect) {
//       _showSuccessAnimation();
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(isCorrect ? '正解！' : '不正解'),
//         content: Text(isCorrect
//             ? 'おめでとうございます！正解です。'
//             : '残念、不正解です。正しい答えは$correctAnswerです。'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               if (_currentQuestionIndex < widget.problems.length - 1) {
//                 setState(() {
//                   _currentQuestionIndex++;
//                   _isAnswered = false;
//                   _isCorrect = false;
//                 });
//                 _generateOptions();
//               } else {
//                 _showCompletionDialog();
//               }
//             },
//             child: const Text('次へ'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessAnimation() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             SizedBox(width: 10),
//             Text('正解！'),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }
//
//   // 全問終了時のダイアログ
//   void _showCompletionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('終了'),
//         content: const Text('すべての問題を終えました！'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text('ホームに戻る'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final problem = widget.problems[_currentQuestionIndex];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('選択問題 (${_currentQuestionIndex + 1}/${widget.problems.length})'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               problem.question,
//               style: const TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _currentOptions.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 15.0,
//                 crossAxisSpacing: 15.0,
//                 childAspectRatio: 3,
//               ),
//               itemBuilder: (context, index) {
//                 final option = _currentOptions[index];
//                 Color buttonColor;
//
//                 if (_isAnswered) {
//                   if (option == problem.answer) {
//                     buttonColor = Colors.green;
//                   } else {
//                     buttonColor = Colors.red;
//                   }
//                 } else {
//                   buttonColor = Colors.blue;
//                 }
//
//                 return ElevatedButton(
//                   onPressed: _isAnswered ? null : () => _checkAnswer(option),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: buttonColor,
//                   ),
//                   child: Text(
//                     option.toString(),
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
