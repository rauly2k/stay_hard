import 'package:flutter/foundation.dart';

/// Question types for the questionnaire
enum QuestionType {
  singleChoice,
  multiChoice,
  scale,
}

/// A single questionnaire question
@immutable
class QuestionnaireQuestion {
  final String id;
  final String question;
  final String? subtitle;
  final QuestionType type;
  final List<String> options;
  final String? scaleMinLabel;
  final String? scaleMaxLabel;

  const QuestionnaireQuestion({
    required this.id,
    required this.question,
    this.subtitle,
    required this.type,
    required this.options,
    this.scaleMinLabel,
    this.scaleMaxLabel,
  });
}

/// User's answers to the questionnaire
class UserAnswers {
  final Map<String, dynamic> responses;

  const UserAnswers({this.responses = const {}});

  UserAnswers copyWith({Map<String, dynamic>? responses}) {
    return UserAnswers(
      responses: responses ?? this.responses,
    );
  }

  /// Get answer for a specific question
  dynamic getAnswer(String questionId) {
    return responses[questionId];
  }

  /// Get progress (0.0 to 1.0)
  double getProgress(int totalQuestions) {
    return responses.length / totalQuestions;
  }

  /// Check if all questions are answered
  bool isComplete(int totalQuestions) {
    return responses.length == totalQuestions;
  }

  Map<String, dynamic> toJson() => responses;

  factory UserAnswers.fromJson(Map<String, dynamic> json) {
    return UserAnswers(responses: json);
  }
}
