import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/alarm_model.dart';
import '../providers/alarm_providers.dart';

class AlarmEditScreen extends ConsumerStatefulWidget {
  final String? alarmId;

  const AlarmEditScreen({super.key, this.alarmId});

  @override
  ConsumerState<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends ConsumerState<AlarmEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _customTextController = TextEditingController();

  TimeOfDay _selectedTime = const TimeOfDay(hour: 6, minute: 0);
  List<int> _selectedDays = [1, 2, 3, 4, 5]; // Weekdays by default
  DismissalMethod _dismissalMethod = DismissalMethod.classic;
  ChallengeDifficulty _challengeDifficulty = ChallengeDifficulty.medium;
  AlarmSound _selectedSound = AlarmSound.defaults.first;
  bool _vibrate = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _labelController.text = 'Wake Up';
    if (widget.alarmId != null) {
      _loadAlarmData();
    }
  }

  Future<void> _loadAlarmData() async {
    if (widget.alarmId == null) return;

    setState(() => _isLoading = true);

    try {
      final alarm = await ref.read(alarmByIdProvider(widget.alarmId!).future);

      if (alarm != null && mounted) {
        setState(() {
          _labelController.text = alarm.label;
          _selectedTime = alarm.time;
          _selectedDays = List.from(alarm.repeatDays);
          _dismissalMethod = alarm.dismissalMethod;
          _challengeDifficulty = alarm.challengeDifficulty ?? ChallengeDifficulty.medium;
          _customTextController.text = alarm.customText ?? '';
          _selectedSound = alarm.sound;
          _vibrate = alarm.vibrate;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.alarmId != null;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Alarm' : 'Create Alarm'),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAlarm,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Time Picker
            _buildTimePickerSection(theme),
            const SizedBox(height: 24),

            // Label
            _buildLabelSection(theme),
            const SizedBox(height: 24),

            // Repeat Days
            _buildRepeatDaysSection(theme),
            const SizedBox(height: 24),

            // Sound Selection
            _buildSoundSection(theme),
            const SizedBox(height: 24),

            // Vibration Toggle
            _buildVibrationSection(theme),
            const SizedBox(height: 24),

            // Dismissal Method
            _buildDismissalMethodSection(theme),
            const SizedBox(height: 24),

            // Dismissal Method Options
            if (_dismissalMethod == DismissalMethod.math ||
                _dismissalMethod == DismissalMethod.textTyping)
              _buildDifficultySection(theme),

            if (_dismissalMethod == DismissalMethod.customText)
              _buildCustomTextSection(theme),

            const SizedBox(height: 32),

            // Save Button
            FilledButton(
              onPressed: _saveAlarm,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isEditing ? 'Save Changes' : 'Create Alarm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerSection(ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: _selectTime,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.access_time, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedTime.format(context),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelSection(ThemeData theme) {
    return TextFormField(
      controller: _labelController,
      decoration: InputDecoration(
        labelText: 'Label',
        hintText: 'Wake Up',
        prefixIcon: const Icon(Icons.label_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a label';
        }
        return null;
      },
    );
  }

  Widget _buildRepeatDaysSection(ThemeData theme) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = _selectedDays.contains(dayNumber);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(dayNumber);
                  } else {
                    _selectedDays.add(dayNumber);
                  }
                  _selectedDays.sort();
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildPresetChip(theme, 'Weekdays', [1, 2, 3, 4, 5]),
            _buildPresetChip(theme, 'Weekends', [6, 7]),
            _buildPresetChip(theme, 'Every day', [1, 2, 3, 4, 5, 6, 7]),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(ThemeData theme, String label, List<int> days) {
    final isSelected = _selectedDays.length == days.length &&
        days.every((day) => _selectedDays.contains(day));

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedDays = List.from(days);
        });
      },
    );
  }

  Widget _buildSoundSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sound',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...AlarmSound.defaults.map((sound) {
          final isSelected = _selectedSound.id == sound.id;
          return RadioListTile<AlarmSound>(
            value: sound,
            groupValue: _selectedSound,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedSound = value);
              }
            },
            title: Text(sound.name),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
          );
        }),
      ],
    );
  }

  Widget _buildVibrationSection(ThemeData theme) {
    return SwitchListTile(
      value: _vibrate,
      onChanged: (value) => setState(() => _vibrate = value),
      title: const Text('Vibration'),
      subtitle: const Text('Vibrate when alarm rings'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: theme.colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildDismissalMethodSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dismissal Method',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...DismissalMethod.values.map((method) {
          final isSelected = _dismissalMethod == method;
          return RadioListTile<DismissalMethod>(
            value: method,
            groupValue: _dismissalMethod,
            onChanged: (value) {
              if (value != null) {
                setState(() => _dismissalMethod = value);
              }
            },
            title: Text(_getDismissalMethodName(method)),
            subtitle: Text(_getDismissalMethodDescription(method)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
          );
        }),
      ],
    );
  }

  Widget _buildDifficultySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<ChallengeDifficulty>(
          segments: const [
            ButtonSegment(
              value: ChallengeDifficulty.easy,
              label: Text('Easy'),
            ),
            ButtonSegment(
              value: ChallengeDifficulty.medium,
              label: Text('Medium'),
            ),
            ButtonSegment(
              value: ChallengeDifficulty.hard,
              label: Text('Hard'),
            ),
          ],
          selected: {_challengeDifficulty},
          onSelectionChanged: (Set<ChallengeDifficulty> selected) {
            setState(() => _challengeDifficulty = selected.first);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCustomTextSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Dismissal Text',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _customTextController,
          decoration: InputDecoration(
            hintText: 'I WILL WIN THE DAY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
          ),
          validator: (value) {
            if (_dismissalMethod == DismissalMethod.customText &&
                (value == null || value.isEmpty)) {
              return 'Please enter dismissal text';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _getDismissalMethodName(DismissalMethod method) {
    switch (method) {
      case DismissalMethod.classic:
        return 'Classic';
      case DismissalMethod.math:
        return 'Math Challenge';
      case DismissalMethod.textTyping:
        return 'Text Typing Challenge';
      case DismissalMethod.customText:
        return 'Custom Text Challenge';
    }
  }

  String _getDismissalMethodDescription(DismissalMethod method) {
    switch (method) {
      case DismissalMethod.classic:
        return 'Simple slide to dismiss';
      case DismissalMethod.math:
        return 'Solve math problems to dismiss';
      case DismissalMethod.textTyping:
        return 'Type a motivational phrase';
      case DismissalMethod.customText:
        return 'Type your own custom text';
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _saveAlarm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final alarm = AlarmModel(
      id: widget.alarmId ?? const Uuid().v4(),
      userId: user.uid,
      time: _selectedTime,
      label: _labelController.text,
      repeatDays: _selectedDays,
      isEnabled: true,
      dismissalMethod: _dismissalMethod,
      challengeDifficulty: (_dismissalMethod == DismissalMethod.math ||
              _dismissalMethod == DismissalMethod.textTyping)
          ? _challengeDifficulty
          : null,
      customText: _dismissalMethod == DismissalMethod.customText
          ? _customTextController.text
          : null,
      sound: _selectedSound,
      vibrate: _vibrate,
      createdAt: DateTime.now(),
    );

    try {
      if (widget.alarmId != null) {
        await ref.read(alarmNotifierProvider.notifier).updateAlarm(alarm);
      } else {
        await ref.read(alarmNotifierProvider.notifier).createAlarm(alarm);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.alarmId != null
                  ? 'Alarm updated successfully'
                  : 'Alarm created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving alarm: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteAlarm() async {
    if (widget.alarmId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alarm'),
        content: const Text('Are you sure you want to delete this alarm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(alarmNotifierProvider.notifier).deleteAlarm(widget.alarmId!);

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alarm deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting alarm: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
