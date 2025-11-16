import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_models.dart';

/// Notifier for user questionnaire answers
class UserAnswersNotifier extends Notifier<UserAnswers> {
  @override
  UserAnswers build() {
    return const UserAnswers();
  }

  /// Save answer for a specific question
  void saveAnswer(String questionId, dynamic value) {
    final updatedResponses = Map<String, dynamic>.from(state.responses);
    updatedResponses[questionId] = value;

    state = state.copyWith(responses: updatedResponses);
  }

  /// Clear all answers
  void clearAnswers() {
    state = const UserAnswers();
  }

  /// Reset to specific responses
  void setResponses(Map<String, dynamic> responses) {
    state = UserAnswers(responses: responses);
  }
}

/// Provider for user answers
final userAnswersProvider =
    NotifierProvider<UserAnswersNotifier, UserAnswers>(UserAnswersNotifier.new);
