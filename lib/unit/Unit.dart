import 'package:flutter/material.dart';
import 'package:learnup/unit/school%20year/1st/SentenceMinus.dart';
import 'package:learnup/unit/school%20year/1st/SentencePlus.dart';

import 'school year/1st/Plus.dart';
import 'school year/1st/Minus.dart';
import 'school year/1st/Measrements1.dart';

class UnitScreen extends StatelessWidget {
  final String grade;

  const UnitScreen({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Unit> units = getUnitsForGrade(grade);

    return Scaffold(
      appBar: AppBar(
        title: Text('$grade 単元'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              units[index].title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => units[index].widget),
              );
            },
          );
        },
      ),
    );
  }

  List<Unit> getUnitsForGrade(String grade) {
    switch (grade) {
      case '1年生':
        return [
          Unit(title: 'たしざん', widget: const Calculations1(format: '',)),
          Unit(title: 'ひきざん', widget: const Calculations2(format: '',)),
          Unit(title: 'たしざんのおはなしもんだい', widget: const SentencePlus(format: '')),
          Unit(title: 'ひきざんのおはなしもんだい', widget: const SentenceMinus(format: '')),
          Unit(title: 'ながさのもんだい', widget: Measurements1())
        ];
      case '2年生':
        return [

        ];
      case '3年生':
        return [

        ];
      case '4年生':
        return [

        ];
      case '5年生':
        return [

        ];
      case '6年生':
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

  Unit({required this.title, required this.widget});
}


//       case '1年生':
//         return [
//           Unit(title: '計算', widget: const Calculations1()),
//           // Unit(title: '測定', widget: const Measurements1()),
//           // Unit(title: '図形', widget: const Shapes1()),
//           // Unit(title: '時間', widget: const Times1()),
//         ];
//       case '2年生':
//         return [
//           // Unit(title: '計算', widget: const Calculations2()),
//           // Unit(title: '測定', widget: const Measurements2()),
//           // Unit(title: 'お金', widget: const Money2()),
//           // Unit(title: '図形', widget: const Shapes2()),
//           // Unit(title: '時間', widget: const Times2()),
//         ];
//       case '3年生':
//         return [
//           // Unit(title: '計算', widget: const Calculations3()),
//           // Unit(title: 'データ', widget: const Data3()),
//           // Unit(title: '', widget: const Decimal3()),
//           // Unit(title: '', widget: const Fractions3()),
//           // Unit(title: '測定', widget: const Measurements3()),
//           // Unit(title: '図形', widget: const Shapes3()),
//         ];
//       case '4年生':
//         return [
//           // Unit(title: '計算', widget: const Calculations4()),
//           // Unit(title: 'データ', widget: const Data4()),
//           // Unit(title: '測定', widget: const Measurements4()),
//           // Unit(title: '', widget: const Proportions4()),
//           // Unit(title: '図形', widget: const Shapes4()),
//         ];
//       case '5年生':
//         return [
//           // Unit(title: '計算', widget: const Calculations5()),
//           // Unit(title: 'データ', widget: const Data5()),
//           // Unit(title: '', widget: const Equations5()),
//           // Unit(title: '', widget: const Proportions5()),
//           // Unit(title: '図形', widget: const Shapes5()),
//         ];
//       case '6年生':
//         return [
//           // Unit(title: '計算', widget: const Calculations6()),
//           // Unit(title: '', widget: const Equations6()),
//           // Unit(title: '', widget: const Probability6()),
//           // Unit(title: '', widget: const Proportions6()),
//           // Unit(title: '図形', widget: const Shapes6()),
//           // Unit(title: '', widget: const Solution6()),
//         ];



