import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../providers/habit_providers.dart';

class HorizontalCalendar extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback? onCalendarTap;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final List<DateTime> dates = _generateDates(today);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a more compact height to fit better with 30 days visible
        final calendarHeight = math.max(
          MediaQuery.of(context).size.height * 0.084,
          70.0,
        );

        return SizedBox(
          height: calendarHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: dates.length,
            reverse: true, // Show most recent dates first
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);
              final isPast = date.isBefore(today) && !isToday;

              // Get habit stats for this date
              final habitStats = ref.watch(habitStatsProvider(date));
              final isCompleted = habitStats.total > 0 && habitStats.completed == habitStats.total;

              return _buildDateItem(
                context,
                ref,
                theme,
                date,
                isSelected: isSelected,
                isToday: isToday,
                isPast: isPast,
                isCompleted: isCompleted,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDateItem(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    DateTime date, {
    required bool isSelected,
    required bool isToday,
    required bool isPast,
    required bool isCompleted,
  }) {
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        width: 52,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : isToday
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isToday && !isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day of week (e.g., "Mon")
            Text(
              DateFormat('EEE').format(date),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            // Day number (e.g., "15")
            Text(
              DateFormat('d').format(date),
              style: theme.textTheme.titleLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 1),
            // Indicator: Fire emoji for completed days, white circle for today
            _buildDayIndicator(
              theme,
              isToday: isToday,
              isPast: isPast,
              isCompleted: isCompleted,
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayIndicator(
    ThemeData theme, {
    required bool isToday,
    required bool isPast,
    required bool isCompleted,
    required bool isSelected,
  }) {
    // Show fire emoji for completed days (past or today)
    if (isCompleted) {
      return const Text(
        '🔥',
        style: TextStyle(fontSize: 12),
      );
    }

    // Show white circle for today (when not completed)
    if (isToday) {
      return Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    // No indicator for past incomplete days
    return const SizedBox(height: 5);
  }

  /// Generate a list of last 30 days (today and 29 days before)
  List<DateTime> _generateDates(DateTime today) {
    final List<DateTime> dates = [];
    for (int i = 0; i >= -29; i--) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
