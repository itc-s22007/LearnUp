import 'package:flutter/material.dart';
import 'package:learnup/unit/school%20year/1st/BlankMinus.dart';
import 'package:learnup/unit/school%20year/1st/BlankPlus.dart';
import 'package:learnup/unit/school%20year/1st/Minus.dart';
import 'package:learnup/unit/school%20year/1st/Plus.dart';
import 'package:learnup/unit/school%20year/1st/SentenceMinus.dart';
import 'package:learnup/unit/school%20year/1st/SentencePlus.dart';
import 'package:learnup/unit/school%20year/1st/Times1.dart';
import '../models/problem.dart';
import '../format/FormatScreen.dart';

class UnitScreen extends StatelessWidget {
  final String grade;

  const UnitScreen({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Unit> units = _getUnitsForGrade(grade);

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
                itemCount: units.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToFormatScreen(context, units[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          units[index].title,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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

  void _navigateToFormatScreen(BuildContext context, Unit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormatScreen(
          unit: unit,
          problems: unit.problems,
        ),
      ),
    );
  }

  // 学年ごとに単元リストを取得する関数
  List<Unit> _getUnitsForGrade(String grade) {
    switch (grade) {
      case '1年生':
        return [
          Unit(title: 'たしざんのけいさん', widget: const Calculations1(format: ''), problems: Calculations1.generateProblems()),
          Unit(title: 'たしざんのあなうめ', widget: const BlankPlus(format: '',), problems: BlankPlus.generateProblems()),
          Unit(title: 'おはなしもんだい(たしざん)', widget: const SentencePlus(format: '',), problems: SentencePlus.generateProblems()),
          Unit(title: 'ひきざんのけいさん', widget: const Calculations2(format: ''), problems: Calculations2.generateProblems()),
          Unit(title: 'ひきざんのあなうめ', widget: const BlankMinus(format: '',), problems: BlankMinus.generateProblems()),
          Unit(title: 'おはなしもんだい(ひきざん)', widget: const SentenceMinus(format: '',), problems: SentenceMinus.generateProblems()),
        ];
      case '2年生':
        return [

        ];
      case '3年生':
        return [
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

