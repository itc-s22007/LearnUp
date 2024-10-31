class Problem {
  final String question;
  final double answer;
  List<double>? choices;
  double? selectedChoice;

  Problem({required this.question, required this.answer, this.choices});
}


