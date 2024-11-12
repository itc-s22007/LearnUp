import 'package:flutter/material.dart';
import '../../models/problem.dart';
import '../../screens/results_screen.dart';

class InputScreen extends StatefulWidget {
  final List<Problem> problems;
  final Function(Problem problem, String userFormula, double userAnswer) onAnswerEntered;

  const InputScreen({
    Key? key,
    required this.problems,
    required this.onAnswerEntered,
  }) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  int _correctAnswersCount = 0;
  List<String> _answerResults = [];

  void _checkAnswer() {
    final userFormula = _formulaController.text;
    final userInput = _answerController.text;
    final userAnswer = double.tryParse(userInput);
    final correctAnswer = widget.problems[_currentQuestionIndex].answer;

    // Check if both formula and answer are entered
    if (userFormula.isEmpty || userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('式と答えを両方入力してください。')),
      );
      return;
    }

    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な数値を入力してください。')),
      );
      return;
    }

    bool isCorrect = userAnswer == correctAnswer;

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      if (isCorrect) _correctAnswersCount++;
    });

    widget.onAnswerEntered(widget.problems[_currentQuestionIndex], userFormula, userAnswer);

    _answerResults.add(
        '${isCorrect ? "○" : "×"}: ${widget.problems[_currentQuestionIndex].question} : $correctAnswer : $userAnswer');

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
              Navigator.pop(context);
              if (_currentQuestionIndex < widget.problems.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _isAnswered = false;
                  _isCorrect = false;
                  _formulaController.clear();
                  _answerController.clear();
                });
              } else {
                _showCompletionDialog();
              }
            },
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          totalQuestions: widget.problems.length,
          correctAnswers: _correctAnswersCount,
          questionResults: _answerResults,
          onRetry: _retryQuiz,
        ),
      ),
    );
  }

  void _retryQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _isAnswered = false;
      _isCorrect = false;
      _answerResults.clear();
    });
  }

  Widget _buildProblemItem() {
    final problem = widget.problems[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '問題 ${_currentQuestionIndex + 1}/${widget.problems.length}:',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _formulaController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(),
            labelText: '式',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 20),
          readOnly: _isAnswered,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _answerController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(),
            labelText: '答えを入力してください',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 20),
          readOnly: _isAnswered,
          onFieldSubmitted: (_) => !_isAnswered ? _checkAnswer() : null,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isAnswered ? null : _checkAnswer,
              child: const Text('回答'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // スキップされた場合、正解と判定せず、間違えた結果として記録
                  _answerResults.add(
                    '×: ${widget.problems[_currentQuestionIndex].question} : ${widget.problems[_currentQuestionIndex].answer} : スキップ',
                  );
                  if (_currentQuestionIndex < widget.problems.length - 1) {
                    _currentQuestionIndex++;
                    _isAnswered = false;
                    _isCorrect = false;
                    _formulaController.clear();
                    _answerController.clear();
                  } else {
                    _showCompletionDialog();
                  }
                });
              },
              child: const Text('スキップ'),
            ),
          ],
        ),
        if (_isAnswered)
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                _isCorrect ? '正解です！' : '不正解です。',
                style: TextStyle(color: _isCorrect ? Colors.green : Colors.red),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _formulaController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.problems[_currentQuestionIndex].question,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.brown,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              children: [
                _buildProblemItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//完全解答なし
// import 'package:flutter/material.dart';
// import '../../models/problem.dart';
// import '../../screens/results_screen.dart';
//
// class InputScreen extends StatefulWidget {
//   final List<Problem> problems;
//   final Function(Problem problem, String userFormula, double userAnswer) onAnswerEntered;
//
//   const InputScreen({
//     Key? key,
//     required this.problems,
//     required this.onAnswerEntered,
//   }) : super(key: key);
//
//   @override
//   State<InputScreen> createState() => _InputScreenState();
// }
//
// class _InputScreenState extends State<InputScreen> {
//   int _currentQuestionIndex = 0;
//   bool _isAnswered = false;
//   bool _isCorrect = false;
//   final TextEditingController _formulaController = TextEditingController();
//   final TextEditingController _answerController = TextEditingController();
//   int _correctAnswersCount = 0;
//   List<String> _answerResults = [];
//
//   void _checkAnswer() {
//     final userFormula = _formulaController.text;
//     final userInput = _answerController.text;
//     final userAnswer = double.tryParse(userInput);
//     final correctAnswer = widget.problems[_currentQuestionIndex].answer;
//
//     if (userAnswer == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('有効な数値を入力してください。')),
//       );
//       return;
//     }
//
//     bool isCorrect = userAnswer == correctAnswer;
//
//     setState(() {
//       _isAnswered = true;
//       _isCorrect = isCorrect;
//       if (isCorrect) _correctAnswersCount++;
//     });
//
//     widget.onAnswerEntered(widget.problems[_currentQuestionIndex], userFormula, userAnswer);
//
//     _answerResults.add(
//         '${isCorrect ? "○" : "×"}: ${widget.problems[_currentQuestionIndex].question} : $correctAnswer : $userAnswer');
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
//                   _formulaController.clear();
//                   _answerController.clear();
//                 });
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
//   void _showCompletionDialog() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResultsScreen(
//           totalQuestions: widget.problems.length,
//           correctAnswers: _correctAnswersCount,
//           questionResults: _answerResults,
//           onRetry: _retryQuiz,
//         ),
//       ),
//     );
//   }
//
//   void _retryQuiz() {
//     setState(() {
//       _currentQuestionIndex = 0;
//       _correctAnswersCount = 0;
//       _isAnswered = false;
//       _isCorrect = false;
//       _answerResults.clear();
//     });
//   }
//
//   Widget _buildProblemItem() {
//     final problem = widget.problems[_currentQuestionIndex];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '問題 ${_currentQuestionIndex + 1}/${widget.problems.length}:',
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: _formulaController,
//           decoration: const InputDecoration(
//             filled: true,
//             fillColor: Colors.white70,
//             border: OutlineInputBorder(),
//             labelText: '式',
//           ),
//           keyboardType: TextInputType.text,
//           style: const TextStyle(fontSize: 20),
//           readOnly: _isAnswered,
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: _answerController,
//           decoration: const InputDecoration(
//             filled: true,
//             fillColor: Colors.white70,
//             border: OutlineInputBorder(),
//             labelText: '答え',
//           ),
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           style: const TextStyle(fontSize: 20),
//           readOnly: _isAnswered,
//           onFieldSubmitted: (_) => !_isAnswered ? _checkAnswer() : null,
//         ),
//
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _isAnswered ? null : _checkAnswer,
//               child: const Text('回答'),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   // スキップされた場合、正解と判定せず、間違えた結果として記録
//                   _answerResults.add(
//                     '×: ${widget.problems[_currentQuestionIndex].question} : ${widget.problems[_currentQuestionIndex].answer} : スキップ',
//                   );
//                   if (_currentQuestionIndex < widget.problems.length - 1) {
//                     _currentQuestionIndex++;
//                     _isAnswered = false;
//                     _isCorrect = false;
//                     _formulaController.clear();
//                     _answerController.clear();
//                   } else {
//                     _showCompletionDialog();
//                   }
//                 });
//               },
//               child: const Text('スキップ'),
//             ),
//           ],
//         ),
//         if (_isAnswered)
//           Row(
//             children: [
//               Icon(
//                 _isCorrect ? Icons.check_circle : Icons.cancel,
//                 color: _isCorrect ? Colors.green : Colors.red,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 _isCorrect ? '正解です！' : '不正解です。',
//                 style: TextStyle(color: _isCorrect ? Colors.green : Colors.red),
//               ),
//             ],
//           ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _formulaController.dispose();
//     _answerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               color: Colors.green,
//               padding: const EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.problems[_currentQuestionIndex].question,
//                       style: const TextStyle(fontSize: 20, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.brown,
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//             child: Column(
//               children: [
//                 _buildProblemItem(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
