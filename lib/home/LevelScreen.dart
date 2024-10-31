//lib/home/LevelScreen.dart
import 'package:flutter/material.dart';
import '../unit/Unit.dart';

class LevelScreen extends StatelessWidget {
  final bool? isChoice;
  final Function(dynamic selectedLevel) onLevelSelected;

  const LevelScreen({super.key, this.isChoice, required this.onLevelSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> levels = [
      '1年生', '2年生', '3年生', '4年生', '5年生', '6年生'
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    levels[index],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnitScreen(grade: levels[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
