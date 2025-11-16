import 'package:cloud_firestore/cloud_firestore.dart';

/// Time of day categories for habits
enum TimeOfDayEnum {
  morning,
  afternoon,
  evening,
  anytime,
}

/// Repeat configuration for habits
class RepeatConfig {
  final bool isDaily;
  final List<int>? specificDays; // 1-7 for Mon-Sun
  final int? intervalDays; // Every N days

  const RepeatConfig({
    required this.isDaily,
    this.specificDays,
    this.intervalDays,
  });

  factory RepeatConfig.daily() => const RepeatConfig(isDaily: true);

  factory RepeatConfig.specificDays(List<int> days) => RepeatConfig(
        isDaily: false,
        specificDays: days,
      );

  factory RepeatConfig.interval(int days) => RepeatConfig(
        isDaily: false,
        intervalDays: days,
      );

  Map<String, dynamic> toJson() => {
        'isDaily': isDaily,
        'specificDays': specificDays,
        'intervalDays': intervalDays,
      };

  factory RepeatConfig.fromJson(Map<String, dynamic> json) {
    return RepeatConfig(
      isDaily: json['isDaily'] as bool,
      specificDays: (json['specificDays'] as List<dynamic>?)?.cast<int>(),
      intervalDays: json['intervalDays'] as int?,
    );
  }
}

/// User's habit instance (created from a template)
class Habit {
  final String id;
  final String userId;
  final String templateId; // Reference to HabitTemplate
  final Map<String, dynamic> configuration; // Time, duration, quantity, etc.
  final String description;
  final String soundId;
  final RepeatConfig repeatConfig;
  final List<TimeOfDayEnum> timeOfDay;
  final List<String> specificReminders; // Times like "06:00", "14:30"
  final Map<String, bool> completionLog; // date -> completed
  final DateTime createdAt;
  final bool isActive;
  final int sortOrder;
  final bool notificationsEnabled;
  final bool aiCoachEnabled;

  const Habit({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.configuration,
    required this.description,
    required this.soundId,
    required this.repeatConfig,
    required this.timeOfDay,
    required this.specificReminders,
    required this.completionLog,
    required this.createdAt,
    required this.isActive,
    required this.sortOrder,
    required this.notificationsEnabled,
    required this.aiCoachEnabled,
  });

  Habit copyWith({
    String? id,
    String? userId,
    String? templateId,
    Map<String, dynamic>? configuration,
    String? description,
    String? soundId,
    RepeatConfig? repeatConfig,
    List<TimeOfDayEnum>? timeOfDay,
    List<String>? specificReminders,
    Map<String, bool>? completionLog,
    DateTime? createdAt,
    bool? isActive,
    int? sortOrder,
    bool? notificationsEnabled,
    bool? aiCoachEnabled,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      templateId: templateId ?? this.templateId,
      configuration: configuration ?? this.configuration,
      description: description ?? this.description,
      soundId: soundId ?? this.soundId,
      repeatConfig: repeatConfig ?? this.repeatConfig,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      specificReminders: specificReminders ?? this.specificReminders,
      completionLog: completionLog ?? this.completionLog,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      aiCoachEnabled: aiCoachEnabled ?? this.aiCoachEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'templateId': templateId,
        'configuration': configuration,
        'description': description,
        'soundId': soundId,
        'repeatConfig': repeatConfig.toJson(),
        'timeOfDay': timeOfDay.map((t) => t.name).toList(),
        'specificReminders': specificReminders,
        'completionLog': completionLog,
        'createdAt': Timestamp.fromDate(createdAt),
        'isActive': isActive,
        'sortOrder': sortOrder,
        'notificationsEnabled': notificationsEnabled,
        'aiCoachEnabled': aiCoachEnabled,
      };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      templateId: json['templateId'] as String,
      configuration:
          Map<String, dynamic>.from(json['configuration'] as Map? ?? {}),
      description: json['description'] as String? ?? '',
      soundId: json['soundId'] as String? ?? 'default',
      repeatConfig: RepeatConfig.fromJson(
        json['repeatConfig'] as Map<String, dynamic>? ?? {'isDaily': true},
      ),
      timeOfDay: (json['timeOfDay'] as List<dynamic>?)
              ?.map((t) => TimeOfDayEnum.values.firstWhere(
                    (e) => e.name == t,
                    orElse: () => TimeOfDayEnum.anytime,
                  ))
              .toList() ??
          [TimeOfDayEnum.anytime],
      specificReminders:
          (json['specificReminders'] as List<dynamic>?)?.cast<String>() ?? [],
      completionLog:
          Map<String, bool>.from(json['completionLog'] as Map? ?? {}),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      aiCoachEnabled: json['aiCoachEnabled'] as bool? ?? false,
    );
  }
}
