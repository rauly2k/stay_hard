import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/data/models/alarm_model.dart';

class AlarmChallengeScreen extends StatefulWidget {
  final int alarmId;
  final AlarmModel alarmModel;

  const AlarmChallengeScreen({
    super.key,
    required this.alarmId,
    required this.alarmModel,
  });

  @override
  State<AlarmChallengeScreen> createState() => _AlarmChallengeScreenState();
}

class _AlarmChallengeScreenState extends State<AlarmChallengeScreen> {
  final _answerController = TextEditingController();
  final _random = Random();

  int? _mathAnswer;
  String _mathProblem = '';
  String _typingPhrase = '';
  String? _errorMessage;

  final List<String> _motivationalQuotes = [
    'Discipline is freedom',
    'Do what is hard, life will be easy',
    'The only easy day was yesterday',
    'Pain is weakness leaving the body',
    'Embrace the suck',
    'Stay hard',
    'No excuses, just results',
  ];

  @override
  void initState() {
    super.initState();
    _initializeChallenge();
  }

  void _initializeChallenge() {
    switch (widget.alarmModel.dismissalMethod) {
      case DismissalMethod.math:
        _generateMathProblem();
        break;
      case DismissalMethod.textTyping:
        _selectTypingPhrase();
        break;
      case DismissalMethod.customText:
      case DismissalMethod.classic:
        break;
    }
  }

  void _generateMathProblem() {
    final difficulty = widget.alarmModel.challengeDifficulty ?? ChallengeDifficulty.medium;

    int num1, num2, answer;
    String operator;

    switch (difficulty) {
      case ChallengeDifficulty.easy:
        // Single digit addition/subtraction
        num1 = _random.nextInt(10);
        num2 = _random.nextInt(10);
        if (_random.nextBool()) {
          operator = '+';
          answer = num1 + num2;
        } else {
          operator = '-';
          if (num1 < num2) {
            final temp = num1;
            num1 = num2;
            num2 = temp;
          }
          answer = num1 - num2;
        }
        break;

      case ChallengeDifficulty.medium:
        // Double digit addition/subtraction
        num1 = 10 + _random.nextInt(90);
        num2 = 10 + _random.nextInt(90);
        if (_random.nextBool()) {
          operator = '+';
          answer = num1 + num2;
        } else {
          operator = '-';
          if (num1 < num2) {
            final temp = num1;
            num1 = num2;
            num2 = temp;
          }
          answer = num1 - num2;
        }
        break;

      case ChallengeDifficulty.hard:
        // Multiplication or multi-step
        if (_random.nextBool()) {
          num1 = 2 + _random.nextInt(12);
          num2 = 2 + _random.nextInt(12);
          operator = '×';
          answer = num1 * num2;
        } else {
          // Multi-step: (a + b) - c
          final a = _random.nextInt(20);
          final b = _random.nextInt(20);
          final c = _random.nextInt(10);
          num1 = a;
          num2 = b;
          answer = (a + b) - c;
          _mathProblem = '($a + $b) - $c';
          _mathAnswer = answer;
          return;
        }
        break;
    }

    _mathProblem = '$num1 $operator $num2';
    _mathAnswer = answer;
  }

  void _selectTypingPhrase() {
    final difficulty = widget.alarmModel.challengeDifficulty ?? ChallengeDifficulty.medium;

    switch (difficulty) {
      case ChallengeDifficulty.easy:
        _typingPhrase = _motivationalQuotes[_random.nextInt(3)];
        break;
      case ChallengeDifficulty.medium:
        _typingPhrase = _motivationalQuotes[3 + _random.nextInt(2)];
        break;
      case ChallengeDifficulty.hard:
        _typingPhrase = _motivationalQuotes[5 + _random.nextInt(2)];
        break;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final quote = _motivationalQuotes[_random.nextInt(_motivationalQuotes.length)];

    return PopScope(
      canPop: false, // Prevent back navigation and swipe gestures
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // Block all pop attempts - user must solve the challenge
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Current time display
                Text(
                  '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 72,
                  ),
                ),
                const SizedBox(height: 16),

                // Alarm label
                Text(
                  widget.alarmModel.label.toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 32),

                // Motivational quote
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '"$quote"',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),

                // Challenge Section
                _buildChallengeSection(theme),
                const SizedBox(height: 24),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeSection(ThemeData theme) {
    switch (widget.alarmModel.dismissalMethod) {
      case DismissalMethod.classic:
        return _buildClassicDismissal(theme);
      case DismissalMethod.math:
        return _buildMathChallenge(theme);
      case DismissalMethod.textTyping:
        return _buildTypingChallenge(theme);
      case DismissalMethod.customText:
        return _buildCustomTextChallenge(theme);
    }
  }

  Widget _buildClassicDismissal(ThemeData theme) {
    return ElevatedButton(
      onPressed: _dismissAlarm,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Slide to Dismiss',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMathChallenge(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Solve to dismiss:',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$_mathProblem = ?',
          style: theme.textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _answerController,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Your answer',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkMathAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingChallenge(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Type to dismiss:',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _typingPhrase,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _answerController,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: 'Type here...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkTypingAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTextChallenge(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Type your commitment:',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.alarmModel.customText ?? '',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _answerController,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: 'Type here...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkCustomTextAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _checkMathAnswer() {
    final answer = int.tryParse(_answerController.text);
    if (answer == null) {
      setState(() {
        _errorMessage = 'Please enter a valid number';
      });
      return;
    }

    if (answer == _mathAnswer) {
      _dismissAlarm();
    } else {
      setState(() {
        _errorMessage = 'Wrong answer! Try again.';
        _answerController.clear();
        _generateMathProblem(); // Generate new problem
      });
    }
  }

  void _checkTypingAnswer() {
    final answer = _answerController.text.trim();
    if (answer.toLowerCase() == _typingPhrase.toLowerCase()) {
      _dismissAlarm();
    } else {
      setState(() {
        _errorMessage = 'Text doesn\'t match! Try again.';
        _answerController.clear();
      });
    }
  }

  void _checkCustomTextAnswer() {
    final answer = _answerController.text.trim();
    final customText = widget.alarmModel.customText ?? '';
    if (answer.toLowerCase() == customText.toLowerCase()) {
      _dismissAlarm();
    } else {
      setState(() {
        _errorMessage = 'Text doesn\'t match! Try again.';
        _answerController.clear();
      });
    }
  }

  Future<void> _dismissAlarm() async {
    // Stop the alarm
    await Alarm.stop(widget.alarmId);

    // Navigate back to home
    if (mounted) {
      context.go('/home');
    }
  }
}
