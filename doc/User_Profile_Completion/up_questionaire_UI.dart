/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/questionnaire_content.dart';
import '../../data/models/questionnaire_models.dart';
import '../providers/user_answers_provider.dart';
import '../../domain/state/onboarding_state_machine.dart';

/// Program Questionnaire Page - Direct questions with radio buttons and scales
class QuestionnairePage extends ConsumerStatefulWidget {
  const QuestionnairePage({super.key});

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveAnswerAndAdvance(String questionId, dynamic value) {
    // Save response
    ref.read(userAnswersProvider.notifier).saveAnswer(questionId, value);

    // Auto-advance to next question after short delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        if (_currentPage < programQuestions.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          // Questionnaire complete - use state machine to trigger AI analysis
          final userAnswers = ref.read(userAnswersProvider);
          // Convert Map<String, dynamic> to Map<String, String>
          final answers = userAnswers.responses.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          ref.read(onboardingStateMachineProvider.notifier)
              .completeQuestionnaire(answers);
        }
      }
    });
  }

  void _previousQuestion() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAnswers = ref.watch(userAnswersProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Progress
            _buildTopBar(theme, userAnswers),

            // Question Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable manual swipe
                itemCount: programQuestions.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final question = programQuestions[index];
                  final currentAnswer = userAnswers.getAnswer(question.id);

                  return _buildQuestionPage(
                    theme,
                    question,
                    index + 1,
                    currentAnswer,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, UserAnswers userAnswers) {
    final progress = userAnswers.getProgress(programQuestions.length);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Back button and question counter
          Row(
            children: [
              if (_currentPage > 0)
                IconButton(
                  onPressed: _previousQuestion,
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Previous question',
                ),
              if (_currentPage == 0) const SizedBox(width: 48),

              Expanded(
                child: Text(
                  'Question ${_currentPage + 1} of ${programQuestions.length}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 48), // Balance with back button
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(
    ThemeData theme,
    QuestionnaireQuestion question,
    int questionNumber,
    dynamic currentAnswer,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Title
          Text(
            question.question,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          if (question.subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              question.subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Answer Options based on question type
          if (question.type == QuestionType.singleChoice)
            _buildSingleChoiceOptions(theme, question, currentAnswer)
          else if (question.type == QuestionType.scale)
            _buildScaleOptions(theme, question, currentAnswer)
          else if (question.type == QuestionType.multiChoice)
            _buildMultiChoiceOptions(theme, question, currentAnswer),
        ],
      ),
    );
  }

  Widget _buildSingleChoiceOptions(
    ThemeData theme,
    QuestionnaireQuestion question,
    String? currentAnswer,
  ) {
    return Column(
      children: question.options.map((option) {
        final isSelected = currentAnswer == option;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _saveAnswerAndAdvance(question.id, option),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Radio button indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : null,
                  ),

                  const SizedBox(width: 16),

                  // Option text
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScaleOptions(
    ThemeData theme,
    QuestionnaireQuestion question,
    int? currentAnswer,
  ) {
    return Column(
      children: [
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (question.scaleMinLabel != null)
              Expanded(
                child: Text(
                  question.scaleMinLabel!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            if (question.scaleMaxLabel != null)
              Expanded(
                child: Text(
                  question.scaleMaxLabel!,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 24),

        // Scale buttons (1-5)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = currentAnswer == value;

            return InkWell(
              onTap: () => _saveAnswerAndAdvance(question.id, value),
              borderRadius: BorderRadius.circular(50),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMultiChoiceOptions(
    ThemeData theme,
    QuestionnaireQuestion question,
    List<String>? currentAnswers,
  ) {
    final selectedOptions = currentAnswers ?? [];

    return Column(
      children: [
        ...question.options.map((option) {
          final isSelected = selectedOptions.contains(option);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                final updated = List<String>.from(selectedOptions);
                if (isSelected) {
                  updated.remove(option);
                } else {
                  updated.add(option);
                }
                ref.read(userAnswersProvider.notifier).saveAnswer(
                      question.id,
                      updated,
                    );
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    // Option text
                    Expanded(
                      child: Text(
                        option,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        // Continue button for multi-choice
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: selectedOptions.isNotEmpty
                ? () => _saveAnswerAndAdvance(question.id, selectedOptions)
                : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentPage < programQuestions.length - 1
                  ? 'Continue'
                  : 'Finish',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
*/