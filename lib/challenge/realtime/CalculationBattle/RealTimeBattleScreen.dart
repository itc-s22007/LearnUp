import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import '../CalculationBattle/Question/ProblemProvider.dart';
import 'RealTimeResult.dart';

class RealTimeBattleScreen extends StatefulWidget {
  final String roomId;
  final bool isHost;

  const RealTimeBattleScreen({super.key, required this.roomId, required this.isHost});

  @override
  State<RealTimeBattleScreen> createState() => _RealTimeBattleScreenState();
}

class _RealTimeBattleScreenState extends State<RealTimeBattleScreen>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _animationController;
  late Animation<double> _starAnimation;
  bool showStars = false;
  Color feedbackColor = Colors.white;

  @override
  void initState() {
    super.initState();
    battleRoom = FirebaseFirestore.instance.collection('battleRooms');
    _initializeGame();

    _battleRoomSubscription = battleRoom.doc(widget.roomId).snapshots().listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        if (mounted) {
          setState(() {
            opponentProgress = '${data['player2']?['progress'] ?? 0}/20';
          });
        }
        if ((data['player1']?['progress'] ?? 0) >= 20 ||
            (data['player2']?['progress'] ?? 0) >= 20) {
          _showGameEndAnimation();
        }
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _starAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
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
        feedbackColor = Colors.green;
        showStars = true;
      });
      _animationController.forward(from: 0);
      battleRoom.doc(widget.roomId).update({
        'player1.progress': currentQuestionIndex,
      });
      if (currentQuestionIndex >= questions.length) {
        _showGameEndAnimation();
      }
    } else {
      setState(() {
        feedbackColor = Colors.red;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('不正解です。もう一度挑戦してください。')),
      );
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && countdownTime > 1) {
        setState(() {
          countdownTime--;
        });
        _startCountdown();
      } else {
        setState(() {
          countdownTime = 0;
          isCountdownActive = false;
        });
        _startGame();
      }
    });
  }

  void _startGame() {
    setState(() {
      currentQuestionIndex = 0;
    });
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
    _battleRoomSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (isCountdownActive)
                  FadeTransition(
                    opacity: _starAnimation,
                    child: Text(
                      '$countdownTime',
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.yellow),
                    ),
                  )
                else
                  Text(
                    questions.isNotEmpty ? questions[currentQuestionIndex] : '問題がありません',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                if (!isCountdownActive)
                  Column(
                    children: [
                      TextField(
                        onChanged: (value) => setState(() => userAnswer = value),
                        onSubmitted: (_) => _submitAnswer(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: '答えを入力してください',
                          fillColor: feedbackColor,
                          filled: true,
                          prefixIcon: const Icon(Icons.edit),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'あなたの進捗: ${currentQuestionIndex + 1}/${questions.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
            if (showStars)
              Align(
                alignment: Alignment.topCenter,
                child: ScaleTransition(
                  scale: _starAnimation,
                  child: const Icon(Icons.star, size: 100, color: Colors.yellow),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
