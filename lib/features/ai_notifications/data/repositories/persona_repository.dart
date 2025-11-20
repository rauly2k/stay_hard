import '../models/ai_notification_config.dart';
import '../models/notification_intervention_category.dart';
import '../models/persona_definition.dart';
import '../constants/persona_data.dart';

/// Repository for accessing persona data
/// Provides comprehensive persona definitions, quotes, and examples
/// Based on AI_PERSONA_ENHANCEMENT_IMPLEMENTATION.md
class PersonaRepository {
  /// Get complete persona definition for an archetype
  PersonaDefinition getPersonaDefinition(AIArchetype archetype) {
    return PersonaDefinition(
      archetype: archetype,
      systemPrompt: PERSONA_SYSTEM_PROMPTS[archetype]!,
      referenceQuotes: PERSONA_REFERENCE_QUOTES[archetype]!,
      influences: PERSONA_INFLUENCES[archetype]!,
      scenarioExamples: PERSONA_SCENARIO_EXAMPLES[archetype]!,
    );
  }

  /// Get all persona definitions
  List<PersonaDefinition> getAllPersonaDefinitions() {
    return AIArchetype.values
        .map((archetype) => getPersonaDefinition(archetype))
        .toList();
  }

  /// Get system prompt for a specific archetype
  String getSystemPrompt(AIArchetype archetype) {
    return PERSONA_SYSTEM_PROMPTS[archetype] ?? '';
  }

  /// Get random reference quotes for training (default: 5 samples)
  List<String> getReferenceSamples(AIArchetype archetype, {int count = 5}) {
    final quotes = PERSONA_REFERENCE_QUOTES[archetype] ?? [];
    if (quotes.length <= count) {
      return List.from(quotes);
    }

    final shuffled = List<String>.from(quotes)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Get scenario-specific example messages
  List<String> getScenarioExamples(
    AIArchetype archetype,
    InterventionCategory category,
  ) {
    final scenarioMap = PERSONA_SCENARIO_EXAMPLES[archetype];
    return scenarioMap?[category] ?? [];
  }

  /// Get a random example message for a specific scenario
  String? getRandomScenarioExample(
    AIArchetype archetype,
    InterventionCategory category,
  ) {
    final examples = getScenarioExamples(archetype, category);
    if (examples.isEmpty) return null;

    final shuffled = List<String>.from(examples)..shuffle();
    return shuffled.first;
  }

  /// Get all reference quotes for an archetype
  List<String> getAllReferenceQuotes(AIArchetype archetype) {
    return PERSONA_REFERENCE_QUOTES[archetype] ?? [];
  }

  /// Get influences (books, figures, characters) for an archetype
  Map<String, List<String>> getInfluences(AIArchetype archetype) {
    return PERSONA_INFLUENCES[archetype] ?? {};
  }

  /// Get list of influential figures for an archetype
  List<String> getInfluentialFigures(AIArchetype archetype) {
    final influences = getInfluences(archetype);
    return influences['figures'] ?? [];
  }

  /// Get list of influential books for an archetype
  List<String> getInfluentialBooks(AIArchetype archetype) {
    final influences = getInfluences(archetype);
    return influences['books'] ?? [];
  }

  /// Get list of character influences for an archetype
  List<String> getCharacterInfluences(AIArchetype archetype) {
    final influences = getInfluences(archetype);
    return influences['characters'] ?? [];
  }

  /// Check if persona has data available
  bool hasPersonaData(AIArchetype archetype) {
    return PERSONA_SYSTEM_PROMPTS.containsKey(archetype) &&
        PERSONA_REFERENCE_QUOTES.containsKey(archetype) &&
        PERSONA_SCENARIO_EXAMPLES.containsKey(archetype);
  }

  /// Get count of available examples for a scenario
  int getScenarioExampleCount(
    AIArchetype archetype,
    InterventionCategory category,
  ) {
    return getScenarioExamples(archetype, category).length;
  }

  /// Get all intervention categories that have examples for this persona
  List<InterventionCategory> getAvailableCategories(AIArchetype archetype) {
    final scenarioMap = PERSONA_SCENARIO_EXAMPLES[archetype];
    if (scenarioMap == null) return [];
    return scenarioMap.keys.toList();
  }
}
