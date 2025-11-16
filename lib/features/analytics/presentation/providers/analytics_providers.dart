import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../home/presentation/providers/habit_providers.dart';

/// Provider for overall analytics statistics
final analyticsStatsProvider = Provider.autoDispose<AnalyticsStats>((ref) {
  final today = DateTime.now();
  final thirtyDaysAgo = today.subtract(const Duration(days: 30));

  // Get all habits
  final habitsAsync = ref.watch(habitsForDateProvider(today));

  return habitsAsync.when(
    data: (habits) {
      if (habits.isEmpty) {
        return AnalyticsStats(
          completionRateLast30Days: 0,
          currentStreak: 0,
          bestStreak: 0,
          totalHabitsCompleted: 0,
        );
      }

      // Calculate completion rate for last 30 days
      int totalPossibleCompletions = 0;
      int actualCompletions = 0;

      for (var habit in habits) {
        for (var i = 0; i < 30; i++) {
          final date = today.subtract(Duration(days: i));
          if (_shouldShowHabitOnDate(habit, date)) {
            totalPossibleCompletions++;
            final dateKey = _formatDateKey(date);
            if (habit.completionLog[dateKey] == true) {
              actualCompletions++;
            }
          }
        }
      }

      final completionRate = totalPossibleCompletions > 0
          ? (actualCompletions / totalPossibleCompletions * 100).round()
          : 0;

      // Calculate current streak
      final currentStreak = _calculateCurrentStreak(habits, today);

      // Calculate best streak
      final bestStreak = _calculateBestStreak(habits, today);

      // Count total habits completed
      int totalCompleted = 0;
      for (var habit in habits) {
        totalCompleted += habit.completionLog.values.where((v) => v).length;
      }

      return AnalyticsStats(
        completionRateLast30Days: completionRate,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
        totalHabitsCompleted: totalCompleted,
      );
    },
    loading: () => AnalyticsStats(
      completionRateLast30Days: 0,
      currentStreak: 0,
      bestStreak: 0,
      totalHabitsCompleted: 0,
    ),
    error: (_, __) => AnalyticsStats(
      completionRateLast30Days: 0,
      currentStreak: 0,
      bestStreak: 0,
      totalHabitsCompleted: 0,
    ),
  );
});

/// Provider for heatmap calendar data (365 days)
final heatmapDataProvider = Provider.autoDispose<Map<String, double>>((ref) {
  final today = DateTime.now();
  final habitsAsync = ref.watch(habitsForDateProvider(today));

  return habitsAsync.when(
    data: (habits) {
      if (habits.isEmpty) {
        return {};
      }

      final heatmapData = <String, double>{};

      // Calculate for last 365 days
      for (var i = 0; i < 365; i++) {
        final date = today.subtract(Duration(days: i));
        final dateKey = _formatDateKey(date);

        int totalForDay = 0;
        int completedForDay = 0;

        for (var habit in habits) {
          if (_shouldShowHabitOnDate(habit, date)) {
            totalForDay++;
            if (habit.completionLog[dateKey] == true) {
              completedForDay++;
            }
          }
        }

        if (totalForDay > 0) {
          heatmapData[dateKey] = completedForDay / totalForDay;
        } else {
          heatmapData[dateKey] = 0.0;
        }
      }

      return heatmapData;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Provider for habit-specific analytics
final habitAnalyticsProvider = Provider.autoDispose.family<HabitAnalytics, String>(
  (ref, habitId) {
    final today = DateTime.now();
    final habitsAsync = ref.watch(habitsForDateProvider(today));

    return habitsAsync.when(
      data: (habits) {
        final habit = habits.where((h) => h.id == habitId).firstOrNull;
        if (habit == null) {
          return HabitAnalytics(
            habitId: habitId,
            habitName: '',
            currentStreak: 0,
            bestStreak: 0,
            completionRate: 0,
            totalCompletions: 0,
          );
        }

        // Calculate streaks
        final currentStreak = _calculateHabitStreak(habit, today);
        final bestStreak = _calculateHabitBestStreak(habit, today);

        // Calculate completion rate (last 30 days)
        int totalDays = 0;
        int completedDays = 0;

        for (var i = 0; i < 30; i++) {
          final date = today.subtract(Duration(days: i));
          if (_shouldShowHabitOnDate(habit, date)) {
            totalDays++;
            final dateKey = _formatDateKey(date);
            if (habit.completionLog[dateKey] == true) {
              completedDays++;
            }
          }
        }

        final completionRate = totalDays > 0 ? (completedDays / totalDays * 100).round() : 0;

        // Total completions
        final totalCompletions = habit.completionLog.values.where((v) => v).length;

        return HabitAnalytics(
          habitId: habitId,
          habitName: habit.description,
          currentStreak: currentStreak,
          bestStreak: bestStreak,
          completionRate: completionRate,
          totalCompletions: totalCompletions,
        );
      },
      loading: () => HabitAnalytics(
        habitId: habitId,
        habitName: '',
        currentStreak: 0,
        bestStreak: 0,
        completionRate: 0,
        totalCompletions: 0,
      ),
      error: (_, __) => HabitAnalytics(
        habitId: habitId,
        habitName: '',
        currentStreak: 0,
        bestStreak: 0,
        completionRate: 0,
        totalCompletions: 0,
      ),
    );
  },
);

/// Provider for time-of-day insights
final timeOfDayInsightsProvider = Provider.autoDispose<TimeOfDayInsights>((ref) {
  final today = DateTime.now();
  final habitsAsync = ref.watch(habitsForDateProvider(today));

  return habitsAsync.when(
    data: (habits) {
      if (habits.isEmpty) {
        return TimeOfDayInsights(
          morningRate: 0,
          afternoonRate: 0,
          eveningRate: 0,
          bestTime: 'N/A',
        );
      }

      // Count completions by time of day
      int morningTotal = 0;
      int morningCompleted = 0;
      int afternoonTotal = 0;
      int afternoonCompleted = 0;
      int eveningTotal = 0;
      int eveningCompleted = 0;

      for (var habit in habits) {
        for (var timeOfDay in habit.timeOfDay) {
          // Check last 30 days
          for (var i = 0; i < 30; i++) {
            final date = today.subtract(Duration(days: i));
            final dateKey = _formatDateKey(date);
            final isCompleted = habit.completionLog[dateKey] == true;

            switch (timeOfDay) {
              case TimeOfDayEnum.morning:
                morningTotal++;
                if (isCompleted) morningCompleted++;
                break;
              case TimeOfDayEnum.afternoon:
                afternoonTotal++;
                if (isCompleted) afternoonCompleted++;
                break;
              case TimeOfDayEnum.evening:
                eveningTotal++;
                if (isCompleted) eveningCompleted++;
                break;
              case TimeOfDayEnum.anytime:
                // Count as all times
                morningTotal++;
                afternoonTotal++;
                eveningTotal++;
                if (isCompleted) {
                  morningCompleted++;
                  afternoonCompleted++;
                  eveningCompleted++;
                }
                break;
            }
          }
        }
      }

      final morningRate = morningTotal > 0 ? (morningCompleted / morningTotal * 100).round() : 0;
      final afternoonRate = afternoonTotal > 0 ? (afternoonCompleted / afternoonTotal * 100).round() : 0;
      final eveningRate = eveningTotal > 0 ? (eveningCompleted / eveningTotal * 100).round() : 0;

      // Determine best time
      String bestTime = 'Morning';
      int highestRate = morningRate;

      if (afternoonRate > highestRate) {
        bestTime = 'Afternoon';
        highestRate = afternoonRate;
      }
      if (eveningRate > highestRate) {
        bestTime = 'Evening';
      }

      return TimeOfDayInsights(
        morningRate: morningRate,
        afternoonRate: afternoonRate,
        eveningRate: eveningRate,
        bestTime: bestTime,
      );
    },
    loading: () => TimeOfDayInsights(
      morningRate: 0,
      afternoonRate: 0,
      eveningRate: 0,
      bestTime: 'N/A',
    ),
    error: (_, __) => TimeOfDayInsights(
      morningRate: 0,
      afternoonRate: 0,
      eveningRate: 0,
      bestTime: 'N/A',
    ),
  );
});

// Helper functions
String _formatDateKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
  final config = habit.repeatConfig;

  if (config.isDaily) {
    return true;
  }

  if (config.specificDays != null && config.specificDays!.isNotEmpty) {
    return config.specificDays!.contains(date.weekday);
  }

  if (config.intervalDays != null) {
    final daysSinceCreation = date.difference(habit.createdAt).inDays;
    return daysSinceCreation % config.intervalDays! == 0;
  }

  return true;
}

int _calculateCurrentStreak(List<Habit> habits, DateTime today) {
  int streak = 0;
  DateTime checkDate = today;

  while (true) {
    int totalForDay = 0;
    int completedForDay = 0;

    for (var habit in habits) {
      if (_shouldShowHabitOnDate(habit, checkDate)) {
        totalForDay++;
        final dateKey = _formatDateKey(checkDate);
        if (habit.completionLog[dateKey] == true) {
          completedForDay++;
        }
      }
    }

    // Check if at least 70% of habits were completed
    if (totalForDay > 0 && (completedForDay / totalForDay) >= 0.7) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }

    // Safety limit
    if (streak > 365) break;
  }

  return streak;
}

int _calculateBestStreak(List<Habit> habits, DateTime today) {
  int bestStreak = 0;
  int currentStreak = 0;

  // Check last 365 days
  for (var i = 0; i < 365; i++) {
    final checkDate = today.subtract(Duration(days: i));
    int totalForDay = 0;
    int completedForDay = 0;

    for (var habit in habits) {
      if (_shouldShowHabitOnDate(habit, checkDate)) {
        totalForDay++;
        final dateKey = _formatDateKey(checkDate);
        if (habit.completionLog[dateKey] == true) {
          completedForDay++;
        }
      }
    }

    if (totalForDay > 0 && (completedForDay / totalForDay) >= 0.7) {
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    } else {
      currentStreak = 0;
    }
  }

  return bestStreak;
}

int _calculateHabitStreak(Habit habit, DateTime today) {
  int streak = 0;
  DateTime checkDate = today;

  while (true) {
    if (!_shouldShowHabitOnDate(habit, checkDate)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
      continue;
    }

    final dateKey = _formatDateKey(checkDate);
    if (habit.completionLog[dateKey] == true) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }

    // Safety limit
    if (streak > 365) break;
  }

  return streak;
}

int _calculateHabitBestStreak(Habit habit, DateTime today) {
  int bestStreak = 0;
  int currentStreak = 0;

  // Check last 365 days
  for (var i = 0; i < 365; i++) {
    final checkDate = today.subtract(Duration(days: i));

    if (!_shouldShowHabitOnDate(habit, checkDate)) {
      continue;
    }

    final dateKey = _formatDateKey(checkDate);
    if (habit.completionLog[dateKey] == true) {
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    } else {
      currentStreak = 0;
    }
  }

  return bestStreak;
}

// Data classes
class AnalyticsStats {
  final int completionRateLast30Days;
  final int currentStreak;
  final int bestStreak;
  final int totalHabitsCompleted;

  AnalyticsStats({
    required this.completionRateLast30Days,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalHabitsCompleted,
  });
}

class HabitAnalytics {
  final String habitId;
  final String habitName;
  final int currentStreak;
  final int bestStreak;
  final int completionRate;
  final int totalCompletions;

  HabitAnalytics({
    required this.habitId,
    required this.habitName,
    required this.currentStreak,
    required this.bestStreak,
    required this.completionRate,
    required this.totalCompletions,
  });
}

class TimeOfDayInsights {
  final int morningRate;
  final int afternoonRate;
  final int eveningRate;
  final String bestTime;

  TimeOfDayInsights({
    required this.morningRate,
    required this.afternoonRate,
    required this.eveningRate,
    required this.bestTime,
  });
}
