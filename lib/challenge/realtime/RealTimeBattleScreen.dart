import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Question/ProblemProvider.dart';
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
  int currentQuestionIndex = 19;
  String userAnswer = '';
  String opponentProgress = '0/20';
  late CollectionReference battleRoom;

  @override
  void initState() {
    super.initState();
    battleRoom = FirebaseFirestore.instance.collection('battleRooms');
    _initializeGame();

    battleRoom.doc(widget.roomId).snapshots().listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          opponentProgress = '${data['player2']?['progress'] ?? 0}/20';
        });

        if ((data['player1']?['progress'] ?? 0) >= 20 || (data['player2']?['progress'] ?? 0) >= 20) {
          _showGameEndAnimation();
        }
      }
    });
  }

  Future<void> _initializeGame() async {
    final roomData = await battleRoom.doc(widget.roomId).get();

    if (widget.isHost) {
      final newQuestions = List.generate(20, (_) => _problemProvider.generateQuestion('add'));
      final newAnswers = newQuestions.map((q) {
        final parts = q.split(' ');
        return _problemProvider.calculateAnswer('add', int.parse(parts[0]), int.parse(parts[2]));
      }).toList();

      await battleRoom.doc(widget.roomId).update({
        'questions': newQuestions,
        'answers': newAnswers,
      });

      setState(() {
        questions = newQuestions;
        answers = newAnswers;
      });
    } else {
      setState(() {
        questions = List<String>.from(roomData['questions']);
        answers = List<int>.from(roomData['answers']);
      });
    }
  }

  void _submitAnswer() {
    if (userAnswer.isEmpty) return;

    final int? parsedAnswer = int.tryParse(userAnswer);
    if (parsedAnswer == answers[currentQuestionIndex]) {
      setState(() {
        currentQuestionIndex++;
        userAnswer = '';
      });

      battleRoom.doc(widget.roomId).update({
        'player1.progress': currentQuestionIndex,
      });

      if (currentQuestionIndex >= questions.length) {
        _showGameEndAnimation();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('不正解です。もう一度挑戦してください。')),
      );
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
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove the animation dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RealTimeResultScreen(roomId: widget.roomId, isHost: widget.isHost,),
        ),
      );
    });
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

            questions.isNotEmpty
                ? Text(
              questions[currentQuestionIndex],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
                : const CircularProgressIndicator(),

            const SizedBox(height: 16),

            TextField(
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
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

            questions.isNotEmpty
                ? Text(
              'あなたの進捗: ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

