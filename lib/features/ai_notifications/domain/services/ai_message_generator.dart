import 'package:google_generative_ai/google_generative_ai.dart';
import '../../data/models/ai_notification_config.dart';

/// Service for generating AI messages using Gemini API
class AIMessageGenerator {
  final GenerativeModel _model;
  final Map<String, String> _messageCache = {};

  AIMessageGenerator({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        );

  /// Generate a personalized notification message
  Future<String> generateMessage({
    required NotificationContext context,
    required AIArchetype archetype,
    required AIIntensity intensity,
  }) async {
    // Check cache first
    final cacheKey = _buildCacheKey(context, archetype);
    if (_messageCache.containsKey(cacheKey)) {
      return _messageCache[cacheKey]!;
    }

    try {
      // Build prompt
      final prompt = _buildPrompt(context, archetype, intensity);

      // Call Gemini API
      final response = await _model.generateContent([Content.text(prompt)]);
      final message = _parseResponse(response);

      // Cache the message
      _messageCache[cacheKey] = message;

      // Limit cache size
      if (_messageCache.length > 100) {
        _messageCache.remove(_messageCache.keys.first);
      }

      return message;
    } catch (e) {
      print('Error generating AI message: $e');
      // Fallback to pre-generated message
      return _getFallbackMessage(context, archetype);
    }
  }

  /// Build the prompt for Gemini based on context and archetype
  String _buildPrompt(
    NotificationContext context,
    AIArchetype archetype,
    AIIntensity intensity,
  ) {
    final archetypePrompt = _getArchetypePrompt(archetype);
    final intensityDesc = _getIntensityDescription(intensity);
    final scenarioGuidance = _getScenarioGuidance(context.scenario);

    return '''
System Role: $archetypePrompt

User Context:
- Total habits today: ${context.totalHabitsToday}
- Completed: ${context.completedCount}
- Pending habits: ${context.pendingHabitNames.join(", ")}
- Current streak: ${context.currentStreak} days
- Time of day: ${context.timeOfDay}
- Scenario: ${context.scenario.name}

Instruction:
Generate a $intensityDesc motivational message in the archetype's voice.
$scenarioGuidance
Keep under 60 words.
Use 1 relevant emoji at the end.
Be authentic to the archetype's personality.
Do not use quotes or special formatting.

Message:
''';
  }

  /// Get archetype-specific system prompt
  String _getArchetypePrompt(AIArchetype archetype) {
    switch (archetype) {
      case AIArchetype.drillSergeant:
        return 'You are a tough, commanding drill sergeant. Use military terminology, '
            'short punchy commands, and high energy. Call the user "soldier" or "recruit". '
            'Zero tolerance for excuses. Tough love approach.';

      case AIArchetype.wiseMentor:
        return 'You are a wise, calm mentor inspired by Stoic philosophy. '
            'Use philosophical insights, reflective wisdom, and provide deep guidance. '
            'Reference ancient wisdom when appropriate. Patient and understanding tone.';

      case AIArchetype.friendlyCoach:
        return 'You are a supportive, enthusiastic coach. Use "we" language, '
            'celebrate every win, provide lots of encouragement. Warm, empathetic, '
            'and genuinely excited about the user\'s progress. Like a best friend who believes in you.';

      case AIArchetype.motivationalSpeaker:
        return 'You are a high-energy motivational speaker (Tony Robbins style). '
            'Use emphasis, exclamation points, dramatic language. '
            'Call to greatness and vision. Inspirational and passionate.';

      case AIArchetype.philosopher:
        return 'You are a thoughtful philosopher. Ask profound questions, '
            'explore meaning and purpose, reference great thinkers (Nietzsche, Plato, Kierkegaard). '
            'Deep, contemplative, intellectual depth.';

      case AIArchetype.humorousFriend:
        return 'You are a funny, light-hearted friend. Use humor, pop culture references, '
            'puns, and playful language. Make the user smile while motivating them. '
            'Keep it fun and relatable.';

      case AIArchetype.competitor:
        return 'You are a competitive sports coach. Use sports metaphors, '
            'scoreboard language, performance metrics. Frame everything as wins/losses. '
            'Championship mentality. Results-driven.';

      case AIArchetype.growthGuide:
        return 'You are a nurturing growth guide focused on process over outcome. '
            'Use growth mindset language, celebrate learning from failures, '
            'emphasize long-term transformation. Patient and developmental.';
    }
  }

  /// Get intensity description
  String _getIntensityDescription(AIIntensity intensity) {
    switch (intensity) {
      case AIIntensity.low:
        return 'gentle and encouraging';
      case AIIntensity.medium:
        return 'balanced and motivating';
      case AIIntensity.high:
        return 'intense and demanding';
    }
  }

  /// Get scenario-specific guidance
  String _getScenarioGuidance(NotificationScenario scenario) {
    switch (scenario) {
      case NotificationScenario.morningMotivation:
        return 'Focus on energizing the user to start their day strong. '
            'Mention their pending morning habits if relevant.';

      case NotificationScenario.middayCheckIn:
        return 'Provide a progress update. If behind, gently push. '
            'If ahead, celebrate and encourage them to finish strong.';

      case NotificationScenario.eveningReflection:
        return 'Reflect on the day. If all complete, celebrate. '
            'If incomplete, encourage finishing remaining habits before bed.';

      case NotificationScenario.streakMilestone:
        return 'Celebrate this major achievement! Make it feel special. '
            'Challenge them to reach the next milestone.';

      case NotificationScenario.streakRecovery:
        return 'Empathetic and encouraging. Reframe the broken streak as learning. '
            'Highlight their longest streak as proof of capability.';

      case NotificationScenario.urgentAccountability:
        return 'Urgent tone. Emphasize the risk of breaking streak. '
            'Call to immediate action.';

      case NotificationScenario.celebration:
        return 'High energy celebration of their accomplishment. '
            'Make them feel proud.';

      default:
        return 'Provide contextually relevant motivation.';
    }
  }

  /// Parse response from Gemini
  String _parseResponse(GenerateContentResponse response) {
    final text = response.text ?? '';
    return text.trim();
  }

  /// Build cache key
  String _buildCacheKey(NotificationContext context, AIArchetype archetype) {
    return '${archetype.name}_${context.scenario.name}_${context.completedCount}_${context.totalHabitsToday}';
  }

  /// Get fallback message if AI generation fails
  String _getFallbackMessage(
    NotificationContext context,
    AIArchetype archetype,
  ) {
    final completionPercentage = context.completionPercentage * 100;

    // Simple fallback messages per archetype
    switch (archetype) {
      case AIArchetype.drillSergeant:
        if (context.completedCount == 0) {
          return 'Time to move, soldier! ${context.totalHabitsToday} habits waiting. No excuses! 💪';
        } else if (completionPercentage >= 80) {
          return 'Outstanding progress! Keep pushing to 100%! 🎖️';
        } else {
          return 'You\'re at ${context.completedCount}/${context.totalHabitsToday}. Finish the mission! 💪';
        }

      case AIArchetype.friendlyCoach:
        if (context.completedCount == 0) {
          return 'Hey friend! Ready to tackle today\'s habits? You\'ve got this! 🎯';
        } else if (completionPercentage >= 80) {
          return 'You\'re crushing it! ${context.completedCount}/${context.totalHabitsToday} done! So proud! 🌟';
        } else {
          return 'Great progress! ${context.completedCount} down, let\'s keep the momentum! 💙';
        }

      default:
        return 'You\'ve completed ${context.completedCount}/${context.totalHabitsToday} habits today. Keep going! ⭐';
    }
  }
}
