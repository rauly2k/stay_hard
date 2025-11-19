import '../../data/models/ai_notification_config.dart';

/// Repository interface for AI Notification configuration
abstract class AINotificationRepository {
  /// Get user's AI notification configuration
  Future<AINotificationConfig?> getConfig(String userId);

  /// Save or update AI notification configuration
  Future<void> saveConfig(AINotificationConfig config);

  /// Update specific fields of configuration
  Future<void> updateConfig(
    String userId, {
    AIArchetype? archetype,
    AIIntensity? intensity,
    bool? isEnabled,
    List<int>? preferredHours,
    List<int>? quietHours,
  });

  /// Delete configuration (disable AI notifications)
  Future<void> deleteConfig(String userId);

  /// Watch configuration changes (for reactive UI)
  Stream<AINotificationConfig?> watchConfig(String userId);

  /// Save notification record to history
  Future<void> saveNotificationRecord(AINotificationRecord record);

  /// Get notification history for user
  Future<List<AINotificationRecord>> getNotificationHistory(
    String userId, {
    int limit = 50,
  });

  /// Get notification statistics (for analytics)
  Future<Map<String, dynamic>> getNotificationStats(String userId);
}
