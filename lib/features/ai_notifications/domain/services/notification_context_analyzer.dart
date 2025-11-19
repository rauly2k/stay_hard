import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/ai_notification_config.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../../shared/data/models/goal_model.dart';

/// Service for analyzing user context before sending notifications
class NotificationContextAnalyzer {
  final FirebaseFirestore _firestore;

  NotificationContextAnalyzer({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Analyze user's current context
  Future<NotificationContext> analyzeContext({
    required String userId,
    required NotificationScenario scenario,
  }) async {
    final now = DateTime.now();

    try {
      // Gather all data in parallel
      final results = await Future.wait([
        _getTodayHabits(userId),
        _getStreakData(userId),
        _getCompletionRate7Days(userId),
      ]);

      final todayHabits = results[0] as List<Habit>;
      final streakData = results[1] as Map<String, int>;
      final completionRate7Days = results[2] as double;

      final completedCount =
          todayHabits.where((h) => _isCompletedToday(h, now)).length;
      final pendingHabits =
          todayHabits.where((h) => !_isCompletedToday(h, now)).toList();

      return NotificationContext(
        userId: userId,
        scenario: scenario,
        timestamp: now,
        totalHabitsToday: todayHabits.length,
        completedCount: completedCount,
        pendingHabitNames: pendingHabits
            .map((h) => _getHabitDisplayName(h))
            .toList(),
        currentStreak: streakData['current'] ?? 0,
        longestStreak: streakData['longest'] ?? 0,
        completionRate7Days: completionRate7Days,
        timeOfDay: _determineTimeOfDay(now),
      );
    } catch (e) {
      print('Error analyzing notification context: $e');
      // Return default context
      return NotificationContext(
        userId: userId,
        scenario: scenario,
        timestamp: now,
        totalHabitsToday: 0,
        completedCount: 0,
        pendingHabitNames: [],
        currentStreak: 0,
        longestStreak: 0,
        completionRate7Days: 0.0,
        timeOfDay: _determineTimeOfDay(now),
      );
    }
  }

  /// Get today's habits for user
  Future<List<Habit>> _getTodayHabits(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('habits')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => Habit.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting today\'s habits: $e');
      return [];
    }
  }

  /// Get streak data (current and longest streak)
  Future<Map<String, int>> _getStreakData(String userId) async {
    try {
      final habits = await _getTodayHabits(userId);
      if (habits.isEmpty) {
        return {'current': 0, 'longest': 0};
      }

      // Calculate streak based on completion logs
      int currentStreak = 0;
      int longestStreak = 0;
      int tempStreak = 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check each day going backwards
      for (int i = 0; i < 365; i++) {
        final date = today.subtract(Duration(days: i));
        final dateKey = _getDateKey(date);

        // Check if all habits were completed on this date
        bool allCompleted = true;
        for (final habit in habits) {
          if (habit.completionLog[dateKey] != true) {
            allCompleted = false;
            break;
          }
        }

        if (allCompleted) {
          tempStreak++;
          if (i == 0) {
            currentStreak = tempStreak;
          }
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
        } else {
          if (i == 0) {
            currentStreak = 0;
          }
          tempStreak = 0;
        }
      }

      return {'current': currentStreak, 'longest': longestStreak};
    } catch (e) {
      print('Error getting streak data: $e');
      return {'current': 0, 'longest': 0};
    }
  }

  /// Get 7-day completion rate
  Future<double> _getCompletionRate7Days(String userId) async {
    try {
      final habits = await _getTodayHabits(userId);
      if (habits.isEmpty) return 0.0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      int totalPossible = 0;
      int totalCompleted = 0;

      for (int i = 0; i < 7; i++) {
        final date = today.subtract(Duration(days: i));
        final dateKey = _getDateKey(date);

        for (final habit in habits) {
          totalPossible++;
          if (habit.completionLog[dateKey] == true) {
            totalCompleted++;
          }
        }
      }

      return totalPossible > 0 ? totalCompleted / totalPossible : 0.0;
    } catch (e) {
      print('Error getting 7-day completion rate: $e');
      return 0.0;
    }
  }

  /// Check if habit is completed today
  bool _isCompletedToday(Habit habit, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final dateKey = _getDateKey(today);
    return habit.completionLog[dateKey] == true;
  }

  /// Get date key for completion log
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get habit display name from template ID
  String _getHabitDisplayName(Habit habit) {
    // This would ideally fetch from HabitTemplates
    // For now, use template ID
    return habit.templateId.replaceAll('_', ' ').toUpperCase();
  }

  /// Determine time of day
  String _determineTimeOfDay(DateTime time) {
    if (time.hour >= 5 && time.hour < 12) return 'morning';
    if (time.hour >= 12 && time.hour < 17) return 'afternoon';
    if (time.hour >= 17 && time.hour < 22) return 'evening';
    return 'night';
  }
}
