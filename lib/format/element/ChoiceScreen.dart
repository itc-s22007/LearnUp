import 'package:flutter/material.dart';
import 'package:learnup/unit/Unit.dart';
import '../../home/LevelScreen.dart';
import '../../models/problem.dart';
import 'dart:math';
import '../../Result/QuestionResults/ChoiceResultScreen.dart';

class ChoiceScreen extends StatefulWidget {
  final void Function(Problem, double) onAnswerSelected;
  final Unit? unit;
  final List<Problem> problems;

  const ChoiceScreen({
    Key? key,
    required this.problems,
    required this.onAnswerSelected,
    this.unit, required void Function(Problem problem, double userAnswer) onAnswerEntered,
  }) : super(key: key);

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  List<int> _currentOptions = [];
  final List<String> _answerResults = [];
  String _markText = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _generateOptions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  void _generateOptions() {
    final correctAnswer = widget.problems[_currentQuestionIndex].answer.toInt();
    _currentOptions = _generateOptionsList(correctAnswer);
  }

  List<int> _generateOptionsList(int correctAnswer) {
    List<int> options = [correctAnswer];
    Random rand = Random();

    while (options.length < 4) {
      int wrongAnswer = correctAnswer + rand.nextInt(10) - 5;
      if (wrongAnswer != correctAnswer && wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    options.shuffle();
    return options;
  }

  void _checkAnswer(int selectedAnswer) {
    final problem = widget.problems[_currentQuestionIndex];
    final correctAnswer = problem.answer.toInt();
    final isCorrect = selectedAnswer == correctAnswer;

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      _markText = isCorrect ? '◯' : '✕';
    });

    _answerResults.add(
      '${isCorrect ? "○" : "×"}: ${problem.question} : $correctAnswer : $selectedAnswer',
    );

    widget.onAnswerSelected(problem, selectedAnswer.toDouble());

    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(isCorrect ? '正解！' : '不正解'),
          content: Text(isCorrect
              ? 'せいかいです！'
              : 'ざんねん、まちがいです。こたえは$correctAnswerです。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (_currentQuestionIndex < widget.problems.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _isAnswered = false;
                  });
                  _generateOptions();
                } else {
                  _showCompletionDialog();
                }
              },
              child: const Text('次へ'),
            ),
          ],
        ),
      );
    });
  }


  void _showCompletionDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoiceResultsScreen(
          totalQuestions: widget.problems.length,
          correctAnswers: _correctAnswersCount,
          questionResults: _answerResults,
          onRetry: _retryQuiz,
        ),
      ),
    );
  }

  void _retryQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _isAnswered = false;
      _answerResults.clear();
      _generateOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[_currentQuestionIndex];
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.green,
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          problem.question,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScreen(onLevelSelected: (selectedLevel) {}),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 85,
                        height: 20,
                        color: Colors.black87,
                        margin: const EdgeInsets.only(right: 5),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: Colors.brown,
                          width: 50,
                          height: 30,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 73,
                        height: 7,
                        margin: const EdgeInsets.only(right: 10),
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _currentOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 15.0,
                    childAspectRatio: 3.5,
                  ),
                  itemBuilder: (context, index) {
                    final option = _currentOptions[index];
                    Color buttonColor;

                    if (_isAnswered) {
                      if (option == problem.answer.toInt()) {
                        buttonColor = Colors.green;
                      } else {
                        buttonColor = Colors.red;
                      }
                    } else {
                      buttonColor = Colors.blue;
                    }

                    return ElevatedButton(
                      onPressed: _isAnswered ? null : () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        textStyle: const TextStyle(fontSize: 22),
                      ),
                      child: Text(
                        option.toString(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isAnswered)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _markText,
                  style: TextStyle(
                    fontSize: 300,
                    fontWeight: FontWeight.bold,
                    color: _isCorrect ? Colors.red : Colors.blue,
                    shadows: [
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
