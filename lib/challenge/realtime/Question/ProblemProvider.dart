import 'dart:math';

class ProblemProvider {
  final Random random = Random();

  String generateQuestion(String operation) {
    final int a;
    final int b;

    if (operation == 'divide') {
      a = random.nextInt(90) + 10;
      b = random.nextInt(9) + 1;
      return '$a ÷ $b = ?';
    } else {
      a = random.nextInt(20) + 1;
      b = random.nextInt(a) + 1;
      if (operation == 'add') {
        return '$a + $b = ?';
      } else if (operation == 'subtract') {
        return '$a - $b = ?';
      } else if (operation == 'multiply') {
        return '$a × $b = ?';
      }
    }
    return '';
  }

  int calculateAnswer(String operation, int a, int b) {
    if (operation == 'add') return a + b;
    if (operation == 'subtract') return a - b;
    if (operation == 'multiply') return a * b;
    if (operation == 'divide') return a ~/ b;
    return 0;
  }
}
