import 'package:flutter/material.dart';
import '../../../models/problem.dart';
import '../../../format/FormatScreen.dart';
import '../../Unit.dart';

class Multiplicative extends StatelessWidget {
  const Multiplicative({Key? key}) : super(key: key);

  void _navigateToFormatScreen(BuildContext context, int table) {
    final problems = _generateMultiplicationProblems(table);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormatScreen(
          unit: Unit(
            title: '$table の段の掛け算',
            widget: const Multiplicative(),
            problems: problems,
          ),
          problems: problems,
        ),
      ),
    );
  }

  List<Problem> _generateMultiplicationProblems(int table) {
    return List.generate(10, (index) {
      final multiplier = index + 1;
      final answer = table * multiplier;
      final formula = '$table × $multiplier';

      return Problem(
        question: '$table × $multiplier',
        answer: answer.toDouble(),
        formula: formula,
        isInputProblem: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<int> tables = List.generate(9, (index) => index + 1);
    final List<int> leftTables = tables.where((table) => table % 2 != 0).toList();
    final List<int> rightTables = tables.where((table) => table % 2 == 0).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: leftTables.map((table) {
                        return GestureDetector(
                          onTap: () => _navigateToFormatScreen(context, table),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Text(
                                '$table の段',
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
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rightTables.map((table) {
                        return GestureDetector(
                          onTap: () => _navigateToFormatScreen(context, table),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Text(
                                '$table の段',
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
                  ),
                ],
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
}
