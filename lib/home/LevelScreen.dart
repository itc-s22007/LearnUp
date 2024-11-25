import 'package:flutter/material.dart';
import '../unit/Unit.dart';
import 'HomeScreen.dart';

class LevelScreen extends StatelessWidget {
  final bool? isChoice;
  final Function(dynamic selectedLevel) onLevelSelected;

  const LevelScreen({super.key, this.isChoice, required this.onLevelSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> levels = ['1年生', '2年生', '3年生', '4年生', '5年生', '6年生'];
    final List<String> leftLevels = levels.asMap().entries.where((entry) => entry.key.isEven).map((entry) => entry.value).toList();
    final List<String> rightLevels = levels.asMap().entries.where((entry) => entry.key.isOdd).map((entry) => entry.value).toList();

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
                  Positioned(
                    top: 100,
                    left: 80,
                    right: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左の列
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: leftLevels.map((level) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnitScreen(grade: level),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40), // ここで縦の間隔を広げる
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: Text(
                                    level,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        // 右の列
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rightLevels.map((level) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnitScreen(grade: level),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: Text(
                                    level,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                        ),
                      ),
                    );
                  },
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
