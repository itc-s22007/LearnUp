import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../models/problem.dart';
import '../../Result/QuestionResults/InputResultScreen.dart';

class InputScreen extends StatefulWidget {
  final List<Problem> problems;
  final Function(Problem problem, String userFormula, double userAnswer) onAnswerEntered;

  const InputScreen({
    Key? key,
    required this.problems,
    required this.onAnswerEntered,
  }) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  final List<String> _answerResults = [];
  String _userFormula = "";
  String _userAnswer = "";
  bool _isFormulaMode = true;
  bool _isCorrectMarkVisible = false;
  String _markText = '';
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _addInput(String value) {
    if (!_isAnswered) {
      setState(() {
        if (_isFormulaMode) {
          _userFormula += value;
        } else {
          _userAnswer += value;
        }
      });
    }
  }

  void _clearInput() {
    if (!_isAnswered) {
      setState(() {
        if (_isFormulaMode) {
          _userFormula = "";
        } else {
          _userAnswer = "";
        }
      });
    }
  }

  void _toggleInputMode() {
    setState(() {
      _isFormulaMode = !_isFormulaMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  void _checkAnswer() {
    final currentProblem = widget.problems[_currentQuestionIndex];
    final correctAnswer = currentProblem.answer;
    if (_userFormula.isEmpty || _userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('式と答えを両方入力してください。')),
      );
      return;
    }
    final userAnswerDouble = double.tryParse(_userAnswer);
    if (userAnswerDouble == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な数値を入力してください。')),
      );
      return;
    }
    setState(() {
      _isAnswered = true;
      _isCorrect = (_userFormula == currentProblem.formula) &&
          (userAnswerDouble == correctAnswer);
      _markText = _isCorrect ? '◯' : '✕';
      _isCorrectMarkVisible = true;
      _animationController.forward(from: 0);

      if (_isCorrect) {
        _playSound('assets/sounds/mp3/correct.mp3'); // 正解時の音声
      } else {
        _playSound('assets/sounds/mp3/wrong.mp3'); // 不正解時の音声
      }

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isCorrectMarkVisible = false;
        });
        _showResultDialog(
            _isCorrect, correctAnswer, double.tryParse(_userAnswer));
      });
      if (_isCorrect) _correctAnswersCount++;
      _answerResults.add(
        '${_isCorrect ? "○" : "×"}: ${currentProblem
            .question} : あなたの式: $_userFormula : あなたの答え: $_userAnswer : 正しい式: ${currentProblem
            .formula} : 正しい答え: $correctAnswer',
      );
    });
    widget.onAnswerEntered(
        currentProblem, _userFormula, double.parse(_userAnswer));
  }

  void _skipQuestion() {
    final currentProblem = widget.problems[_currentQuestionIndex];
    final correctAnswer = currentProblem.answer;

    setState(() {
      _isAnswered = true;
      _isCorrect = false;
      _answerResults.add(
        '${_isCorrect ? "○" : "×"}: ${currentProblem
            .question} : あなたの式:  スキップ  : あなたの答え: 　スキップ　 : 正しい式: ${currentProblem
            .formula} : 正しい答え: $correctAnswer',
      );
    });

    _showResultDialog(false, correctAnswer, null, skipped: true);
  }

  void _showResultDialog(bool isCorrect, double correctAnswer,
      double? userAnswer, {bool skipped = false}) {
    final correctFormula = widget.problems[_currentQuestionIndex].formula;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            title: Text(
              isCorrect ? '正解！' : skipped ? 'スキップしました' : '不正解',
            ),
            content: Text(
              skipped
                  ? 'スキップしました。\n正しい式: $correctFormula\n正しい答え: $correctAnswer'
                  : isCorrect
                  ? 'おめでとうございます！正解です。'
                  : '残念！\n正しい式: $correctFormula\n正しい答え: $correctAnswer\nあなたの式: $_userFormula\nあなたの答え: $userAnswer',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_currentQuestionIndex < widget.problems.length - 1) {
                    setState(() {
                      _currentQuestionIndex++;
                      _isAnswered = false;
                      _isCorrect = false;
                      _userFormula = "";
                      _userAnswer = "";
                    });
                  } else {
                    _showCompletionDialog();
                  }
                },
                child: const Text('次へ'),
              ),
            ],
          ),
    );
  }

  void _showCompletionDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InputResultsScreen(
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
      _isCorrect = false;
      _answerResults.clear();
      _userFormula = "";
      _userAnswer = "";
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _playSound(String soundFile) async {
    try {
      await _audioPlayer.play(AssetSource(soundFile));
    } catch (e) {
      print('音声再生エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProblem = widget.problems[_currentQuestionIndex];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '問題 ${_currentQuestionIndex + 1}/${widget.problems
                            .length}',
                        style: const TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentProblem.question,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (_isCorrectMarkVisible)
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
          ),
          Container(
            color: Colors.brown,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '式: $_userFormula',
                        style: const TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(
                          '答え: $_userAnswer',
                          style: const TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i <= 9; i++)
                      ElevatedButton(
                        onPressed: () => _addInput(i.toString()),
                        child: Text(
                            i.toString(), style: const TextStyle(fontSize: 20)),
                      ),
                    ElevatedButton(
                      onPressed: () => _addInput('+'),
                      child: const Text('+', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('-'),
                      child: const Text('-', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('×'),
                      child: const Text('×', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () => _addInput('÷'),
                      child: const Text('÷', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: _clearInput,
                      child: const Text(
                          'クリア', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: _toggleInputMode,
                      child: Text(
                        _isFormulaMode ? '現在: 式' : '現在: 答え',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isAnswered ? null : _checkAnswer,
                      child: const Text('回答'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isAnswered ? null : _skipQuestion,
                      child: const Text('スキップ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}