import 'package:flutter/material.dart';
import 'NumberScreen.dart'; // Assuming this is the screen you're transitioning to

class NumberIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500], // Customize your color here
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'ナンバープレートの数字を使って式を作り、答えを10にしてください！',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'できるだけ早く、問題を解いてください！',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildActionButton(
                  context,
                  'スタート！',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NumberScreen(), // Transition to NumberScreen
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to the previous screen if necessary
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

  Widget _buildActionButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
