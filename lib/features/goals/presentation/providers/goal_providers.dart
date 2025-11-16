import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/goal_model.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../home/presentation/providers/habit_providers.dart';
import '../../data/repositories/goal_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Provider for the goal repository
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

/// Provider for all goals stream
final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getGoals();
});

/// Provider for active goals only
final activeGoalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getActiveGoals();
});

/// Provider for a specific goal by ID
final goalByIdProvider = StreamProvider.autoDispose.family<Goal?, String>((ref, goalId) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getGoals().map((goals) {
    try {
      return goals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      return null;
    }
  });
});

/// Provider for goal form operations (create, update, delete)
final goalFormProvider = NotifierProvider<GoalFormNotifier, AsyncValue<void>>(
  GoalFormNotifier.new,
);

class GoalFormNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createGoal({
    required String name,
    required String description,
    required String category,
    required DateTime targetDate,
    required List<String> habitIds,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final goal = Goal(
        id: const Uuid().v4(),
        userId: user.uid,
        name: name,
        description: description,
        category: category,
        targetDate: targetDate,
        status: 'active',
        habitIds: habitIds,
        createdAt: DateTime.now(),
      );

      final repository = ref.read(goalRepositoryProvider);
      await repository.createGoal(goal);
    });
  }

  Future<void> updateGoal(Goal goal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.updateGoal(goal);
    });
  }

  Future<void> deleteGoal(String goalId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.deleteGoal(goalId);
    });
  }

  Future<void> completeGoal(String goalId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.completeGoal(goalId);
    });
  }

  Future<void> updateGoalStatus(String goalId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.updateGoalStatus(goalId, status);
    });
  }

  Future<void> linkHabit(String goalId, String habitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.linkHabitToGoal(goalId, habitId);
    });
  }

  Future<void> unlinkHabit(String goalId, String habitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(goalRepositoryProvider);
      await repository.unlinkHabitFromGoal(goalId, habitId);
    });
  }
}

/// Provider for goal progress calculation
final goalProgressProvider = Provider.autoDispose.family<GoalProgress, String>((ref, goalId) {
  final goalAsync = ref.watch(goalByIdProvider(goalId));

  return goalAsync.when(
    data: (goal) {
      if (goal == null) {
        return GoalProgress(
          completionPercentage: 0,
          daysRemaining: 0,
          isOverdue: false,
          linkedHabitsCount: 0,
          completedHabitsToday: 0,
        );
      }

      final now = DateTime.now();
      final targetDate = goal.targetDate;
      final daysRemaining = targetDate.difference(now).inDays;
      final isOverdue = daysRemaining < 0;

      // Calculate completion percentage based on time elapsed
      final totalDays = targetDate.difference(goal.createdAt).inDays;
      final daysPassed = now.difference(goal.createdAt).inDays;
      final timeBasedPercentage = totalDays > 0 ? (daysPassed / totalDays * 100).clamp(0, 100).toInt() : 0;

      // Count completed habits today
      final today = DateTime.now();
      int completedToday = 0;

      // This would need to check actual habit completions for today
      // For now, returning basic stats

      return GoalProgress(
        completionPercentage: timeBasedPercentage,
        daysRemaining: daysRemaining.abs(),
        isOverdue: isOverdue,
        linkedHabitsCount: goal.habitIds.length,
        completedHabitsToday: completedToday,
      );
    },
    loading: () => GoalProgress(
      completionPercentage: 0,
      daysRemaining: 0,
      isOverdue: false,
      linkedHabitsCount: 0,
      completedHabitsToday: 0,
    ),
    error: (_, __) => GoalProgress(
      completionPercentage: 0,
      daysRemaining: 0,
      isOverdue: false,
      linkedHabitsCount: 0,
      completedHabitsToday: 0,
    ),
  );
});

/// Data class for goal progress information
class GoalProgress {
  final int completionPercentage;
  final int daysRemaining;
  final bool isOverdue;
  final int linkedHabitsCount;
  final int completedHabitsToday;

  GoalProgress({
    required this.completionPercentage,
    required this.daysRemaining,
    required this.isOverdue,
    required this.linkedHabitsCount,
    required this.completedHabitsToday,
  });
}

/// Provider for habits linked to a specific goal
final linkedHabitsProvider = Provider.autoDispose.family<List<Habit>, String>((ref, goalId) {
  final goalAsync = ref.watch(goalByIdProvider(goalId));
  final today = DateTime.now();
  final habitsAsync = ref.watch(habitsForDateProvider(today));

  return goalAsync.when(
    data: (goal) {
      if (goal == null || goal.habitIds.isEmpty) {
        return [];
      }

      return habitsAsync.when(
        data: (habits) {
          return habits.where((habit) => goal.habitIds.contains(habit.id)).toList();
        },
        loading: () => [],
        error: (_, __) => [],
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
