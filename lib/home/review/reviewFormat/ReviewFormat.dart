import 'package:flutter/material.dart';
import 'ReviewChoice.dart';

class Reviewformat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('問題形式を選んでください'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFormatButton(context, '選択問題', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewChoice()
                ),
              );
            }),
            const SizedBox(height: 20),
            _buildFormatButton(context, '入力問題', () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ReviewInput()
              //   ),
              // );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatButton(BuildContext context, String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}