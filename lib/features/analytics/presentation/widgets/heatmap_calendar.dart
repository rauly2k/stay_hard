import 'package:flutter/material.dart';
import 'dart:math' as math;

class HeatmapCalendar extends StatelessWidget {
  final Map<String, double> heatmapData;

  const HeatmapCalendar({
    super.key,
    required this.heatmapData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    // Calculate weeks to display (52 weeks = 1 year)
    final List<List<DateTime>> weeks = _generateWeeks(today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              _buildLegendSquare(0.0, theme),
              const SizedBox(width: 2),
              _buildLegendSquare(0.25, theme),
              const SizedBox(width: 2),
              _buildLegendSquare(0.5, theme),
              const SizedBox(width: 2),
              _buildLegendSquare(0.75, theme),
              const SizedBox(width: 2),
              _buildLegendSquare(1.0, theme),
              const SizedBox(width: 4),
              Text(
                'More',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Calendar Grid
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // Start from the most recent date
          child: Row(
            children: [
              // Month labels column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12), // Space for day labels
                  ...['Mon', 'Wed', 'Fri'].map((day) => SizedBox(
                        height: 12,
                        child: Text(
                          day,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(width: 8),
              // Weeks grid
              Row(
                children: weeks.reversed.map((week) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Column(
                      children: [
                        // Month label (show if it's the first week of month)
                        SizedBox(
                          height: 12,
                          child: week.first.day <= 7
                              ? Text(
                                  _getMonthName(week.first.month),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        // Day squares
                        ...week.map((date) {
                          final dateKey = _formatDateKey(date);
                          final completion = heatmapData[dateKey] ?? 0.0;
                          return _buildDaySquare(date, completion, theme);
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaySquare(DateTime date, double completion, ThemeData theme) {
    final isToday = _isToday(date);
    final isFuture = date.isAfter(DateTime.now());

    return Tooltip(
      message: '${_formatDateKey(date)}: ${(completion * 100).toInt()}%',
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isFuture
              ? Colors.transparent
              : _getColorForCompletion(completion, theme),
          borderRadius: BorderRadius.circular(2),
          border: isToday
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : null,
        ),
      ),
    );
  }

  Widget _buildLegendSquare(double value, ThemeData theme) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _getColorForCompletion(value, theme),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Color _getColorForCompletion(double completion, ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surfaceContainerHighest;

    if (completion == 0) {
      return surface;
    } else if (completion < 0.3) {
      return primary.withValues(alpha: 0.2);
    } else if (completion < 0.6) {
      return primary.withValues(alpha: 0.4);
    } else if (completion < 0.9) {
      return primary.withValues(alpha: 0.7);
    } else {
      return primary;
    }
  }

  List<List<DateTime>> _generateWeeks(DateTime today) {
    final List<List<DateTime>> weeks = [];
    final startDate = today.subtract(const Duration(days: 364));

    DateTime currentDate = startDate;

    // Align to the start of the week (Monday)
    while (currentDate.weekday != DateTime.monday) {
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    while (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
      final List<DateTime> week = [];
      for (int i = 0; i < 7; i++) {
        week.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      weeks.add(week);
    }

    return weeks;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
