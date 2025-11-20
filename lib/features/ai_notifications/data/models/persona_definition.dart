import '../../../ai_notifications/data/models/ai_notification_config.dart';
import '../../../ai_notifications/data/models/notification_intervention_category.dart';

/// Comprehensive persona definition with training data
/// Based on AI_PERSONA_ENHANCEMENT_IMPLEMENTATION.md
class PersonaDefinition {
  final AIArchetype archetype;
  final String systemPrompt;
  final List<String> referenceQuotes;
  final Map<String, List<String>> influences;
  final Map<InterventionCategory, List<String>> scenarioExamples;

  const PersonaDefinition({
    required this.archetype,
    required this.systemPrompt,
    required this.referenceQuotes,
    required this.influences,
    required this.scenarioExamples,
  });

  /// Get a random sample of reference quotes for prompt training
  List<String> sampleReferenceQuotes(int count) {
    if (referenceQuotes.length <= count) {
      return List.from(referenceQuotes);
    }

    final shuffled = List<String>.from(referenceQuotes)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Get scenario-specific example messages
  List<String> getScenarioExamples(InterventionCategory category) {
    return scenarioExamples[category] ?? [];
  }

  /// Get a random example message for a category
  String? getRandomExample(InterventionCategory category) {
    final examples = scenarioExamples[category];
    if (examples == null || examples.isEmpty) return null;

    final shuffled = List<String>.from(examples)..shuffle();
    return shuffled.first;
  }
}
