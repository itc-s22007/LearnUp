import 'package:flutter/material.dart';
import 'package:learnup/unit/school%20year/4th/Parenthesis.dart';
import 'package:learnup/unit/school%20year/4th/SentenceParenthesis.dart';
import 'package:learnup/unit/school%20year/4th/fraction.dart';
import 'school year/1st/Minus.dart';
import 'school year/1st/Plus.dart';
import 'school year/1st/SentenceMinus.dart';
import 'school year/1st/SentencePlus.dart';
import 'school year/2nd/Plus2.dart';
import 'school year/2nd/Minus2.dart';
import 'school year/2nd/SentenceMinus2.dart';
import 'school year/2nd/SentencePlus2.dart';
import 'school year/3rd/division.dart';
import 'school year/3rd/multiplicative.dart';
import 'school year/3rd/SentenceDivison.dart';
import 'school year/3rd/remainder.dart';
import 'school year/3rd/SentenceMultiplicative.dart';
import 'school year/4th/ApproximateNumber.dart';
import 'school year/4th/division2.dart';
import '../models/problem.dart';
import '../format/FormatScreen.dart';
import 'package:learnup/unit/school%20year/1st/BlankMinus.dart' as bm;
import 'package:learnup/unit/school%20year/1st/BlankPlus.dart' as bp;




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


  List<Unit> _getUnitsForGrade(String grade) {
    switch (grade) {
      case '１年生':
        return [
          Unit(title: 'たしざん(１ケタ、２ケタ）', widget: const Plus1(format: ''), problems: Plus1.generateProblems()),
          Unit(title: 'たしざんのあなうめ', widget: const bp.BlankPlus(format: ''), problems: bp.BlankPlus.generateProblems()),
          Unit(title: 'おはなしもんだい(たしざん)', widget: const SentencePlus(format: ''), problems: SentencePlus.generateProblems()),
          Unit(title: 'ひきざん（１ケタ、２ケタ）', widget: const Minus1(format: ''), problems: Minus1.generateProblems()),
          Unit(title: 'ひきざんのあなうめ', widget: const bm.BlankMinus(format: ''), problems: bm.BlankMinus.generateProblems()),
          Unit(title: 'おはなしもんだい(ひきざん)', widget: const SentenceMinus(format: ''), problems: SentenceMinus.generateProblems()),
        ];
      case '2年生':
        return [
          Unit(title: '足し算（３ケタ）', widget: const Plus2(format: ''), problems: Plus2.generateProblems()),
          Unit(title: '足し算（３ケタ）', widget: const Minus2(format: ''), problems: Minus2.generateProblems()),
          Unit(title: '２ケタの文章問題(足し算)', widget: const SentencePlus2(format: ''), problems: SentencePlus2.generateProblems()),
          Unit(title: '２ケタの文章問題(引き算)', widget: const SentenceMinus2(format: ''), problems: SentenceMinus2.generateProblems()),

        ];
      case '3年生':
        return [
          Unit(title: '掛け算', widget: const Multiplicative(format: '',), problems: Multiplicative.generateProblems()),
          Unit(title: '割り算', widget: const DivisionProblems(format: ''), problems: DivisionProblems.generateProblems()),
          Unit(title: '割り算の余り', widget: const RemainderProblems(format: ''), problems: RemainderProblems.generateProblems()),
          Unit(title: '掛け算の文章問題', widget: const SentenceMultiplicative(format: ''), problems: SentenceMultiplicative.generateProblems()),
          Unit(title: '割り算の文章問題', widget: const SentenceDivide(format: ''), problems: SentenceDivide.generateProblems()),
        ];
      case '4年生':
        return [
          Unit(title: '割り算(２ケタ)', widget: const DivisionProblems2(format: ''), problems: DivisionProblems2.generateProblems()),
          Unit(title: 'がい数', widget: const RoundingProblems(format: ''), problems: RoundingProblems.generateProblems()),
          Unit(title: '(  )の計算', widget: const ParenthesisProblems(format: ''), problems: ParenthesisProblems.generateProblems()),
          Unit(title: '(  )の文章問題', widget: const ParenthesisWordProblems(format: ''), problems: ParenthesisWordProblems.generateProblems()),
          Unit(title: '分数', widget: const FractionAddition(), problems: FractionAddition.generateProblems())
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
