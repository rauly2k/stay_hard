import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../analytics/presentation/providers/analytics_providers.dart';

class CompactHeatmap extends ConsumerWidget {
  const CompactHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final heatmapData = ref.watch(heatmapDataProvider);

    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 29)); // Include today

    // Group by weeks (4-5 weeks)
    final weeks = <List<DateTime>>[];
    DateTime currentDate = thirtyDaysAgo;

    while (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
      final weekStart = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      final week = <DateTime>[];

      for (var i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        if (!date.isBefore(thirtyDaysAgo) &&
            !date.isAfter(today)) {
          week.add(date);
        }
      }

      if (week.isNotEmpty) {
        weeks.add(week);
        currentDate = week.last.add(const Duration(days: 1));
      } else {
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Last 30 Days',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Day labels
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDayLabel(theme, 'M'),
                _buildDayLabel(theme, 'W'),
                _buildDayLabel(theme, 'F'),
              ],
            ),
            const SizedBox(width: 4),
            // Heatmap grid
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: weeks.map((week) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(7, (dayIndex) {
                        if (dayIndex >= week.length) {
                          return const SizedBox(width: 8, height: 8);
                        }

                        final date = week[dayIndex];
                        final dateKey = _formatDateKey(date);
                        final value = heatmapData[dateKey] ?? 0.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: _buildHeatmapCell(theme, value, date),
                        );
                      }),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Legend
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Less',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 7,
              ),
            ),
            const SizedBox(width: 3),
            _buildHeatmapCell(theme, 0.0, null, isLegend: true),
            const SizedBox(width: 1.5),
            _buildHeatmapCell(theme, 0.3, null, isLegend: true),
            const SizedBox(width: 1.5),
            _buildHeatmapCell(theme, 0.6, null, isLegend: true),
            const SizedBox(width: 1.5),
            _buildHeatmapCell(theme, 1.0, null, isLegend: true),
            const SizedBox(width: 3),
            Text(
              'More',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 7,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayLabel(ThemeData theme, String label) {
    return SizedBox(
      height: 10,
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 7,
        ),
      ),
    );
  }

  Widget _buildHeatmapCell(
    ThemeData theme,
    double value,
    DateTime? date, {
    bool isLegend = false,
  }) {
    final size = isLegend ? 6.0 : 8.0;

    Color color;
    if (value == 0.0) {
      color = Colors.white.withValues(alpha: 0.15);
    } else if (value < 0.3) {
      color = Colors.white.withValues(alpha: 0.3);
    } else if (value < 0.6) {
      color = Colors.white.withValues(alpha: 0.5);
    } else if (value < 0.9) {
      color = Colors.white.withValues(alpha: 0.7);
    } else {
      color = Colors.white.withValues(alpha: 0.95);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
    );
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
