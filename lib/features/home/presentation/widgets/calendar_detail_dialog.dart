import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../user_profile_completion/constants/habit_templates.dart';
import '../providers/habit_providers.dart';

/// Calendar Detail Dialog
/// Shows a month view with habit completion data and day-specific stats
class CalendarDetailDialog extends ConsumerStatefulWidget {
  final DateTime initialDate;

  const CalendarDetailDialog({
    super.key,
    required this.initialDate,
  });

  @override
  ConsumerState<CalendarDetailDialog> createState() => _CalendarDetailDialogState();
}

class _CalendarDetailDialogState extends ConsumerState<CalendarDetailDialog> {
  late DateTime _selectedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      _selectedDay = null;
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      _selectedDay = null;
    });
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: const Icon(Icons.chevron_left),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: const Icon(Icons.chevron_right),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(theme, 'Low', Colors.red.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      _buildLegendItem(theme, '', Colors.orange.withValues(alpha: 0.8)),
                      const SizedBox(width: 8),
                      _buildLegendItem(theme, '', Colors.yellow.withValues(alpha: 0.85)),
                      const SizedBox(width: 8),
                      _buildLegendItem(theme, 'High', Colors.green.withValues(alpha: 0.9)),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCalendarGrid(theme),
                    if (_selectedDay != null) ...[
                      const SizedBox(height: 16),
                      _buildDayStats(theme, _selectedDay!),
                    ],
                  ],
                ),
              ),
            ),

            // Close Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    final daysInMonth = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Convert to Sunday=0 system

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Calendar days
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) {
              return const SizedBox();
            }

            final day = index - firstWeekday + 1;
            final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
            final isSelected = _selectedDay != null && _isSameDay(date, _selectedDay!);
            final isToday = _isSameDay(date, DateTime.now());

            // Get habit stats for this date
            final habitStats = ref.watch(habitStatsProvider(date));
            final completionRate = habitStats.total > 0
                ? habitStats.completed / habitStats.total
                : 0.0;

            return _buildDayCell(
              theme,
              day,
              date,
              completionRate,
              isSelected: isSelected,
              isToday: isToday,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(
    ThemeData theme,
    int day,
    DateTime date,
    double completionRate, {
    required bool isSelected,
    required bool isToday,
  }) {
    Color backgroundColor;
    if (completionRate == 0.0) {
      backgroundColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    } else if (completionRate < 0.33) {
      backgroundColor = Colors.red.withValues(alpha: 0.6 + (completionRate * 0.3));
    } else if (completionRate < 0.67) {
      final t = (completionRate - 0.33) / 0.34;
      backgroundColor = Color.lerp(
        Colors.orange.withValues(alpha: 0.75),
        Colors.yellow.withValues(alpha: 0.85),
        t,
      )!;
    } else {
      final t = (completionRate - 0.67) / 0.33;
      backgroundColor = Color.lerp(
        Colors.yellow.withValues(alpha: 0.85),
        Colors.green.withValues(alpha: 0.95),
        t,
      )!;
    }

    return GestureDetector(
      onTap: () => _selectDay(date),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : isToday
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : Colors.transparent,
            width: isSelected ? 2.5 : isToday ? 2 : 0,
          ),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: completionRate > 0.3
                  ? Colors.black.withValues(alpha: 0.9)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayStats(ThemeData theme, DateTime date) {
    final habitsAsync = ref.watch(habitsForDateProvider(date));
    final habitStats = ref.watch(habitStatsProvider(date));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(date),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (habitStats.total > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: habitStats.percentage == 100
                        ? Colors.green.withValues(alpha: 0.2)
                        : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${habitStats.percentage}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: habitStats.percentage == 100
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          habitsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(
              'Error loading habits: $error',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            data: (habits) {
              if (habits.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No habits scheduled for this day',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              final completionService = ref.read(habitCompletionProvider);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Habits (${habitStats.completed}/${habitStats.total})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...habits.map((habit) {
                    final template = HabitTemplates.findById(habit.templateId);
                    final isCompleted = completionService.isHabitCompleted(habit, date);
                    final habitColor = template?.color ?? theme.colorScheme.primary;
                    final habitIcon = template?.icon ?? Icons.check_circle;
                    final habitName = template?.name ?? 'Unknown Habit';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.circle_outlined,
                            color: isCompleted ? Colors.green : theme.colorScheme.outline,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: habitColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              habitIcon,
                              color: habitColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              habitName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
