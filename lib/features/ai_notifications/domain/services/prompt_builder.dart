import '../../data/models/ai_notification_config.dart';
import '../../data/models/notification_intervention_category.dart';
import '../../data/models/prompt_template.dart';
import '../../data/repositories/persona_repository.dart';

/// Advanced prompt engineering service for building comprehensive LLM prompts
/// Based on AI_PERSONA_ENHANCEMENT_IMPLEMENTATION.md Phase 2
class PromptBuilder {
  final PersonaRepository _personaRepository;

  PromptBuilder({PersonaRepository? personaRepository})
      : _personaRepository = personaRepository ?? PersonaRepository();

  /// Build a comprehensive prompt for AI message generation
  String buildPrompt({
    required AIArchetype archetype,
    required NotificationContext context,
    required InterventionCategory category,
  }) {
    final template = buildPromptTemplate(
      archetype: archetype,
      context: context,
      category: category,
    );

    return template.buildPrompt();
  }

  /// Build a structured prompt template
  PromptTemplate buildPromptTemplate({
    required AIArchetype archetype,
    required NotificationContext context,
    required InterventionCategory category,
  }) {
    // Get system prompt
    final roleDefinition = _personaRepository.getSystemPrompt(archetype);

    // Sample 5 random reference quotes for voice training
    final referenceExamples = _personaRepository.getReferenceSamples(
      archetype,
      count: 5,
    );

    // Build context map
    final contextMap = _buildContextMap(context);

    // Build task instruction
    final taskInstruction = _buildTaskInstruction(context, category);

    return PromptTemplate(
      roleDefinition: roleDefinition,
      referenceExamples: referenceExamples,
      currentContext: contextMap,
      taskInstruction: taskInstruction,
    );
  }

  /// Build context map from notification context
  Map<String, dynamic> _buildContextMap(NotificationContext context) {
    return {
      'Time of Day': context.timeOfDay,
      'Total Habits Today': context.totalHabitsToday,
      'Completed': context.completedCount,
      'Pending Habits': context.pendingHabitNames.join(', '),
      'Current Streak': '${context.currentStreak} days',
      'Longest Streak': '${context.longestStreak} days',
      'Completion Rate (7 days)': '${(context.completionRate7Days * 100).toStringAsFixed(0)}%',
    };
  }

  /// Build task instruction based on category
  String _buildTaskInstruction(
    NotificationContext context,
    InterventionCategory category,
  ) {
    final buffer = StringBuffer();

    // Base instruction
    buffer.write(
        'Generate a short, punchy notification message (under 140 characters) ');

    // Category-specific guidance
    switch (category) {
      case InterventionCategory.morningMotivation:
        buffer.write(
            'to energize the user for the morning. Focus on starting the day strong.');
        if (context.pendingHabitNames.isNotEmpty) {
          buffer.write(' Mention pending morning habits if relevant.');
        }
        break;

      case InterventionCategory.missedHabitRecovery:
        buffer.write(
            'to encourage the user to recover from a missed habit. Be supportive but motivating.');
        break;

      case InterventionCategory.lowMoraleBoost:
        buffer.write(
            'to lift the user\'s spirits during tough times. Be empathetic and encouraging.');
        break;

      case InterventionCategory.streakCelebration:
        buffer.write(
            'to celebrate the user\'s ${context.currentStreak}-day streak. Make it feel special.');
        if (context.currentStreak > 3) {
          buffer.write(' Reference their impressive streak explicitly.');
        }
        break;

      case InterventionCategory.eveningCheckIn:
        buffer.write(
            'for evening reflection. Review the day\'s progress and encourage completion.');
        if (context.completedCount == context.totalHabitsToday) {
          buffer.write(' Celebrate a perfect day!');
        }
        break;

      case InterventionCategory.comebackSupport:
        buffer.write(
            'to welcome the user back after time away. Be warm and encouraging about restarting.');
        break;

      case InterventionCategory.progressInsights:
        buffer.write(
            'to provide insights about progress. Use stats and metrics to show growth.');
        if (context.completionRate7Days > 0.7) {
          buffer.write(' Highlight their strong performance.');
        }
        break;
    }

    buffer.writeln();
    buffer.writeln();
    buffer.writeln('Guidelines:');
    buffer.writeln('- Use the specific tone and voice of the persona');
    buffer.writeln('- Keep under 140 characters total');
    buffer.writeln('- Add 1 relevant emoji at the end');
    buffer.writeln('- Be authentic to the archetype\'s personality');
    buffer.writeln('- Reference context details when relevant (streak, habits, time)');
    buffer.writeln('- Do not use quotes or special formatting');

    return buffer.toString();
  }

  /// Inject specific context values into a template string
  String injectContext(String template, NotificationContext context) {
    return template
        .replaceAll('{{user_name}}', 'User')
        .replaceAll('{{time_of_day}}', context.timeOfDay)
        .replaceAll('{{total_habits}}', context.totalHabitsToday.toString())
        .replaceAll('{{completed_count}}', context.completedCount.toString())
        .replaceAll('{{pending_habits}}', context.pendingHabitNames.join(', '))
        .replaceAll('{{streak_count}}', context.currentStreak.toString())
        .replaceAll('{{longest_streak}}', context.longestStreak.toString())
        .replaceAll('{{completion_rate}}',
            '${(context.completionRate7Days * 100).toStringAsFixed(0)}%');
  }

  /// Sample reference quotes for a persona (for use in prompt training)
  List<String> sampleReferenceQuotes(AIArchetype archetype, {int count = 5}) {
    return _personaRepository.getReferenceSamples(archetype, count: count);
  }

  /// Get scenario-specific example messages
  List<String> getScenarioExamples(
    AIArchetype archetype,
    InterventionCategory category,
  ) {
    return _personaRepository.getScenarioExamples(archetype, category);
  }

  /// Build a simplified prompt (for testing or fallback)
  String buildSimplePrompt({
    required AIArchetype archetype,
    required String scenario,
    required Map<String, dynamic> context,
  }) {
    final systemPrompt = _personaRepository.getSystemPrompt(archetype);
    final quotes = _personaRepository.getReferenceSamples(archetype, count: 3);

    final buffer = StringBuffer();
    buffer.writeln('System: $systemPrompt');
    buffer.writeln();
    buffer.writeln('Voice Examples:');
    for (final quote in quotes) {
      buffer.writeln('- "$quote"');
    }
    buffer.writeln();
    buffer.writeln('Context: $context');
    buffer.writeln();
    buffer.writeln(
        'Task: Generate a short motivational message for $scenario scenario (under 140 chars). Add 1 emoji at the end.');

    return buffer.toString();
  }
}
