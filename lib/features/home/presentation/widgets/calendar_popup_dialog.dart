import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_popup_providers.dart';
import 'day_detail_bottom_sheet.dart';

/// Interactive calendar popup dialog showing 30 days with completion heatmap
class CalendarPopupDialog extends ConsumerStatefulWidget {
  const CalendarPopupDialog({super.key});

  @override
  ConsumerState<CalendarPopupDialog> createState() => _CalendarPopupDialogState();
}

class _CalendarPopupDialogState extends ConsumerState<CalendarPopupDialog> {
  DateTime? selectedDate;

  void _onDayTapped(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _showDayDetailBottomSheet(date);
  }

  void _showDayDetailBottomSheet(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailBottomSheet(date: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heatmapData = ref.watch(last30DaysHeatmapProvider);
    final today = DateTime.now();

    // Generate list of last 30 days
    final days = <DateTime>[];
    for (int i = 29; i >= 0; i--) {
      days.add(today.subtract(Duration(days: i)));
    }

    // Calculate the day of week for the first day
    final firstDayWeekday = days.first.weekday % 7;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activity Calendar',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Calendar content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtitle
                    Text(
                      'Last 30 Days',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Day of week labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Calendar grid
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 7 / 5, // 7 columns, roughly 5 rows
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: firstDayWeekday + 30,
                          itemBuilder: (context, index) {
                            // Empty cells before the first day
                            if (index < firstDayWeekday) {
                              return Container();
                            }

                            final dayIndex = index - firstDayWeekday;
                            final date = days[dayIndex];
                            final dateKey = _formatDateKey(date);
                            final value = heatmapData[dateKey] ?? 0.0;
                            final isToday = _isSameDay(date, today);

                            return _buildDayCell(
                              context,
                              theme,
                              date,
                              value,
                              isToday,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Low',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildLegendDot(Colors.red.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        _buildLegendDot(Colors.orange.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        _buildLegendDot(Colors.yellow.withOpacity(0.85)),
                        const SizedBox(width: 4),
                        _buildLegendDot(Colors.green.withOpacity(0.9)),
                        const SizedBox(width: 8),
                        Text(
                          'High',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Additional legend for "no habits" days
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendDot(Colors.grey.withOpacity(0.3)),
                        const SizedBox(width: 8),
                        Text(
                          'No habits scheduled',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    ThemeData theme,
    DateTime date,
    double value,
    bool isToday,
  ) {
    Color backgroundColor = _getDayColor(value, theme);

    // Determine text color based on background
    Color textColor;
    if (isToday) {
      textColor = Colors.white;
    } else if (value == -1.0 || value < 0.3) {
      textColor = theme.colorScheme.onSurfaceVariant;
    } else {
      textColor = Colors.black.withOpacity(0.8);
    }

    return GestureDetector(
      onTap: () => _onDayTapped(date),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                )
              : null,
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            DateFormat('d').format(date),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getDayColor(double completionRate, ThemeData theme) {
    if (completionRate == -1.0) {
      // No habits scheduled - greyed out
      return Colors.grey.withOpacity(0.3);
    } else if (completionRate == 0.0) {
      // 0% completion - red
      return Colors.red.withOpacity(0.7);
    } else if (completionRate < 0.33) {
      // Low completion - red gradient
      return Color.lerp(
        Colors.red.withOpacity(0.7),
        Colors.orange.withOpacity(0.8),
        completionRate / 0.33,
      )!;
    } else if (completionRate < 0.67) {
      // Medium completion - orange to yellow
      final t = (completionRate - 0.33) / 0.34;
      return Color.lerp(
        Colors.orange.withOpacity(0.8),
        Colors.yellow.withOpacity(0.85),
        t,
      )!;
    } else {
      // High completion - yellow to green
      final t = (completionRate - 0.67) / 0.33;
      return Color.lerp(
        Colors.yellow.withOpacity(0.85),
        Colors.green.withOpacity(0.95),
        t,
      )!;
    }
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
