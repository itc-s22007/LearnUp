import 'package:flutter/material.dart';
import 'dart:math';

import '../../../models/problem.dart';

class Times1 extends StatelessWidget {
  static List<Problem> generateProblems() {
    return List.generate(10, (_) {
      final random = Random();
      int hour = random.nextInt(12); // 0〜11のランダムな時
      int minute = random.nextInt(4) * 15; // 0, 15, 30, 45 のいずれか
      double answer = hour + (minute / 60.0); // 時間と分をdoubleで表現

      return Problem(
        question: 'この時間は何時何分ですか？',
        answer: answer,
        choices: [
          answer,
          (hour + 1) % 12 + (minute / 60.0),
          hour + ((minute + 15) % 60) / 60.0,
          (hour - 1) % 12 + (minute / 60.0),
        ]..shuffle(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("時計の問題")),
      body: Center(child: ClockWidget()),
    );
  }
}

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  final Random random = Random();
  late int hour;
  late int minute;
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String resultMessage = '';

  @override
  void initState() {
    super.initState();
    generateTime();
  }

  void generateTime() {
    setState(() {
      hour = random.nextInt(12); // 0〜11のランダムな時
      minute = random.nextInt(4) * 15; // 0, 15, 30, 45 のいずれか
      resultMessage = '';
      _hourController.clear();
      _minuteController.clear();
    });
  }

  void checkAnswer() {
    int enteredHour = int.tryParse(_hourController.text) ?? -1;
    int enteredMinute = int.tryParse(_minuteController.text) ?? -1;

    if (enteredHour == hour && enteredMinute == minute) {
      setState(() {
        resultMessage = '正解です！';
      });
    } else {
      setState(() {
        resultMessage = '不正解です。もう一度試してください。';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: const Size(200, 200),
          painter: ClockPainter(hour: hour, minute: minute),
        ),
        const SizedBox(height: 20),
        const Text("この時間は何時何分ですか？", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _hourController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '時'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _minuteController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '分'),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: checkAnswer,
          child: const Text('解答を確認'),
        ),
        const SizedBox(height: 10),
        Text(resultMessage, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final int hour;
  final int minute;

  ClockPainter({required this.hour, required this.minute});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 時計の円
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, paint);

    // 短針
    final hourAngle = (hour * 30 + minute * 0.5) * pi / 180;
    final hourHand = Offset(
      center.dx + radius * 0.5 * cos(hourAngle - pi / 2),
      center.dy + radius * 0.5 * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, hourHand, paint..strokeWidth = 6);

    // 長針
    final minuteAngle = minute * 6 * pi / 180;
    final minuteHand = Offset(
      center.dx + radius * 0.8 * cos(minuteAngle - pi / 2),
      center.dy + radius * 0.8 * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, minuteHand, paint..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

