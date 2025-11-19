import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../../domain/repositories/ai_notification_repository.dart';
import '../models/ai_notification_config.dart';

/// Implementation of AI Notification Repository
class AINotificationRepositoryImpl implements AINotificationRepository {
  final Box<AINotificationConfig> _configBox;
  final FirebaseFirestore _firestore;

  AINotificationRepositoryImpl({
    required Box<AINotificationConfig> configBox,
    FirebaseFirestore? firestore,
  })  : _configBox = configBox,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AINotificationConfig?> getConfig(String userId) async {
    try {
      // Try Hive first (local cache)
      var config = _configBox.get(userId);
      if (config != null) return config;

      // Fallback to Firestore
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiNotificationConfig')
          .doc('config')
          .get();

      if (doc.exists && doc.data() != null) {
        config = AINotificationConfig.fromJson(doc.data()!);
        // Cache it locally
        await _configBox.put(userId, config);
        return config;
      }

      return null;
    } catch (e) {
      print('Error getting AI notification config: $e');
      return null;
    }
  }

  @override
  Future<void> saveConfig(AINotificationConfig config) async {
    try {
      // Save to Hive (local cache)
      await _configBox.put(config.userId, config);

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(config.userId)
          .collection('aiNotificationConfig')
          .doc('config')
          .set(config.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving AI notification config: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateConfig(
    String userId, {
    AIArchetype? archetype,
    AIIntensity? intensity,
    bool? isEnabled,
    List<int>? preferredHours,
    List<int>? quietHours,
  }) async {
    try {
      final existingConfig = await getConfig(userId);
      if (existingConfig == null) {
        throw Exception('Config not found for user $userId');
      }

      final updatedConfig = existingConfig.copyWith(
        archetype: archetype,
        intensity: intensity,
        isEnabled: isEnabled,
        preferredNotificationHours: preferredHours,
        quietHours: quietHours,
        lastModified: DateTime.now(),
      );

      await saveConfig(updatedConfig);
    } catch (e) {
      print('Error updating AI notification config: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteConfig(String userId) async {
    try {
      // Remove from Hive
      await _configBox.delete(userId);

      // Remove from Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiNotificationConfig')
          .doc('config')
          .delete();
    } catch (e) {
      print('Error deleting AI notification config: $e');
      rethrow;
    }
  }

  @override
  Stream<AINotificationConfig?> watchConfig(String userId) {
    // Watch Firestore for real-time updates
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('aiNotificationConfig')
        .doc('config')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final config = AINotificationConfig.fromJson(snapshot.data()!);
        // Update local cache
        _configBox.put(userId, config);
        return config;
      }
      return null;
    });
  }

  @override
  Future<void> saveNotificationRecord(AINotificationRecord record) async {
    try {
      await _firestore
          .collection('users')
          .doc(record.userId)
          .collection('aiNotificationHistory')
          .doc(record.id)
          .set(record.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving notification record: $e');
      rethrow;
    }
  }

  @override
  Future<List<AINotificationRecord>> getNotificationHistory(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiNotificationHistory')
          .orderBy('scheduledTime', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => AINotificationRecord.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting notification history: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getNotificationStats(String userId) async {
    try {
      final history = await getNotificationHistory(userId, limit: 100);

      if (history.isEmpty) {
        return {
          'totalSent': 0,
          'totalViewed': 0,
          'totalDismissed': 0,
          'engagementRate': 0.0,
          'averageTimeToAction': 0.0,
        };
      }

      final totalSent = history.length;
      final totalViewed = history.where((r) => r.viewedAt != null).length;
      final totalDismissed =
          history.where((r) => r.actionTaken == NotificationAction.dismissed).length;
      final totalActioned = history
          .where((r) =>
              r.actionTaken != null &&
              r.actionTaken != NotificationAction.dismissed &&
              r.actionTaken != NotificationAction.ignored)
          .length;

      final engagementRate = totalViewed / totalSent;

      // Calculate average time to action
      final actionTimes = history
          .where((r) => r.sentAt != null && r.viewedAt != null)
          .map((r) => r.viewedAt!.difference(r.sentAt!).inSeconds)
          .toList();

      final averageTimeToAction = actionTimes.isNotEmpty
          ? actionTimes.reduce((a, b) => a + b) / actionTimes.length
          : 0.0;

      return {
        'totalSent': totalSent,
        'totalViewed': totalViewed,
        'totalDismissed': totalDismissed,
        'totalActioned': totalActioned,
        'engagementRate': engagementRate,
        'averageTimeToAction': averageTimeToAction,
      };
    } catch (e) {
      print('Error getting notification stats: $e');
      return {
        'totalSent': 0,
        'totalViewed': 0,
        'totalDismissed': 0,
        'engagementRate': 0.0,
        'averageTimeToAction': 0.0,
      };
    }
  }
}
