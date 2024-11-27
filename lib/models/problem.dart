// class Problem {
//   final String question;
//   final double answer;
//   final bool isInputProblem;
//   final bool isChoiceProblem;
//
//   Problem({required this.question, required this.answer, this.isInputProblem = false, this.isChoiceProblem = false});
// }

class Problem {
  final String question;
  final String formula;  // 正しい数式を追加
  final double answer;
  final bool isInputProblem;

  Problem({
    required this.question,
    required this.formula,
    required this.answer,
    required this.isInputProblem,
  });
}




