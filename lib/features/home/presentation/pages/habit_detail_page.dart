import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../user_profile_completion/constants/habit_templates.dart';
import '../providers/habit_providers.dart';
import 'package:intl/intl.dart';

class HabitDetailPage extends ConsumerWidget {
  final Habit habit;

  const HabitDetailPage({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final template = HabitTemplates.findById(habit.templateId);
    final habitColor = template?.color ?? theme.colorScheme.primary;
    final habitIcon = template?.icon ?? Icons.check_circle;
    final habitName = template?.name ?? 'Unknown Habit';

    // Calculate statistics
    final totalDays = habit.completionLog.length;
    final completedDays =
        habit.completionLog.values.where((completed) => completed).length;
    final currentStreak = _calculateCurrentStreak(habit.completionLog);
    final longestStreak = _calculateLongestStreak(habit.completionLog);
    final completionRate =
        totalDays > 0 ? (completedDays / totalDays * 100).round() : 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: habitColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page
              context.push('/habit-edit', extra: habit);
            },
            tooltip: 'Edit Habit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: habitColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      habitIcon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Habit Name
                  Text(
                    habitName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Category
                  if (template != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            HabitTemplates.getCategoryIcon(template.category),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            HabitTemplates.getCategoryDisplayName(
                                template.category),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Statistics Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Current Streak',
                          '$currentStreak',
                          'days',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Longest Streak',
                          '$longestStreak',
                          'days',
                          Icons.emoji_events,
                          Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Completion Rate',
                          '$completionRate',
                          '%',
                          Icons.analytics,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total Days',
                          '$completedDays',
                          'of $totalDays',
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Configuration Section
                  Text(
                    'Configuration',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    context,
                    'Goal',
                    _getConfigurationDisplay(habit.configuration, template),
                    Icons.flag,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context,
                    'Time of Day',
                    habit.timeOfDay
                        .map((t) => _getTimeOfDayLabel(t))
                        .join(', '),
                    Icons.schedule,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context,
                    'Repeat',
                    _getRepeatConfigDisplay(habit.repeatConfig),
                    Icons.repeat,
                  ),

                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      'Notes',
                      habit.description,
                      Icons.notes,
                    ),
                  ],

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context,
                    'Notifications',
                    habit.notificationsEnabled ? 'Enabled' : 'Disabled',
                    Icons.notifications,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context,
                    'Created',
                    DateFormat('MMM dd, yyyy').format(habit.createdAt),
                    Icons.event,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getConfigurationDisplay(
      Map<String, dynamic> config, HabitTemplate? template) {
    if (template == null) return 'Not configured';

    switch (template.configType) {
      case HabitConfigType.duration:
        final minutes = config['targetMinutes'] as int? ?? 0;
        return '$minutes minutes';
      case HabitConfigType.quantity:
        final quantity = config['targetQuantity'] as int? ?? 0;
        final unit = config['unit'] as String? ?? 'items';
        return '$quantity $unit';
      case HabitConfigType.time:
        final time = config['targetTime'] as String? ?? '';
        return time;
      case HabitConfigType.none:
        return 'Check-in only';
    }
  }

  String _getTimeOfDayLabel(TimeOfDayEnum timeOfDay) {
    switch (timeOfDay) {
      case TimeOfDayEnum.morning:
        return 'Morning';
      case TimeOfDayEnum.afternoon:
        return 'Afternoon';
      case TimeOfDayEnum.evening:
        return 'Evening';
      case TimeOfDayEnum.anytime:
        return 'Anytime';
    }
  }

  String _getRepeatConfigDisplay(RepeatConfig config) {
    if (config.isDaily) {
      return 'Daily';
    } else if (config.specificDays != null && config.specificDays!.isNotEmpty) {
      final days = config.specificDays!
          .map((day) => _getDayName(day))
          .join(', ');
      return days;
    } else if (config.intervalDays != null) {
      return 'Every ${config.intervalDays} days';
    }
    return 'Custom';
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  int _calculateCurrentStreak(Map<String, bool> completionLog) {
    if (completionLog.isEmpty) return 0;

    final sortedDates = completionLog.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    int streak = 0;
    DateTime? previousDate;

    for (final dateStr in sortedDates) {
      final date = DateTime.parse(dateStr);
      final completed = completionLog[dateStr] ?? false;

      if (!completed) break;

      if (previousDate == null ||
          previousDate.difference(date).inDays == 1) {
        streak++;
        previousDate = date;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateLongestStreak(Map<String, bool> completionLog) {
    if (completionLog.isEmpty) return 0;

    final sortedDates = completionLog.keys.toList()
      ..sort((a, b) => a.compareTo(b)); // Sort ascending

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? previousDate;

    for (final dateStr in sortedDates) {
      final date = DateTime.parse(dateStr);
      final completed = completionLog[dateStr] ?? false;

      if (completed) {
        if (previousDate == null ||
            date.difference(previousDate).inDays == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        } else {
          currentStreak = 1;
        }
        previousDate = date;
      } else {
        currentStreak = 0;
        previousDate = null;
      }
    }

    return longestStreak;
  }
}
