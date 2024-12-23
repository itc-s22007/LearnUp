import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../../../home/challenge.dart';

class NumberScreen extends StatefulWidget {
  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  List<int> plateNumbers = [];
  String equation = '';
  String message = '';
  final Random random = Random();
  int questionCount = 0;
  int correctAnswers = 0;
  Timer? timer;
  int timeRemaining = 30; // 制限時間を30秒に設定

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startNewGame() {
    questionCount = 0;
    correctAnswers = 0;
    _generatePlateNumbers();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timeRemaining = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        t.cancel();
        _nextQuestion();
      }
    });
  }

  void _generatePlateNumbers() {
    if (questionCount >= 10) {
      _endGame();
      return;
    }

    plateNumbers = List.generate(4, (_) => random.nextInt(9) + 1);
    equation = '';
    message = '';
    questionCount++;
    setState(() {});
  }

  void _addToEquation(String value) {
    setState(() {
      equation += value;
    });
  }

  void _clearLastCharacter() {
    if (equation.isNotEmpty) {
      setState(() {
        equation = equation.substring(0, equation.length - 1);
      });
    }
  }

  void _evaluateEquation() {
    try {
      final sanitizedEquation = equation.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _evaluateExpression(sanitizedEquation);
      if (result == 10) {
        correctAnswers++;
        setState(() {
          message = '正解！答えは10です！';
        });
      } else {
        setState(() {
          message = '残念！答えは $result です';
        });
      }
    } catch (e) {
      setState(() {
        message = '式が無効です';
      });
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    timer?.cancel();
    Future.delayed(const Duration(seconds: 2), () {
      _generatePlateNumbers();
      _startTimer();
    });
  }

  void _endGame() {
    timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ゲーム終了！'),
          content: Text('あなたのスコア: $correctAnswers / 10'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('もう一度プレイ'),
            ),
          ],
        );
      },
    );
  }

  num _evaluateExpression(String expression) {
    final parser = RegExp(r'(\d+|[+\-*/])');
    final tokens = parser.allMatches(expression).map((e) => e.group(0)!).toList();

    final numStack = <num>[];
    final opStack = <String>[];

    final precedence = {'+': 1, '-': 1, '*': 2, '/': 2};

    void evaluateTop() {
      final b = numStack.removeLast();
      final a = numStack.removeLast();
      final op = opStack.removeLast();

      if (op == '+') {
        numStack.add(a + b);
      } else if (op == '-') {
        numStack.add(a - b);
      } else if (op == '*') {
        numStack.add(a * b);
      } else if (op == '/') {
        numStack.add(a / b);
      }
    }

    for (final token in tokens) {
      if (int.tryParse(token) != null) {
        numStack.add(int.parse(token));
      } else if ('+-*/'.contains(token)) {
        while (opStack.isNotEmpty &&
            precedence[opStack.last]! >= precedence[token]!) {
          evaluateTop();
        }
        opStack.add(token);
      }
    }

    while (opStack.isNotEmpty) {
      evaluateTop();
    }
    return numStack.single;
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('本当に諦めますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ChallengeScreen(), // ChallengeScreenに戻る
                ));
              },
              child: const Text('はい'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('いいえ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'ナンバープレートの数字を使って式を作り、答えを10にしてください！',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '問題: $questionCount / 10',
                    style: const TextStyle(fontSize: 16, color: Colors.yellow),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '残り時間: $timeRemaining 秒',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          color: Colors.grey.shade700,
                          child: Center(
                            child: Text(
                              equation.isEmpty ? '式を作成してください！' : equation,
                              style: TextStyle(fontSize: 30, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: plateNumbers.map((number) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => _addToEquation(number.toString()),
                          child: Text(number.toString(), style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['+', '-', '×', '÷'].map((op) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => _addToEquation(op),
                        child: Text(op, style: const TextStyle(fontSize: 20)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _evaluateEquation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          '計算する',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _clearLastCharacter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          '消す',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 18,
                      color: message.contains('正解') ? Colors.green : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showQuitDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '諦める',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

