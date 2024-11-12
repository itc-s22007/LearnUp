import 'package:flutter/material.dart';
import '../home/Profile.dart';
import 'LevelScreen.dart';
import '../screens/scoring_screen.dart';
import 'Review.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _onTextTap(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
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
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    const Text(
                      '問題',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LevelScreen(onLevelSelected: (selectedLevel) {}),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '成績',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScoringScreen()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.pink,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '復習',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewScreen()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.yellow,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '挑戦',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print("青チョークが押されました"),
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.blue,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'ホーム',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print("ホームが押されました"),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 85,
                              height: 20,
                              color: Colors.black87,
                              margin: const EdgeInsets.only(left: 10),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                color: Colors.brown,
                                width: 50,
                                height: 30,
                              ),
                            ),
                          ),
                          Align(
                            child: Container(
                              width: 73,
                              height: 7,
                              margin: const EdgeInsets.only(left: 10),
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
