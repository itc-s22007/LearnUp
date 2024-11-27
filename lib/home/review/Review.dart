import 'package:flutter/material.dart';
import '../HomeScreen.dart';
import 'reviewFormat/ReviewChoice.dart';
import 'reviewFormat/ReviewInput.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFormatButton(
                              context,
                              '選択問題',
                                  () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewChoice(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildFormatButton(
                              context,
                              '入力問題',
                                  () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReviewInput(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                      'ホーム',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToHome,
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

  Widget _buildFormatButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
