import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/goal_providers.dart';
import '../../../home/presentation/providers/habit_providers.dart';
import '../../../user_profile_completion/constants/habit_templates.dart';

class GoalDetailPage extends ConsumerWidget {
  final String goalId;

  const GoalDetailPage({
    super.key,
    required this.goalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalAsync = ref.watch(goalByIdProvider(goalId));
    final progress = ref.watch(goalProgressProvider(goalId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pause',
                child: Row(
                  children: [
                    Icon(Icons.pause),
                    SizedBox(width: 8),
                    Text('Pause'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Mark Complete'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'complete':
                  await ref.read(goalFormProvider.notifier).completeGoal(goalId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Goal marked as complete!')),
                    );
                  }
                  break;
                case 'pause':
                  await ref.read(goalFormProvider.notifier).updateGoalStatus(goalId, 'paused');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Goal paused')),
                    );
                  }
                  break;
                case 'delete':
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Goal'),
                      content: const Text('Are you sure you want to delete this goal?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(goalFormProvider.notifier).deleteGoal(goalId);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                  break;
              }
            },
          ),
        ],
      ),
      body: goalAsync.when(
        data: (goal) {
          if (goal == null) {
            return const Center(
              child: Text('Goal not found'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.flag,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      goal.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        goal.category.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Progress Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Circular Progress
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: progress.completionPercentage / 100,
                                strokeWidth: 12,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${progress.completionPercentage}%',
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      'Complete',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.calendar_today,
                            label: progress.isOverdue ? 'Overdue' : 'Days Left',
                            value: '${progress.daysRemaining}',
                            color: progress.isOverdue
                                ? const Color(0xFFF94144)
                                : theme.colorScheme.primary,
                          ),
                          _StatItem(
                            icon: Icons.checklist,
                            label: 'Habits',
                            value: '${progress.linkedHabitsCount}',
                            color: const Color(0xFF277DA1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Description
              if (goal.description.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goal.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Linked Habits
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Linked Habits',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // TODO: Add habit linking dialog
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (goal.habitIds.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'No habits linked yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        Consumer(
                          builder: (context, ref, child) {
                            final linkedHabits = ref.watch(linkedHabitsProvider(goalId));

                            if (linkedHabits.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return Column(
                              children: linkedHabits.map((habit) {
                                final completionService = ref.read(habitCompletionProvider);
                                final isCompleted = completionService.isHabitCompleted(
                                  habit,
                                  DateTime.now(),
                                );
                                final template = HabitTemplates.findById(habit.templateId);
                                final habitName = template?.name ?? habit.description;
                                return ListTile(
                                  leading: Icon(
                                    isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                    color: isCompleted
                                        ? const Color(0xFF90BE6D)
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                  title: Text(habitName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      ref.read(goalFormProvider.notifier).unlinkHabit(
                                            goalId,
                                            habit.id,
                                          );
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
