import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'notification_intervention_category.dart';

part 'notification_preferences.g.dart';

/// Comprehensive notification preferences for the AI notification system
/// Based on AI_NOTIFICATION_SYSTEM_SPEC.md Section 4.2
@HiveType(typeId: 18)
class NotificationPreferences {
  @HiveField(0)
  final String userId;

  /// Master toggle for all AI notifications
  @HiveField(1)
  final bool aiNotificationsEnabled;

  /// Daily limit cap (1-10 notifications per day)
  @HiveField(2)
  final int dailyNotificationLimit;

  /// Quiet hours - no notifications during these times
  @HiveField(3)
  final String quietHoursStart; // Format: "22:00"

  @HiveField(4)
  final String quietHoursEnd; // Format: "07:00"

  /// Per-category preferences
  @HiveField(5)
  final Map<String, CategoryPreferences> categoryPreferences;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  const NotificationPreferences({
    required this.userId,
    this.aiNotificationsEnabled = true,
    this.dailyNotificationLimit = 5,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    required this.categoryPreferences,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create default preferences with all categories enabled
  factory NotificationPreferences.defaultPreferences(String userId) {
    final now = DateTime.now();
    final categoryPrefs = <String, CategoryPreferences>{};

    // Initialize all categories with default settings
    for (final category in InterventionCategory.values) {
      categoryPrefs[category.name] = CategoryPreferences(
        category: category,
        enabled: true,
        customSettings: category.defaultSettings,
      );
    }

    return NotificationPreferences(
      userId: userId,
      aiNotificationsEnabled: true,
      dailyNotificationLimit: 5,
      quietHoursStart: '22:00',
      quietHoursEnd: '07:00',
      categoryPreferences: categoryPrefs,
      createdAt: now,
      updatedAt: now,
    );
  }

  NotificationPreferences copyWith({
    String? userId,
    bool? aiNotificationsEnabled,
    int? dailyNotificationLimit,
    String? quietHoursStart,
    String? quietHoursEnd,
    Map<String, CategoryPreferences>? categoryPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPreferences(
      userId: userId ?? this.userId,
      aiNotificationsEnabled:
          aiNotificationsEnabled ?? this.aiNotificationsEnabled,
      dailyNotificationLimit:
          dailyNotificationLimit ?? this.dailyNotificationLimit,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      categoryPreferences: categoryPreferences ?? this.categoryPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Update a specific category preference
  NotificationPreferences updateCategoryPreference(
    InterventionCategory category,
    CategoryPreferences preferences,
  ) {
    final updatedPrefs = Map<String, CategoryPreferences>.from(
      categoryPreferences,
    );
    updatedPrefs[category.name] = preferences;

    return copyWith(
      categoryPreferences: updatedPrefs,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if a specific category is enabled
  bool isCategoryEnabled(InterventionCategory category) {
    if (!aiNotificationsEnabled) return false;
    final pref = categoryPreferences[category.name];
    return pref?.enabled ?? false;
  }

  /// Get custom settings for a category
  Map<String, dynamic> getCategorySettings(InterventionCategory category) {
    final pref = categoryPreferences[category.name];
    return pref?.customSettings ?? category.defaultSettings;
  }

  /// Check if current time is within quiet hours
  bool isInQuietHours(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final currentMinutes = hour * 60 + minute;

    final startParts = quietHoursStart.split(':');
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);

    final endParts = quietHoursEnd.split(':');
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    // Handle case where quiet hours span midnight
    if (startMinutes > endMinutes) {
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'aiNotificationsEnabled': aiNotificationsEnabled,
        'dailyNotificationLimit': dailyNotificationLimit,
        'quietHoursStart': quietHoursStart,
        'quietHoursEnd': quietHoursEnd,
        'categoryPreferences': categoryPreferences
            .map((key, value) => MapEntry(key, value.toJson())),
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      };

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final categoryPrefsMap =
        json['categoryPreferences'] as Map<String, dynamic>? ?? {};
    final categoryPrefs = categoryPrefsMap.map(
      (key, value) => MapEntry(
        key,
        CategoryPreferences.fromJson(value as Map<String, dynamic>),
      ),
    );

    return NotificationPreferences(
      userId: json['userId'] as String,
      aiNotificationsEnabled: json['aiNotificationsEnabled'] as bool? ?? true,
      dailyNotificationLimit: json['dailyNotificationLimit'] as int? ?? 5,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
      categoryPreferences: categoryPrefs,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
