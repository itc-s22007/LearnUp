import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../CalculationBattle/Question/ProblemProvider.dart';
import 'RealTimeResult.dart';

class RealTimeBattleScreen extends StatefulWidget {
  final String roomId;
  final bool isHost;

  const RealTimeBattleScreen({super.key, required this.roomId, required this.isHost});

  @override
  State<RealTimeBattleScreen> createState() => _RealTimeBattleScreenState();
}


class _RealTimeBattleScreenState extends State<RealTimeBattleScreen> {
  final ProblemProvider _problemProvider = ProblemProvider();
  List<String> questions = [];
  List<int> answers = [];
  int currentQuestionIndex = 0;
  String userAnswer = '';
  String opponentProgress = '0/20';
  late CollectionReference battleRoom;
  bool isCountdownActive = true;
  int countdownTime = 3;
  bool isGameReady = false;
  late StreamSubscription<DocumentSnapshot>? _battleRoomSubscription;

  @override
  void initState() {
    super.initState();
    battleRoom = FirebaseFirestore.instance.collection('battleRooms');
    _initializeGame();

    // Listen to the battle room document.
    _battleRoomSubscription = battleRoom.doc(widget.roomId).snapshots().listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        if (mounted) {
          setState(() {
            opponentProgress = '${data['player2']?['progress'] ?? 0}/20';
          });
        }

        if ((data['player1']?['progress'] ?? 0) >= 20 || (data['player2']?['progress'] ?? 0) >= 20) {
          _showGameEndAnimation();
        }
      }
    });
  }

  Future<void> _initializeGame() async {
    final problemProvider = ProblemProvider();

    if (widget.isHost) {
      final newQuestions = List.generate(20, (_) => problemProvider.generateQuestion('add'));
      final newAnswers = newQuestions.map((q) {
        final parts = q.split(' ');
        return problemProvider.calculateAnswer('add', int.parse(parts[0]), int.parse(parts[2]));
      }).toList();

      await battleRoom.doc(widget.roomId).set({
        'questions': newQuestions,
        'answers': newAnswers,
        'player1.progress': 0,
        'player2.progress': 0,
      });

      if (mounted) {
        setState(() {
          questions = newQuestions;
          answers = newAnswers;
          isGameReady = true;
        });
      }

      if (isGameReady && isCountdownActive) {
        _startCountdown();
      }
    } else {
      battleRoom.doc(widget.roomId).snapshots().listen((snapshot) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          if (mounted) {
            setState(() {
              questions = List<String>.from(data['questions'] ?? []);
              answers = List<int>.from(data['answers'] ?? []);
              isGameReady = questions.isNotEmpty && answers.isNotEmpty;
            });
          }

          if (isGameReady && isCountdownActive) {
            _startCountdown();
          }
        }
      });
    }
  }

  void _submitAnswer() {
    if (userAnswer.isEmpty) return;

    final int? parsedAnswer = int.tryParse(userAnswer);

    if (parsedAnswer != null &&
        currentQuestionIndex < answers.length &&
        parsedAnswer == answers[currentQuestionIndex]) {
      setState(() {
        currentQuestionIndex++;
        userAnswer = '';
      });

      battleRoom.doc(widget.roomId).update({
        'player1.progress': currentQuestionIndex,
      });

      // 勝敗判定: 両方が終わったらゲームを終了
      if (currentQuestionIndex >= questions.length) {
        _showGameEndAnimation();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('不正解です。もう一度挑戦してください。')),
      );
    }
  }


  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && countdownTime > 1) {
        if (mounted) {
          setState(() {
            countdownTime--;
          });
        }
        _startCountdown();
      } else {
        if (mounted) {
          setState(() {
            countdownTime = 0;
            isCountdownActive = false;
          });
        }
        _startGame();
      }
    });
  }

  void _startGame() {
    if (mounted) {
      setState(() {
        currentQuestionIndex = 0;
      });
    }
  }

  void _showGameEndAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: Text(
              '終了',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RealTimeResultScreen(roomId: widget.roomId, isHost: widget.isHost),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Cancel the countdown or any subscriptions.
    _battleRoomSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リアルタイム対戦'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '相手の進捗: $opponentProgress',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            isCountdownActive
                ? Text(
              '$countdownTime',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            )
                : isGameReady
                ? Text(
              questions.isNotEmpty
                  ? questions[currentQuestionIndex]
                  : '問題が読み込まれませんでした。',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
                : const CircularProgressIndicator(),
            const SizedBox(height: 16),
            if (!isCountdownActive)
              TextField(
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      userAnswer = value;
                    });
                  }
                },
                onSubmitted: (_) {
                  _submitAnswer();
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '答えを入力してください',
                  labelText: '回答',
                ),
              ),
            if (!isCountdownActive && questions.isNotEmpty)
              Text(
                'あなたの進捗: ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

