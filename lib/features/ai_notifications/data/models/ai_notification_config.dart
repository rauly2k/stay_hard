import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'ai_notification_config.g.dart';

/// AI Archetype - Different AI personality types
@HiveType(typeId: 11)
enum AIArchetype {
  @HiveField(0)
  drillSergeant,

  @HiveField(1)
  wiseMentor,

  @HiveField(2)
  friendlyCoach,

  @HiveField(3)
  motivationalSpeaker,

  @HiveField(4)
  philosopher,

  @HiveField(5)
  humorousFriend,

  @HiveField(6)
  competitor,

  @HiveField(7)
  growthGuide,
}

/// AI Intensity - How often notifications are sent
@HiveType(typeId: 12)
enum AIIntensity {
  @HiveField(0)
  low, // 1-2 notifications/day

  @HiveField(1)
  medium, // 2-3 notifications/day

  @HiveField(2)
  high, // 3-5 notifications/day
}

/// Notification Scenario - Different contexts for notifications
@HiveType(typeId: 14)
enum NotificationScenario {
  @HiveField(0)
  morningMotivation,

  @HiveField(1)
  middayCheckIn,

  @HiveField(2)
  eveningReflection,

  @HiveField(3)
  streakMilestone,

  @HiveField(4)
  streakRecovery,

  @HiveField(5)
  goalDeadlineApproaching,

  @HiveField(6)
  habitRecommendation,

  @HiveField(7)
  encouragement,

  @HiveField(8)
  urgentAccountability,

  @HiveField(9)
  celebration,

  @HiveField(10)
  customTiming,
}

/// Notification Action - What user did with notification
@HiveType(typeId: 15)
enum NotificationAction {
  @HiveField(0)
  dismissed,

  @HiveField(1)
  viewedHabits,

  @HiveField(2)
  completedHabit,

  @HiveField(3)
  openedApp,

  @HiveField(4)
  changedSettings,

  @HiveField(5)
  ignored, // Notification expired
}

/// AI Notification Configuration Model
@HiveType(typeId: 10)
class AINotificationConfig {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final AIArchetype archetype;

  @HiveField(2)
  final AIIntensity intensity;

  @HiveField(3)
  final bool isEnabled;

  @HiveField(4)
  final DateTime onboardingCompletedAt;

  @HiveField(5)
  final List<int> preferredNotificationHours;

  @HiveField(6)
  final List<int> quietHours;

  @HiveField(7)
  final DateTime? lastModified;

  const AINotificationConfig({
    required this.userId,
    required this.archetype,
    required this.intensity,
    this.isEnabled = true,
    required this.onboardingCompletedAt,
    this.preferredNotificationHours = const [7, 13, 20],
    this.quietHours = const [22, 23, 0, 1, 2, 3, 4, 5, 6],
    this.lastModified,
  });

  AINotificationConfig copyWith({
    String? userId,
    AIArchetype? archetype,
    AIIntensity? intensity,
    bool? isEnabled,
    DateTime? onboardingCompletedAt,
    List<int>? preferredNotificationHours,
    List<int>? quietHours,
    DateTime? lastModified,
  }) {
    return AINotificationConfig(
      userId: userId ?? this.userId,
      archetype: archetype ?? this.archetype,
      intensity: intensity ?? this.intensity,
      isEnabled: isEnabled ?? this.isEnabled,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
      preferredNotificationHours:
          preferredNotificationHours ?? this.preferredNotificationHours,
      quietHours: quietHours ?? this.quietHours,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'archetype': archetype.name,
        'intensity': intensity.name,
        'isEnabled': isEnabled,
        'onboardingCompletedAt': Timestamp.fromDate(onboardingCompletedAt),
        'preferredNotificationHours': preferredNotificationHours,
        'quietHours': quietHours,
        'lastModified':
            lastModified != null ? Timestamp.fromDate(lastModified!) : null,
      };

  factory AINotificationConfig.fromJson(Map<String, dynamic> json) {
    return AINotificationConfig(
      userId: json['userId'] as String,
      archetype: AIArchetype.values.firstWhere(
        (e) => e.name == json['archetype'],
        orElse: () => AIArchetype.friendlyCoach,
      ),
      intensity: AIIntensity.values.firstWhere(
        (e) => e.name == json['intensity'],
        orElse: () => AIIntensity.medium,
      ),
      isEnabled: json['isEnabled'] as bool? ?? true,
      onboardingCompletedAt:
          (json['onboardingCompletedAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
      preferredNotificationHours:
          (json['preferredNotificationHours'] as List<dynamic>?)?.cast<int>() ??
              [7, 13, 20],
      quietHours: (json['quietHours'] as List<dynamic>?)?.cast<int>() ??
          [22, 23, 0, 1, 2, 3, 4, 5, 6],
      lastModified: (json['lastModified'] as Timestamp?)?.toDate(),
    );
  }
}

/// AI Notification Record - History of sent notifications
@HiveType(typeId: 13)
class AINotificationRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final AIArchetype archetype;

  @HiveField(4)
  final NotificationScenario scenario;

  @HiveField(5)
  final DateTime scheduledTime;

  @HiveField(6)
  final DateTime? sentAt;

  @HiveField(7)
  final DateTime? viewedAt;

  @HiveField(8)
  final DateTime? dismissedAt;

  @HiveField(9)
  final NotificationAction? actionTaken;

  @HiveField(10)
  final Map<String, dynamic> contextSnapshot;

  const AINotificationRecord({
    required this.id,
    required this.userId,
    required this.message,
    required this.archetype,
    required this.scenario,
    required this.scheduledTime,
    this.sentAt,
    this.viewedAt,
    this.dismissedAt,
    this.actionTaken,
    this.contextSnapshot = const {},
  });

  AINotificationRecord copyWith({
    String? id,
    String? userId,
    String? message,
    AIArchetype? archetype,
    NotificationScenario? scenario,
    DateTime? scheduledTime,
    DateTime? sentAt,
    DateTime? viewedAt,
    DateTime? dismissedAt,
    NotificationAction? actionTaken,
    Map<String, dynamic>? contextSnapshot,
  }) {
    return AINotificationRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      archetype: archetype ?? this.archetype,
      scenario: scenario ?? this.scenario,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      sentAt: sentAt ?? this.sentAt,
      viewedAt: viewedAt ?? this.viewedAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      actionTaken: actionTaken ?? this.actionTaken,
      contextSnapshot: contextSnapshot ?? this.contextSnapshot,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'message': message,
        'archetype': archetype.name,
        'scenario': scenario.name,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'sentAt': sentAt != null ? Timestamp.fromDate(sentAt!) : null,
        'viewedAt': viewedAt != null ? Timestamp.fromDate(viewedAt!) : null,
        'dismissedAt':
            dismissedAt != null ? Timestamp.fromDate(dismissedAt!) : null,
        'actionTaken': actionTaken?.name,
        'contextSnapshot': contextSnapshot,
      };

  factory AINotificationRecord.fromJson(Map<String, dynamic> json) {
    return AINotificationRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      archetype: AIArchetype.values.firstWhere(
        (e) => e.name == json['archetype'],
        orElse: () => AIArchetype.friendlyCoach,
      ),
      scenario: NotificationScenario.values.firstWhere(
        (e) => e.name == json['scenario'],
        orElse: () => NotificationScenario.customTiming,
      ),
      scheduledTime: (json['scheduledTime'] as Timestamp).toDate(),
      sentAt: (json['sentAt'] as Timestamp?)?.toDate(),
      viewedAt: (json['viewedAt'] as Timestamp?)?.toDate(),
      dismissedAt: (json['dismissedAt'] as Timestamp?)?.toDate(),
      actionTaken: json['actionTaken'] != null
          ? NotificationAction.values.firstWhere(
              (e) => e.name == json['actionTaken'],
              orElse: () => NotificationAction.ignored,
            )
          : null,
      contextSnapshot:
          Map<String, dynamic>.from(json['contextSnapshot'] as Map? ?? {}),
    );
  }
}

/// Notification Context - Snapshot of user state when notification is sent
class NotificationContext {
  final String userId;
  final NotificationScenario scenario;
  final DateTime timestamp;
  final int totalHabitsToday;
  final int completedCount;
  final List<String> pendingHabitNames;
  final int currentStreak;
  final int longestStreak;
  final double completionRate7Days;
  final String timeOfDay;

  const NotificationContext({
    required this.userId,
    required this.scenario,
    required this.timestamp,
    required this.totalHabitsToday,
    required this.completedCount,
    required this.pendingHabitNames,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionRate7Days,
    required this.timeOfDay,
  });

  double get completionPercentage =>
      totalHabitsToday > 0 ? completedCount / totalHabitsToday : 0.0;

  bool get streakAtRisk => completedCount == 0 && timestamp.hour >= 20;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'scenario': scenario.name,
        'timestamp': timestamp.toIso8601String(),
        'totalHabitsToday': totalHabitsToday,
        'completedCount': completedCount,
        'pendingHabitNames': pendingHabitNames,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'completionRate7Days': completionRate7Days,
        'timeOfDay': timeOfDay,
      };

  factory NotificationContext.fromJson(Map<String, dynamic> json) {
    return NotificationContext(
      userId: json['userId'] as String,
      scenario: NotificationScenario.values.firstWhere(
        (e) => e.name == json['scenario'],
        orElse: () => NotificationScenario.customTiming,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalHabitsToday: json['totalHabitsToday'] as int,
      completedCount: json['completedCount'] as int,
      pendingHabitNames:
          (json['pendingHabitNames'] as List<dynamic>).cast<String>(),
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      completionRate7Days: (json['completionRate7Days'] as num).toDouble(),
      timeOfDay: json['timeOfDay'] as String,
    );
  }
}
