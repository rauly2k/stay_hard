import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../providers/habit_providers.dart';

class HorizontalCalendar extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends ConsumerState<HorizontalCalendar> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll to the end (today) after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final List<DateTime> dates = _generateDates(today);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a more compact height to fit better with 7 days visible (reduced by 30%)
        final calendarHeight = math.max(
          MediaQuery.of(context).size.height * 0.084,
          70.0,
        );

        return SizedBox(
          height: calendarHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, widget.selectedDate);
              final isToday = _isSameDay(date, today);
              final isPast = date.isBefore(today) && !_isSameDay(date, today);

              // Get completion stats for this date
              final stats = ref.watch(habitStatsProvider(date));
              final isFullyCompleted = stats.total > 0 && stats.percentage == 100;

              return _buildDateItem(
                context,
                theme,
                date,
                isSelected: isSelected,
                isToday: isToday,
                isPast: isPast,
                isFullyCompleted: isFullyCompleted,
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
    required bool isPast,
    required bool isFullyCompleted,
  }) {
    return GestureDetector(
      onTap: () => widget.onDateSelected(date),
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
            // Indicator: white circle for today, fire emoji for fully completed past days
            if (isToday && !isFullyCompleted)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              )
            else if ((isToday || isPast) && isFullyCompleted)
              const Text(
                '🔥',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  /// Generate a list of dates showing last 30 days up to today
  List<DateTime> _generateDates(DateTime today) {
    final List<DateTime> dates = [];
    for (int i = 29; i >= 0; i--) {
      dates.add(today.subtract(Duration(days: i)));
    }
    return dates;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
