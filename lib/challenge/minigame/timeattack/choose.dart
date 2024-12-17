import 'package:flutter/material.dart';
import 'TimeAttackIntroScreen.dart';
import '../../../home/challenge.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Challenge> challenges = [
      Challenge(
        title: '足し算',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeAttackIntroScreen(operation: 'add'),
            ),
          );
        },
      ),
      Challenge(
        title: '引き算',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeAttackIntroScreen(operation: 'subtract'),
            ),
          );
        },
      ),
      Challenge(
        title: '掛け算',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeAttackIntroScreen(operation: 'multiply'),
            ),
          );
        },
      ),
      Challenge(
        title: '割り算',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeAttackIntroScreen(operation: 'divide'),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: challenges[index].onPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          challenges[index].title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const ChallengeScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 85,
                          height: 20,
                          color: Colors.black87,
                          margin: const EdgeInsets.only(right: 5),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: Colors.brown,
                            width: 50,
                            height: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 73,
                          height: 7,
                          margin: const EdgeInsets.only(right: 10),
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class Challenge {
  final String title;
  final VoidCallback onPressed;

  Challenge({required this.title, required this.onPressed});
}
