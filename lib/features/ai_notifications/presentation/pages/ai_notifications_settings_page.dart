import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/src/framework.dart';
import 'package:stay_hard/features/ai_notifications/presentation/providers/ai_notification_providers.dart';
import '../../data/models/notification_intervention_category.dart';
import '../../data/models/notification_preferences.dart';
import '../../data/models/archetype_details.dart';
import '../providers/notification_preferences_provider.dart';

/// AI Notifications Settings Page
/// Based on AI_NOTIFICATION_SYSTEM_SPEC.md Section 4
class AINotificationsSettingsPage extends ConsumerStatefulWidget {
  const AINotificationsSettingsPage({super.key});

  @override
  ConsumerState<AINotificationsSettingsPage> createState() =>
      _AINotificationsSettingsPageState();
}

class _AINotificationsSettingsPageState
    extends ConsumerState<AINotificationsSettingsPage> {
  late NotificationPreferences _preferences;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current preferences or defaults
    final currentPrefs = ref.read(notificationPreferencesProvider);
    _preferences = currentPrefs.when(
      data: (prefs) => prefs,
      loading: () => NotificationPreferences.defaultPreferences('user-id'),
      error: (error, stack) => NotificationPreferences.defaultPreferences('user-id'),
    );
  }

  void _updatePreferences(NotificationPreferences newPrefs) {
    setState(() {
      _preferences = newPrefs;
      _isModified = true;
    });
  }

  Future<void> _saveChanges() async {
    try {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .updatePreferences(_preferences);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isModified = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Notifications Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Master Controls Section
          _buildMasterControlsSection(theme),
          const SizedBox(height: 24),

          // AI Persona & Style Section (NEW - PROMINENT)
          _buildAIPersonaSection(theme),
          const SizedBox(height: 24),

          // Notification Preferences Section
          _buildNotificationPreferencesSection(theme),
          const SizedBox(height: 24),

          // Intervention Categories Section
          _buildInterventionCategoriesSection(theme),
          const SizedBox(height: 24),

          // Testing & Preview Section
          _buildTestingSection(theme),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
      floatingActionButton: _isModified
          ? FloatingActionButton.extended(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            )
          : null,
    );
  }

  Widget _buildMasterControlsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Master Controls',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable AI Notifications'),
              subtitle: const Text('Master toggle for all AI notifications'),
              value: _preferences.aiNotificationsEnabled,
              onChanged: (value) {
                _updatePreferences(
                  _preferences.copyWith(aiNotificationsEnabled: value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIPersonaSection(ThemeData theme) {
    final configAsync = ref.watch(aiNotificationConfigProvider as ProviderListenable);

    return configAsync.when(
      data: (config) {
        final archetypeDetails = config != null
            ? ArchetypeDetails.getForType(config.archetype)
            : null;

        return Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'AI Persona & Style',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (archetypeDetails != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          archetypeDetails.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                archetypeDetails.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                archetypeDetails.tagline,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    archetypeDetails.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.push('/ai-notifications/persona-select');
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Change Style'),
                    ),
                  ),
                ] else ...[
                  Text(
                    'No persona selected yet',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      context.push('/ai-notifications/persona-select');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Select Persona'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildNotificationPreferencesSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Preferences',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Daily Notification Limit'),
              subtitle: Text(
                '${_preferences.dailyNotificationLimit} notifications per day',
              ),
              trailing: SizedBox(
                width: 100,
                child: Slider(
                  value: _preferences.dailyNotificationLimit.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _preferences.dailyNotificationLimit.toString(),
                  onChanged: (value) {
                    _updatePreferences(
                      _preferences.copyWith(
                        dailyNotificationLimit: value.toInt(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Quiet Hours'),
              subtitle: Text(
                'From ${_preferences.quietHoursStart} to ${_preferences.quietHoursEnd}',
              ),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () => _showQuietHoursDialog(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterventionCategoriesSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Intervention Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...InterventionCategory.values.map(
              (category) => _buildCategoryTile(category, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    InterventionCategory category,
    ThemeData theme,
  ) {
    final isEnabled = _preferences.isCategoryEnabled(category);
    final settings = _preferences.getCategorySettings(category);

    return Column(
      children: [
        SwitchListTile(
          title: Row(
            children: [
              Text(category.icon),
              const SizedBox(width: 8),
              Expanded(child: Text(category.displayName)),
            ],
          ),
          subtitle: Text(category.description),
          value: isEnabled,
          onChanged: (value) {
            final currentPref = _preferences.categoryPreferences[category.name];
            if (currentPref != null) {
              _updatePreferences(
                _preferences.updateCategoryPreference(
                  category,
                  currentPref.copyWith(enabled: value),
                ),
              );
            }
          },
        ),
        if (isEnabled) _buildCategorySettings(category, settings, theme),
        const Divider(),
      ],
    );
  }

  Widget _buildCategorySettings(
    InterventionCategory category,
    Map<String, dynamic> settings,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
      child: _getCategorySpecificSettings(category, settings, theme),
    );
  }

  Widget _getCategorySpecificSettings(
    InterventionCategory category,
    Map<String, dynamic> settings,
    ThemeData theme,
  ) {
    switch (category) {
      case InterventionCategory.morningMotivation:
        return _buildTimeSettings(category, settings['time'] as String);

      case InterventionCategory.eveningCheckIn:
        return _buildTimeSettings(category, settings['time'] as String);

      case InterventionCategory.missedHabitRecovery:
        return Text(
          'Trigger after: ${settings['triggerAfterDays']} days',
          style: theme.textTheme.bodySmall,
        );

      case InterventionCategory.lowMoraleBoost:
        return Text(
          'Sensitivity: ${settings['sensitivity']} • Max ${settings['maxPerWeek']} per week',
          style: theme.textTheme.bodySmall,
        );

      case InterventionCategory.streakCelebration:
        final milestones = settings['milestones'] as List;
        return Text(
          'Milestones: ${milestones.join(', ')} days',
          style: theme.textTheme.bodySmall,
        );

      case InterventionCategory.comebackSupport:
        return Text(
          'After ${settings['inactiveDays']} days away',
          style: theme.textTheme.bodySmall,
        );

      case InterventionCategory.progressInsights:
        return Text(
          'Frequency: ${settings['frequency']}',
          style: theme.textTheme.bodySmall,
        );
    }
  }

  Widget _buildTimeSettings(InterventionCategory category, String time) {
    return Row(
      children: [
        Text('Time: $time'),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => _showTimePickerDialog(category, time),
          child: const Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildTestingSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing & Preview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preview how different interventions will look',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/ai-notifications/test');
                },
                icon: const Text('🧪'),
                label: const Text('Test Notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuietHoursDialog(ThemeData theme) async {
    String? startTime = _preferences.quietHoursStart;
    String? endTime = _preferences.quietHoursEnd;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiet Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(startTime ?? '22:00'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await _pickTime(context, startTime ?? '22:00');
                if (time != null) {
                  startTime = time;
                  Navigator.pop(context);
                  _showQuietHoursDialog(theme);
                }
              },
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(endTime ?? '07:00'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await _pickTime(context, endTime ?? '07:00');
                if (time != null) {
                  endTime = time;
                  Navigator.pop(context);
                  _showQuietHoursDialog(theme);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updatePreferences(
                _preferences.copyWith(
                  quietHoursStart: startTime,
                  quietHoursEnd: endTime,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePickerDialog(
    InterventionCategory category,
    String currentTime,
  ) async {
    final time = await _pickTime(context, currentTime);
    if (time != null) {
      final currentPref = _preferences.categoryPreferences[category.name];
      if (currentPref != null) {
        final updatedSettings =
            Map<String, dynamic>.from(currentPref.customSettings);
        updatedSettings['time'] = time;
        _updatePreferences(
          _preferences.updateCategoryPreference(
            category,
            currentPref.copyWith(customSettings: updatedSettings),
          ),
        );
      }
    }
  }

  Future<String?> _pickTime(BuildContext context, String initialTime) async {
    final parts = initialTime.split(':');
    final initialHour = int.tryParse(parts[0]) ?? 8;
    final initialMinute = int.tryParse(parts[1]) ?? 0;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (time != null) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return null;
  }
}
