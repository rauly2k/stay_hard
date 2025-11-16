import 'package:flutter/material.dart';
import '../../../../shared/data/models/alarm_model.dart';

/// Card widget for displaying an alarm in the list
class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Time and label section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time display
                    Text(
                      alarm.getFormattedTime(),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: alarm.isEnabled
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Label
                    Text(
                      alarm.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: alarm.isEnabled
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Repeat days
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: alarm.isEnabled
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        alarm.getRepeatDescription(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: alarm.isEnabled
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle switch
              Switch(
                value: alarm.isEnabled,
                onChanged: onToggle,
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
