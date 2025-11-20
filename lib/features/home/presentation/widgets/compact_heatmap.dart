import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../analytics/presentation/providers/analytics_providers.dart';

class CompactHeatmap extends ConsumerWidget {
  const CompactHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final heatmapData = ref.watch(heatmapDataProvider);

    final today = DateTime.now();

    // Generate list of last 30 days
    final days = <DateTime>[];
    for (int i = 29; i >= 0; i--) {
      days.add(today.subtract(Duration(days: i)));
    }

    return SizedBox(
      height: 150, // Match the divider height in hero_graphic.dart
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Last 30 Days',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Calendar Grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 1,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = days[index];
                final dateKey = _formatDateKey(date);
                final value = heatmapData[dateKey] ?? 0.0;
                final isToday = _isSameDay(date, today);

                return _buildDayCell(theme, date, value, isToday);
              },
            ),
          ),

          const SizedBox(height: 6),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Low',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              _buildLegendDot(Colors.red.withValues(alpha: 0.7)),
              const SizedBox(width: 2),
              _buildLegendDot(Colors.orange.withValues(alpha: 0.8)),
              const SizedBox(width: 2),
              _buildLegendDot(Colors.yellow.withValues(alpha: 0.85)),
              const SizedBox(width: 2),
              _buildLegendDot(Colors.green.withValues(alpha: 0.9)),
              const SizedBox(width: 4),
              Text(
                'High',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(ThemeData theme, DateTime date, double value, bool isToday) {
    Color backgroundColor;
    if (isToday) {
      // Today is always white regardless of completion
      backgroundColor = Colors.white;
    } else if (value == 0.0) {
      backgroundColor = Colors.white.withValues(alpha: 0.15);
    } else if (value < 0.33) {
      backgroundColor = Colors.red.withValues(alpha: 0.6 + (value * 0.3));
    } else if (value < 0.67) {
      final t = (value - 0.33) / 0.34;
      backgroundColor = Color.lerp(
        Colors.orange.withValues(alpha: 0.75),
        Colors.yellow.withValues(alpha: 0.85),
        t,
      )!;
    } else {
      final t = (value - 0.67) / 0.33;
      backgroundColor = Color.lerp(
        Colors.yellow.withValues(alpha: 0.85),
        Colors.green.withValues(alpha: 0.95),
        t,
      )!;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          DateFormat('d').format(date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isToday
                ? Colors.black.withValues(alpha: 0.9)
                : value > 0.3
                    ? Colors.black.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.9),
            fontSize: 10,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
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
