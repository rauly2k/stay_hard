import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../user_profile_completion/constants/habit_templates.dart';
import '../providers/habit_providers.dart';

class EditHabitPage extends ConsumerStatefulWidget {
  final Habit habit;

  const EditHabitPage({
    super.key,
    required this.habit,
  });

  @override
  ConsumerState<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends ConsumerState<EditHabitPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _targetValueController;
  late Map<String, dynamic> _configuration;
  late List<TimeOfDayEnum> _selectedTimeOfDay;
  late bool _notificationsEnabled;
  late RepeatConfig _repeatConfig;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.habit.description);
    _configuration = Map.from(widget.habit.configuration);
    _selectedTimeOfDay = List.from(widget.habit.timeOfDay);
    _notificationsEnabled = widget.habit.notificationsEnabled;
    _repeatConfig = widget.habit.repeatConfig;

    // Initialize target value controller based on config type
    final template = HabitTemplates.findById(widget.habit.templateId);
    if (template != null) {
      switch (template.configType) {
        case HabitConfigType.duration:
          _targetValueController = TextEditingController(
            text: (_configuration['targetMinutes'] as int? ?? 0).toString(),
          );
          break;
        case HabitConfigType.quantity:
          _targetValueController = TextEditingController(
            text: (_configuration['targetQuantity'] as int? ?? 0).toString(),
          );
          break;
        default:
          _targetValueController = TextEditingController();
      }
    } else {
      _targetValueController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _targetValueController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      // Update configuration based on template type
      final template = HabitTemplates.findById(widget.habit.templateId);
      if (template != null) {
        switch (template.configType) {
          case HabitConfigType.duration:
            final minutes = int.tryParse(_targetValueController.text) ?? 0;
            _configuration['targetMinutes'] = minutes;
            break;
          case HabitConfigType.quantity:
            final quantity = int.tryParse(_targetValueController.text) ?? 0;
            _configuration['targetQuantity'] = quantity;
            break;
          default:
            break;
        }
      }

      final updatedHabit = widget.habit.copyWith(
        configuration: _configuration,
        description: _descriptionController.text,
        timeOfDay: _selectedTimeOfDay,
        notificationsEnabled: _notificationsEnabled,
        repeatConfig: _repeatConfig,
      );

      await ref.read(habitFormProvider.notifier).saveHabit(updatedHabit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating habit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final template = HabitTemplates.findById(widget.habit.templateId);
    final habitColor = template?.color ?? theme.colorScheme.primary;
    final habitIcon = template?.icon ?? Icons.check_circle;
    final habitName = template?.name ?? 'Unknown Habit';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: habitColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Habit'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: habitColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      habitIcon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    habitName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal Configuration
                  if (template != null &&
                      template.configType != HabitConfigType.none) ...[
                    Text(
                      'Goal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGoalField(template),
                    const SizedBox(height: 24),
                  ],

                  // Time of Day
                  Text(
                    'Time of Day',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TimeOfDayEnum.values.map((timeOfDay) {
                      final isSelected = _selectedTimeOfDay.contains(timeOfDay);
                      return FilterChip(
                        label: Text(_getTimeOfDayLabel(timeOfDay)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTimeOfDay.add(timeOfDay);
                            } else {
                              if (_selectedTimeOfDay.length > 1) {
                                _selectedTimeOfDay.remove(timeOfDay);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'At least one time of day must be selected'),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        selectedColor: habitColor.withValues(alpha: 0.3),
                        checkmarkColor: habitColor,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Repeat Configuration
                  Text(
                    'Repeat',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRepeatSection(),

                  const SizedBox(height: 24),

                  // Description/Notes
                  Text(
                    'Notes (Optional)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add any notes about this habit...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notifications Toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifications',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Remind me to complete this habit',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalField(HabitTemplate template) {
    final theme = Theme.of(context);

    switch (template.configType) {
      case HabitConfigType.duration:
        return TextField(
          controller: _targetValueController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Duration (minutes)',
            prefixIcon: const Icon(Icons.timer),
            suffixText: 'min',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case HabitConfigType.quantity:
        final unit = _configuration['unit'] as String? ?? 'items';
        return TextField(
          controller: _targetValueController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Quantity',
            prefixIcon: const Icon(Icons.format_list_numbered),
            suffixText: unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRepeatSection() {
    final theme = Theme.of(context);

    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Daily'),
          value: 'daily',
          groupValue: _repeatConfig.isDaily ? 'daily' : 'specific',
          onChanged: (value) {
            setState(() {
              _repeatConfig = RepeatConfig.daily();
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text('Specific Days'),
          value: 'specific',
          groupValue: _repeatConfig.isDaily ? 'daily' : 'specific',
          onChanged: (value) {
            setState(() {
              _repeatConfig = RepeatConfig.specificDays([1, 2, 3, 4, 5]);
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        if (!_repeatConfig.isDaily &&
            _repeatConfig.specificDays != null) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(7, (index) {
              final day = index + 1;
              final isSelected =
                  _repeatConfig.specificDays?.contains(day) ?? false;
              return FilterChip(
                label: Text(_getDayName(day)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    final days = List<int>.from(_repeatConfig.specificDays ?? []);
                    if (selected) {
                      days.add(day);
                    } else {
                      if (days.length > 1) {
                        days.remove(day);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('At least one day must be selected'),
                          ),
                        );
                        return;
                      }
                    }
                    days.sort();
                    _repeatConfig = RepeatConfig.specificDays(days);
                  });
                },
              );
            }),
          ),
        ],
      ],
    );
  }

  String _getTimeOfDayLabel(TimeOfDayEnum timeOfDay) {
    switch (timeOfDay) {
      case TimeOfDayEnum.morning:
        return 'Morning';
      case TimeOfDayEnum.afternoon:
        return 'Afternoon';
      case TimeOfDayEnum.evening:
        return 'Evening';
      case TimeOfDayEnum.anytime:
        return 'Anytime';
    }
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}
