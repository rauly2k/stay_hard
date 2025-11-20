import '../../../ai_notifications/data/models/ai_notification_config.dart';

/// Structured prompt template for LLM generation
/// Based on AI_PERSONA_ENHANCEMENT_IMPLEMENTATION.md
class PromptTemplate {
  final String roleDefinition;
  final List<String> referenceExamples;
  final Map<String, dynamic> currentContext;
  final String taskInstruction;

  const PromptTemplate({
    required this.roleDefinition,
    required this.referenceExamples,
    required this.currentContext,
    required this.taskInstruction,
  });

  /// Build the complete prompt string for LLM
  String buildPrompt() {
    final buffer = StringBuffer();

    // Role Definition
    buffer.writeln('[ROLE DEFINITION]');
    buffer.writeln(roleDefinition);
    buffer.writeln();

    // Reference Examples
    if (referenceExamples.isNotEmpty) {
      buffer.writeln('[REFERENCE EXAMPLES]');
      for (final quote in referenceExamples) {
        buffer.writeln('- "$quote"');
      }
      buffer.writeln();
    }

    // Current Context
    buffer.writeln('[CURRENT CONTEXT]');
    currentContext.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });
    buffer.writeln();

    // Task
    buffer.writeln('[TASK]');
    buffer.writeln(taskInstruction);

    return buffer.toString();
  }

  /// Create a copy with updated values
  PromptTemplate copyWith({
    String? roleDefinition,
    List<String>? referenceExamples,
    Map<String, dynamic>? currentContext,
    String? taskInstruction,
  }) {
    return PromptTemplate(
      roleDefinition: roleDefinition ?? this.roleDefinition,
      referenceExamples: referenceExamples ?? this.referenceExamples,
      currentContext: currentContext ?? this.currentContext,
      taskInstruction: taskInstruction ?? this.taskInstruction,
    );
  }
}
