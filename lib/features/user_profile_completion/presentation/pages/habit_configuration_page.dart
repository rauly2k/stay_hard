import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../constants/program_templates.dart';
import '../../constants/habit_templates.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../domain/services/habit_configuration_service.dart';
import '../../domain/state/onboarding_state_machine.dart';
import '../widgets/add_extra_habits_sheet.dart';

/// Page for configuring core habits and adding extras
class HabitConfigurationPage extends ConsumerStatefulWidget {
  const HabitConfigurationPage({super.key});

  @override
  ConsumerState<HabitConfigurationPage> createState() =>
      _HabitConfigurationPageState();
}

class _HabitConfigurationPageState
    extends ConsumerState<HabitConfigurationPage>
    with SingleTickerProviderStateMixin {
  final Map<String, Map<String, dynamic>> _habitConfigurations = {};
  final Set<String> _extraHabitIds = {};
  List<String>? _customHabitIds;
  bool _isLoading = false;
  bool _isLoadingCustomHabits = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String get _programId {
    final state = ref.read(onboardingStateMachineProvider);
    return state.selectedProgramId ?? '';
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (_programId == 'custom') {
      _loadCustomHabits();
    }
  }

  Future<void> _loadCustomHabits() async {
    setState(() => _isLoadingCustomHabits = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userDoc.data();
      if (data != null && data.containsKey('customHabitIds')) {
        final habits = data['customHabitIds'] as List<dynamic>;
        setState(() {
          _customHabitIds = habits.cast<String>();
        });
      }
    } catch (e) {
      debugPrint('[HabitConfiguration] Error loading custom habits: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingCustomHabits = false);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  List<String> get _allHabitIds {
    if (_programId == 'custom') {
      return [...(_customHabitIds ?? []), ..._extraHabitIds];
    }

    final program = ProgramTemplates.findById(_programId);
    if (program == null) return [];
    return [...program.coreHabitIds, ..._extraHabitIds];
  }

  bool get _allConfigured {
    return _allHabitIds.every((habitId) {
      final requiresConfig =
          HabitConfigurationService.requiresConfiguration(habitId);
      return !requiresConfig || _habitConfigurations.containsKey(habitId);
    });
  }

  int get _firstUnlockedIndex {
    if (_programId == 'custom') {
      final habitIds = _customHabitIds ?? [];
      for (int i = 0; i < habitIds.length; i++) {
        final habitId = habitIds[i];
        final requiresConfig =
            HabitConfigurationService.requiresConfiguration(habitId);
        if (requiresConfig && !_habitConfigurations.containsKey(habitId)) {
          return i;
        }
      }
      return habitIds.length;
    }

    final program = ProgramTemplates.findById(_programId);
    if (program == null) return 0;

    for (int i = 0; i < program.coreHabitIds.length; i++) {
      final habitId = program.coreHabitIds[i];
      final requiresConfig =
          HabitConfigurationService.requiresConfiguration(habitId);
      if (requiresConfig && !_habitConfigurations.containsKey(habitId)) {
        return i;
      }
    }
    return program.coreHabitIds.length;
  }

  bool _isHabitUnlocked(int index) {
    return index == 999 || index <= _firstUnlockedIndex;
  }

  Future<void> _configureHabit(String habitId) async {
    final habitTemplate = HabitTemplates.findById(habitId);
    if (habitTemplate == null) return;

    final config = await HabitConfigurationService.showConfigurationDialog(
      context,
      habitId,
      habitTemplate.name,
    );

    if (config != null && mounted) {
      setState(() {
        _habitConfigurations[habitId] = config;
      });
    }
  }

  Future<void> _addExtraHabits() async {
    final List<String> coreHabitIds;
    if (_programId == 'custom') {
      coreHabitIds = _customHabitIds ?? [];
    } else {
      final program = ProgramTemplates.findById(_programId);
      if (program == null) return;
      coreHabitIds = program.coreHabitIds;
    }

    final selectedIds = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExtraHabitsSheet(
        programCoreHabitIds: coreHabitIds,
        currentExtraHabitIds: _extraHabitIds,
      ),
    );

    if (selectedIds != null && mounted) {
      setState(() {
        _extraHabitIds.clear();
        _extraHabitIds.addAll(selectedIds);
      });
    }
  }

  Future<void> _completeConfiguration() async {
    if (!_allConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure all habits before continuing'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      final now = DateTime.now();

      final habits = <Habit>[];
      for (final habitId in _allHabitIds) {
        final config = _habitConfigurations[habitId] ?? {};

        final habit = Habit(
          id: const Uuid().v4(),
          userId: user.uid,
          templateId: habitId,
          configuration: config,
          description: '',
          soundId: 'default',
          repeatConfig: RepeatConfig.daily(),
          timeOfDay: [TimeOfDayEnum.anytime],
          specificReminders: [],
          completionLog: {},
          createdAt: now,
          isActive: true,
          sortOrder: _allHabitIds.indexOf(habitId),
          notificationsEnabled: true,
          aiCoachEnabled: false,
        );

        habits.add(habit);
      }

      if (mounted) {
        ref
            .read(onboardingStateMachineProvider.notifier)
            .completeHabitConfiguration(habits);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_programId == 'custom') {
      if (_isLoadingCustomHabits) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading your custom program...'),
              ],
            ),
          ),
        );
      }

      if (_customHabitIds == null || _customHabitIds!.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('No habits selected for custom program')),
        );
      }
    }

    final program = _programId != 'custom'
        ? ProgramTemplates.findById(_programId)
        : null;

    if (_programId != 'custom' && program == null) {
      return const Scaffold(
        body: Center(child: Text('Program not found')),
      );
    }

    final programName =
        _programId == 'custom' ? 'My Custom Program' : program!.name;
    final programColor =
        _programId == 'custom' ? theme.primaryColor : program!.color;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Configure Your Habits'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Set up $programName',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: programColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configure your habits one by one to unlock the next',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _allHabitIds.isEmpty
                        ? 0
                        : _habitConfigurations.length / _allHabitIds.length,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFFFF6B35)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    _programId == 'custom' ? 'Your Habits' : 'Core Habits',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_programId == 'custom')
                    ...(_customHabitIds ?? []).asMap().entries.map((entry) {
                      final index = entry.key;
                      final habitId = entry.value;
                      return _buildHabitCard(
                          theme, null, habitId, false, index);
                    })
                  else
                    ...program!.coreHabitIds.asMap().entries.map((entry) {
                      final index = entry.key;
                      final habitId = entry.value;
                      return _buildHabitCard(
                          theme, program, habitId, false, index);
                    }),
                  if (_extraHabitIds.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Extra Habits',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._extraHabitIds.map((habitId) {
                      return _buildHabitCard(theme, program, habitId, true, 999);
                    }),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _addExtraHabits,
                    icon: const Icon(Icons.add),
                    label: Text(_extraHabitIds.isEmpty
                        ? 'Add More Habits'
                        : 'Manage Extra Habits'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _isLoading || !_allConfigured ? null : _completeConfiguration,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: programColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          _allConfigured
                              ? 'Complete Setup'
                              : 'Configure All Habits First',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(
    ThemeData theme,
    dynamic program,
    String habitId,
    bool isExtra,
    int index,
  ) {
    final habitTemplate = HabitTemplates.findById(habitId);
    if (habitTemplate == null) return const SizedBox.shrink();

    final requiresConfig =
        HabitConfigurationService.requiresConfiguration(habitId);
    final isConfigured = _habitConfigurations.containsKey(habitId);
    final config = _habitConfigurations[habitId];
    final isUnlocked = _isHabitUnlocked(index);
    final isFirstUnconfigured = index == _firstUnlockedIndex;

    final opacity = isUnlocked ? 1.0 : 0.4;

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: isFirstUnconfigured && !isConfigured
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                          blurRadius: _pulseAnimation.value,
                          spreadRadius: _pulseAnimation.value / 2,
                        ),
                      ]
                    : null,
              ),
              child: InkWell(
                onTap: requiresConfig && isUnlocked
                    ? () => _configureHabit(habitId)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isConfigured
                        ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isConfigured
                          ? const Color(0xFFFF6B35)
                          : isUnlocked
                              ? theme.colorScheme.outline.withValues(alpha: 0.2)
                              : theme.colorScheme.outline.withValues(alpha: 0.1),
                      width: isConfigured ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          habitTemplate.icon,
                          color: const Color(0xFFFF6B35),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habitTemplate.name,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (requiresConfig) ...[
                              const SizedBox(height: 4),
                              Text(
                                isConfigured
                                    ? _getConfigDisplayText(config!)
                                    : 'Tap to configure',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isConfigured
                                      ? const Color(0xFFFF6B35)
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                  fontWeight: isConfigured
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ] else if (!requiresConfig && !isConfigured) ...[
                              const SizedBox(height: 4),
                              Text(
                                'No configuration needed',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (requiresConfig)
                        Icon(
                          isConfigured ? Icons.check_circle : Icons.settings,
                          color: isConfigured
                              ? const Color(0xFFFF6B35)
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                          size: 24,
                        )
                      else
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFFF6B35),
                          size: 24,
                        ),
                      if (isExtra) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _extraHabitIds.remove(habitId);
                              _habitConfigurations.remove(habitId);
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.error,
                          ),
                          iconSize: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getConfigDisplayText(Map<String, dynamic> config) {
    if (config.containsKey('time')) {
      return 'Set to ${config['time']}';
    } else if (config.containsKey('duration_minutes')) {
      final current = config['current_level'] ?? 0;
      final goal = config['duration_minutes'];
      return 'Current: $current min → Goal: $goal min';
    } else if (config.containsKey('target_quantity')) {
      final current = config['current_level'] ?? 0;
      final goal = config['target_quantity'];
      final unit = config['unit'];
      return 'Current: $current $unit → Goal: $goal $unit';
    }
    return 'Configured';
  }
}
