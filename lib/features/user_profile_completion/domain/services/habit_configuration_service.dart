import 'package:flutter/material.dart';
import '../../constants/habit_templates.dart';
import '../../data/models/habit_template.dart';

/// Service for habit configuration dialogs
class HabitConfigurationService {
  /// Check if a habit requires configuration
  static bool requiresConfiguration(String habitId) {
    final template = HabitTemplates.findById(habitId);
    return template?.requiresConfiguration ?? false;
  }

  /// Show configuration dialog for a habit
  static Future<Map<String, dynamic>?> showConfigurationDialog(
    BuildContext context,
    String habitId,
    String habitName,
  ) async {
    final template = HabitTemplates.findById(habitId);
    if (template == null) return null;

    switch (template.configType) {
      case HabitConfigType.duration:
        return _showDurationDialog(context, habitName, template.defaultValue ?? 30);
      case HabitConfigType.quantity:
        return _showQuantityDialog(
          context,
          habitName,
          template.defaultValue ?? 1,
          template.defaultUnit ?? 'units',
        );
      case HabitConfigType.time:
        return _showTimeDialog(context, habitName);
      case HabitConfigType.none:
        return {}; // No configuration needed
    }
  }

  /// Show duration picker dialog
  static Future<Map<String, dynamic>?> _showDurationDialog(
    BuildContext context,
    String habitName,
    int defaultMinutes,
  ) async {
    int selectedMinutes = defaultMinutes;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);

            return AlertDialog(
              title: Text('Configure $habitName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How many minutes per day?',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [10, 15, 20, 30, 45, 60, 90].map((minutes) {
                      final isSelected = selectedMinutes == minutes;
                      return ChoiceChip(
                        label: Text('$minutes min'),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => selectedMinutes = minutes);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'duration_minutes': selectedMinutes,
                    });
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show quantity picker dialog
  static Future<Map<String, dynamic>?> _showQuantityDialog(
    BuildContext context,
    String habitName,
    int defaultQuantity,
    String unit,
  ) async {
    int selectedQuantity = defaultQuantity;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);

            return AlertDialog(
              title: Text('Configure $habitName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How many $unit per day?',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedQuantity > 1
                            ? () => setState(() => selectedQuantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$selectedQuantity',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => setState(() => selectedQuantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'target_quantity': selectedQuantity,
                      'unit': unit,
                    });
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show time picker dialog
  static Future<Map<String, dynamic>?> _showTimeDialog(
    BuildContext context,
    String habitName,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
    );

    if (selectedTime == null) return null;

    final formattedTime =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    return {
      'time': formattedTime,
    };
  }
}
