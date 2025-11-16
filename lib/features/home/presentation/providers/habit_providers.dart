import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/habit_model.dart';

/// Provider for currently selected date (defaults to today)
final selectedDateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }

  void setToday() {
    state = DateTime.now();
  }
}

/// Provider for habits for a specific date
final habitsForDateProvider = StreamProvider.autoDispose.family<List<Habit>, DateTime>(
  (ref, date) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('habits')
        .where('userId', isEqualTo: user.uid)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final habits = snapshot.docs
          .map((doc) {
            try {
              return Habit.fromJson(doc.data());
            } catch (e) {
              return null;
            }
          })
          .whereType<Habit>()
          .toList();

      // Filter habits for the specific date based on repeat config
      return habits.where((habit) => _shouldShowHabitOnDate(habit, date)).toList();
    });
  },
);

/// Check if a habit should be shown on a specific date
bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
  final config = habit.repeatConfig;

  if (config.isDaily) {
    return true;
  }

  if (config.specificDays != null && config.specificDays!.isNotEmpty) {
    // Check if the day of week matches (1 = Monday, 7 = Sunday)
    return config.specificDays!.contains(date.weekday);
  }

  if (config.intervalDays != null) {
    // Check if the date is a multiple of interval days from creation
    final daysSinceCreation = date.difference(habit.createdAt).inDays;
    return daysSinceCreation % config.intervalDays! == 0;
  }

  return true; // Default to showing the habit
}

/// Provider for habit completion service
final habitCompletionProvider = Provider<HabitCompletionService>(
  (ref) => HabitCompletionService(),
);

class HabitCompletionService {
  /// Toggle habit completion for a specific date
  Future<void> toggleHabitCompletion(
    String habitId,
    DateTime date,
    WidgetRef ref,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final habitDoc = await FirebaseFirestore.instance
          .collection('habits')
          .doc(habitId)
          .get();

      if (!habitDoc.exists) return;

      final habit = Habit.fromJson(habitDoc.data()!);
      final dateKey = _formatDateKey(date);
      final currentStatus = habit.completionLog[dateKey] ?? false;

      final updatedLog = Map<String, bool>.from(habit.completionLog);
      updatedLog[dateKey] = !currentStatus;

      await FirebaseFirestore.instance
          .collection('habits')
          .doc(habitId)
          .update({'completionLog': updatedLog});
    } catch (e) {
      print('Error toggling habit completion: $e');
      rethrow;
    }
  }

  /// Check if a habit is completed on a specific date
  bool isHabitCompleted(Habit habit, DateTime date) {
    final dateKey = _formatDateKey(date);
    return habit.completionLog[dateKey] ?? false;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Provider for habit form/CRUD operations
final habitFormProvider = StateNotifierProvider<HabitFormNotifier, AsyncValue<void>>(
  (ref) => HabitFormNotifier(),
);

class HabitFormNotifier extends StateNotifier<AsyncValue<void>> {
  HabitFormNotifier() : super(const AsyncValue.data(null));

  Future<void> saveHabit(Habit habit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(habit.id)
          .set(habit.toJson(), SetOptions(merge: true));
    });
  }

  Future<void> deleteHabit(String habitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(habitId)
          .delete();
    });
  }
}

/// Provider for habit statistics (completion rate, etc.)
final habitStatsProvider = Provider.autoDispose.family<HabitStats, DateTime>(
  (ref, date) {
    final habitsAsync = ref.watch(habitsForDateProvider(date));

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) {
          return const HabitStats(total: 0, completed: 0, percentage: 0);
        }

        final completionService = ref.read(habitCompletionProvider);
        final completed = habits.where((h) => completionService.isHabitCompleted(h, date)).length;
        final total = habits.length;
        final percentage = (completed / total * 100).round();

        return HabitStats(
          total: total,
          completed: completed,
          percentage: percentage,
        );
      },
      loading: () => const HabitStats(total: 0, completed: 0, percentage: 0),
      error: (_, __) => const HabitStats(total: 0, completed: 0, percentage: 0),
    );
  },
);

class HabitStats {
  final int total;
  final int completed;
  final int percentage;

  const HabitStats({
    required this.total,
    required this.completed,
    required this.percentage,
  });
}
