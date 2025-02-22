import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../../Result/QuestionResults/ChoiceResultScreen.dart';

class TimeAttackScreen extends StatefulWidget {
  final String operation;

  const TimeAttackScreen({super.key, required this.operation});

  @override
  State<TimeAttackScreen> createState() => _TimeAttackScreenState();
}

class _TimeAttackScreenState extends State<TimeAttackScreen> with SingleTickerProviderStateMixin {
  int currentScore = 0;
  int timeLeft = 30;
  int countdown = 3;
  String question = '';
  String userAnswer = '';
  Timer? timer;
  Timer? countdownTimer;
  final Random random = Random();
  final TextEditingController _controller = TextEditingController();
  bool isGameStarted = false;

  List<String> questionResults = [];

  late AnimationController _animationController;
  late Animation<double> _countdownAnimation;
  late Animation<double> _questionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _countdownAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _questionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    countdownTimer?.cancel();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          countdownTimer?.cancel();
          _startGame();
        }
      });
    });
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
    });
    _generateQuestion();
    _startTimer();
    _animationController.forward();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          _endGame();
        }
      });
    });
  }

  void _generateQuestion() {
    final int a;
    final int b;

    if (widget.operation == 'divide') {
      a = random.nextInt(90) + 10;
      b = random.nextInt(9) + 1;
      question = '$a ÷ $b = ?';
    } else {
      a = random.nextInt(20) + 1;
      b = random.nextInt(a) + 1;
      if (widget.operation == 'add') {
        question = '$a + $b = ?';
      } else if (widget.operation == 'subtract') {
        question = '$a - $b = ?';
      } else if (widget.operation == 'multiply') {
        question = '$a × $b = ?';
      }
    }

    userAnswer = '';
    _controller.clear();
    _animationController.reset();
    _animationController.forward();
  }

  void _checkAnswer() {
    final parts = question.split(' ');
    final int a = int.parse(parts[0]);
    final int b = int.parse(parts[2]);
    int correctAnswer;

    if (widget.operation == 'add') {
      correctAnswer = a + b;
    } else if (widget.operation == 'subtract') {
      correctAnswer = a - b;
    } else if (widget.operation == 'multiply') {
      correctAnswer = a * b;
    } else if (widget.operation == 'divide') {
      correctAnswer = a ~/ b;
    } else {
      correctAnswer = 0;
    }

    final isCorrect = int.tryParse(userAnswer) == correctAnswer;
    questionResults.add(
        '${isCorrect ? '○' : '×'}: $question: $correctAnswer: ${userAnswer.isEmpty ? '未回答' : userAnswer}');

    if (isCorrect) {
      setState(() {
        currentScore++;
      });
    }

    setState(() {
      _generateQuestion();
    });
  }

  void _endGame() async {
    final CollectionReference ranksCollection =
    FirebaseFirestore.instance.collection('ranks');

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      final userName = userDoc.data()?['userName'] ?? '不明なユーザー';

      await ranksCollection.doc(widget.operation).collection('scores').add({
        'score': currentScore,
        'userName': userName,
        'email': currentUser.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceResultsScreen(
          totalQuestions: questionResults.length,
          correctAnswers: currentScore,
          questionResults: questionResults,
          onRetry: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TimeAttackScreen(operation: widget.operation),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイムアタック'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isGameStarted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeTransition(
              opacity: _questionAnimation,
              child: Text(
                '残り時間: $timeLeft 秒',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            FadeTransition(
              opacity: _questionAnimation,
              child: Text(
                question,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
              },
              onSubmitted: (_) {
                _checkAnswer();
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '答えを入力してください',
              ),
            ),
            Text(
              '得点: $currentScore',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _countdownAnimation,
                child: Text(
                  '$countdown',
                  style: const TextStyle(
                      fontSize: 80, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '準備してください...',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
