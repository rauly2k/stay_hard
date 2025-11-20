import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/habit_model.dart';
import 'habit_providers.dart';

/// Data class for habit details on a specific day
class HabitDayDetail {
  final String habitId;
  final String habitName;
  final bool isCompleted;

  const HabitDayDetail({
    required this.habitId,
    required this.habitName,
    required this.isCompleted,
  });
}

/// Provider for last 30 days heatmap data
/// Returns a map of date strings to completion rates (0.0 to 1.0)
/// Special value -1.0 indicates no habits scheduled for that day
final last30DaysHeatmapProvider = Provider.autoDispose<Map<String, double>>((ref) {
  final today = DateTime.now();
  final habitsAsync = ref.watch(allActiveHabitsProvider);

  return habitsAsync.when(
    data: (habits) {
      final heatmapData = <String, double>{};

      for (var i = 0; i < 30; i++) {
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
          // Days with no scheduled habits
          heatmapData[dateKey] = -1.0;
        }
      }

      return heatmapData;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Provider for habit details on a specific day
/// Returns a list of habits scheduled for that day with their completion status
final habitsForDayDetailProvider = Provider.autoDispose.family<List<HabitDayDetail>, DateTime>(
  (ref, date) {
    final habitsAsync = ref.watch(allActiveHabitsProvider);
    final dateKey = _formatDateKey(date);

    return habitsAsync.when(
      data: (habits) {
        final habitDetails = <HabitDayDetail>[];

        for (var habit in habits) {
          if (_shouldShowHabitOnDate(habit, date)) {
            habitDetails.add(HabitDayDetail(
              habitId: habit.id,
              habitName: habit.description,
              isCompleted: habit.completionLog[dateKey] == true,
            ));
          }
        }

        return habitDetails;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);

// Helper functions

/// Formats a date as YYYY-MM-DD
String _formatDateKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Determines if a habit should be shown on a specific date based on its RepeatConfig
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
