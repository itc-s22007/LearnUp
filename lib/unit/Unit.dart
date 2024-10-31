import 'package:flutter/material.dart';
import 'school year/1st/BlankMinus.dart';
import 'school year/1st/Minus.dart';
import 'school year/1st/Plus.dart';
import 'school year/1st/SentencePlus.dart';
import 'school year/1st/SentenceMinus.dart';
import '../format/FormatScreen.dart';
import '../models/problem.dart';
import 'school year/1st/BlankPlus.dart';

class UnitScreen extends StatelessWidget {
  final String grade;
  final int currentIndex = 0;

  const UnitScreen({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Unit> units = getUnitsForGrade(grade);

    return Scaffold(
      appBar: AppBar(
        title: Text('$grade 単元'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: units.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: units.length,
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
                    units[index].title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormatScreen(
                          unit: units[index],
                          problems: units[index].problems,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: '',
        child: const Icon(Icons.article),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7.0,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }

  List<Unit> getUnitsForGrade(String grade) {
    switch (grade) {
      case '1年生':
        return [
          Unit(title: 'たしざんのけいさん', widget: const Calculations1(format: ''), problems: Calculations1.generateProblems()),
          Unit(title: 'たしざんのあなうめ', widget: const BlankPlus(format: ''), problems: BlankPlus.generateProblems()),
          Unit(title: 'たしざんのおはなしもんだい', widget: const SentencePlus(format: ''), problems: SentencePlus.generateProblems()),
          Unit(title: 'ひきざんのけいさん', widget: const Calculations2(format: ''), problems: []),
          Unit(title: 'ひきざんのあなうめ', widget: const BlankMinus(format: ''), problems: BlankMinus.generateProblems()),
          Unit(title: 'ひきざんのおはなしもんだい', widget: const SentenceMinus(format: ''), problems: SentenceMinus.generateProblems()),
        ];
      default:
        return [];
    }
  }
}

class Unit {
  final String title;
  final Widget widget;
  final List<Problem> problems;

  Unit({required this.title, required this.widget, required this.problems});
}

