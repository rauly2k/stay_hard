import 'package:hive/hive.dart';

part 'notification_intervention_category.g.dart';

/// The 7 distinct intervention categories for AI notifications
/// Based on AI_NOTIFICATION_SYSTEM_SPEC.md Section 1.1
@HiveType(typeId: 16)
enum InterventionCategory {
  @HiveField(0)
  morningMotivation,

  @HiveField(1)
  missedHabitRecovery,

  @HiveField(2)
  lowMoraleBoost,

  @HiveField(3)
  streakCelebration,

  @HiveField(4)
  eveningCheckIn,

  @HiveField(5)
  comebackSupport,

  @HiveField(6)
  progressInsights,
}

/// Category-specific settings for each intervention type
@HiveType(typeId: 17)
class CategoryPreferences {
  @HiveField(0)
  final InterventionCategory category;

  @HiveField(1)
  final bool enabled;

  @HiveField(2)
  final Map<String, dynamic> customSettings;

  const CategoryPreferences({
    required this.category,
    this.enabled = true,
    this.customSettings = const {},
  });

  CategoryPreferences copyWith({
    InterventionCategory? category,
    bool? enabled,
    Map<String, dynamic>? customSettings,
  }) {
    return CategoryPreferences(
      category: category ?? this.category,
      enabled: enabled ?? this.enabled,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category.name,
        'enabled': enabled,
        'customSettings': customSettings,
      };

  factory CategoryPreferences.fromJson(Map<String, dynamic> json) {
    return CategoryPreferences(
      category: InterventionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => InterventionCategory.morningMotivation,
      ),
      enabled: json['enabled'] as bool? ?? true,
      customSettings:
          Map<String, dynamic>.from(json['customSettings'] as Map? ?? {}),
    );
  }
}

/// Extension to provide metadata for each intervention category
extension InterventionCategoryExtension on InterventionCategory {
  String get displayName {
    switch (this) {
      case InterventionCategory.morningMotivation:
        return 'Morning Motivation';
      case InterventionCategory.missedHabitRecovery:
        return 'Missed Habit Recovery';
      case InterventionCategory.lowMoraleBoost:
        return 'Low Morale Boost';
      case InterventionCategory.streakCelebration:
        return 'Streak Celebration';
      case InterventionCategory.eveningCheckIn:
        return 'Evening Check-in';
      case InterventionCategory.comebackSupport:
        return 'Comeback Support';
      case InterventionCategory.progressInsights:
        return 'Progress Insights';
    }
  }

  String get description {
    switch (this) {
      case InterventionCategory.morningMotivation:
        return 'Start your day with AI-generated inspiration';
      case InterventionCategory.missedHabitRecovery:
        return 'See how we help you get back on track';
      case InterventionCategory.lowMoraleBoost:
        return 'Encouragement during tough times';
      case InterventionCategory.streakCelebration:
        return 'Celebrate your milestones';
      case InterventionCategory.eveningCheckIn:
        return 'Reflect on your day';
      case InterventionCategory.comebackSupport:
        return 'Welcome back after time away from the app';
      case InterventionCategory.progressInsights:
        return 'Weekly habit analysis and personalized tips';
    }
  }

  String get icon {
    switch (this) {
      case InterventionCategory.morningMotivation:
        return '🌅';
      case InterventionCategory.missedHabitRecovery:
        return '🔄';
      case InterventionCategory.lowMoraleBoost:
        return '📉';
      case InterventionCategory.streakCelebration:
        return '🏆';
      case InterventionCategory.eveningCheckIn:
        return '🌙';
      case InterventionCategory.comebackSupport:
        return '🚀';
      case InterventionCategory.progressInsights:
        return '📊';
    }
  }

  /// Default settings for each category
  Map<String, dynamic> get defaultSettings {
    switch (this) {
      case InterventionCategory.morningMotivation:
        return {'time': '08:00'};
      case InterventionCategory.missedHabitRecovery:
        return {'triggerAfterDays': 2};
      case InterventionCategory.lowMoraleBoost:
        return {'sensitivity': 'medium', 'maxPerWeek': 2};
      case InterventionCategory.streakCelebration:
        return {
          'milestones': [7, 14, 30, 60, 100, 365]
        };
      case InterventionCategory.eveningCheckIn:
        return {'time': '20:00'};
      case InterventionCategory.comebackSupport:
        return {'inactiveDays': 7};
      case InterventionCategory.progressInsights:
        return {'frequency': 'weekly'}; // 'weekly' or 'monthly'
    }
  }
}
