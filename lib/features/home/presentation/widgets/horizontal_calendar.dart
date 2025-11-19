import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class HorizontalCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final List<DateTime> dates = _generateDates(today);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 20% of screen height or minimum 120px for better visibility
        final calendarHeight = math.max(
          MediaQuery.of(context).size.height * 0.20,
          120.0,
        );

        return SizedBox(
          height: calendarHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);

              return _buildDateItem(
                context,
                theme,
                date,
                isSelected: isSelected,
                isToday: isToday,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDateItem(
    BuildContext context,
    ThemeData theme,
    DateTime date, {
    required bool isSelected,
    required bool isToday,
  }) {
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : isToday
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday && !isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
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
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
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
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            // "Today" indicator
            if (isToday)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Generate a list of dates centered around today (3 days before, today, 3 days after)
  List<DateTime> _generateDates(DateTime today) {
    final List<DateTime> dates = [];
    for (int i = -3; i <= 3; i++) {
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
