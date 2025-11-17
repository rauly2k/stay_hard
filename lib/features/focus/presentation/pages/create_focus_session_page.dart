import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../../domain/services/app_blocking_service.dart';
import '../providers/focus_providers.dart';
import '../widgets/blocked_apps_selector_sheet.dart';

class CreateFocusSessionPage extends ConsumerStatefulWidget {
  const CreateFocusSessionPage({super.key});

  @override
  ConsumerState<CreateFocusSessionPage> createState() =>
      _CreateFocusSessionPageState();
}

class _CreateFocusSessionPageState
    extends ConsumerState<CreateFocusSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedMode = ref.watch(selectedFocusModeProvider);
    final duration = ref.watch(sessionDurationProvider);
    final selectedApps = ref.watch(selectedBlockedAppsProvider);
    final blockNotifications = ref.watch(blockNotificationsProvider);
    final appBlockingService = ref.watch(appBlockingServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Focus Session'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Session name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Session Name',
                hintText: 'e.g., Morning Deep Work',
                prefixIcon: const Icon(Icons.edit_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a session name';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Focus mode section
            Text(
              'Focus Mode',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFocusModeSelector(theme, selectedMode, appBlockingService),

            const SizedBox(height: 24),

            // Duration section
            Text(
              'Duration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDurationPicker(theme, duration),

            const SizedBox(height: 24),

            // Blocked apps section
            Text(
              'Blocked Apps',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedMode != FocusMode.custom
                  ? 'Preset apps will be blocked for this mode'
                  : 'Select apps to block during this session',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildBlockedAppsCard(theme, selectedApps, selectedMode, appBlockingService),

            const SizedBox(height: 24),

            // Options
            Text(
              'Options',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: blockNotifications,
              onChanged: (value) {
                ref.read(blockNotificationsProvider.notifier).state = value;
              },
              title: const Text('Block Notifications'),
              subtitle: const Text('Silence notifications during session'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: theme.colorScheme.surfaceContainerHighest,
            ),

            const SizedBox(height: 32),

            // Create button
            FilledButton.icon(
              onPressed: () => _createSession(context, ref),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create Focus Session'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusModeSelector(
    ThemeData theme,
    FocusMode selectedMode,
    AppBlockingService appBlockingService,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FocusMode.values.map((mode) {
        final isSelected = selectedMode == mode;
        return ChoiceChip(
          label: Text(mode.displayName),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              ref.read(selectedFocusModeProvider.notifier).state = mode;
              // Update duration to default for this mode
              ref.read(sessionDurationProvider.notifier).state =
                  Duration(minutes: mode.defaultDurationMinutes);
              // Update blocked apps to preset for this mode
              if (mode != FocusMode.custom) {
                ref.read(selectedBlockedAppsProvider.notifier).state =
                    appBlockingService.getPresetBlockedApps(mode);
              } else {
                ref.read(selectedBlockedAppsProvider.notifier).state = [];
              }
            }
          },
          selectedColor: theme.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationPicker(ThemeData theme, Duration duration) {
    final commonDurations = [15, 25, 30, 45, 60, 90, 120];

    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commonDurations.map((minutes) {
            final isSelected = duration.inMinutes == minutes;
            return ChoiceChip(
              label: Text('$minutes min'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(sessionDurationProvider.notifier).state =
                      Duration(minutes: minutes);
                }
              },
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: Text('${duration.inMinutes} minutes'),
          subtitle: const Text('Tap to set custom duration'),
          trailing: const Icon(Icons.chevron_right),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: theme.colorScheme.surfaceContainerHighest,
          onTap: () => _showCustomDurationPicker(context),
        ),
      ],
    );
  }

  Widget _buildBlockedAppsCard(
    ThemeData theme,
    List<String> selectedApps,
    FocusMode mode,
    AppBlockingService appBlockingService,
  ) {
    final appCount = mode != FocusMode.custom
        ? appBlockingService.getPresetBlockedApps(mode).length
        : selectedApps.length;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: mode == FocusMode.custom
            ? () => _showBlockedAppsSelector(context)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.block,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$appCount apps will be blocked',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode != FocusMode.custom
                          ? 'Using preset for ${mode.displayName}'
                          : 'Tap to select apps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (mode == FocusMode.custom)
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomDurationPicker(BuildContext context) async {
    final currentDuration = ref.read(sessionDurationProvider);
    int minutes = currentDuration.inMinutes;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Duration'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$minutes minutes',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Slider(
                  value: minutes.toDouble(),
                  min: 5,
                  max: 480, // 8 hours
                  divisions: 95,
                  label: '$minutes min',
                  onChanged: (value) {
                    setState(() {
                      minutes = value.toInt();
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(sessionDurationProvider.notifier).state =
                  Duration(minutes: minutes);
              Navigator.pop(context);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showBlockedAppsSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BlockedAppsSelectorSheet(),
    );
  }

  void _createSession(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final mode = ref.read(selectedFocusModeProvider);
    final duration = ref.read(sessionDurationProvider);
    final selectedApps = ref.read(selectedBlockedAppsProvider);
    final blockNotifications = ref.read(blockNotificationsProvider);
    final appBlockingService = ref.read(appBlockingServiceProvider);

    // Get blocked apps based on mode
    final blockedApps = mode != FocusMode.custom
        ? appBlockingService.getPresetBlockedApps(mode)
        : selectedApps;

    if (blockedApps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one app to block'),
        ),
      );
      return;
    }

    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '', // Will be set by repository
      name: _nameController.text.trim(),
      duration: duration,
      blockedApps: blockedApps,
      blockNotifications: blockNotifications,
      status: FocusSessionStatus.scheduled,
      mode: mode,
      createdAt: DateTime.now(),
    );

    await ref.read(focusSessionNotifierProvider.notifier).createSession(session);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Focus session created successfully'),
        ),
      );

      // Ask if user wants to start immediately
      final shouldStart = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Start Now?'),
          content: const Text(
            'Would you like to start this focus session now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Start Now'),
            ),
          ],
        ),
      );

      if (shouldStart == true && context.mounted) {
        await ref.read(focusSessionNotifierProvider.notifier).startSession(session.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Focus session started! 🎯'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }
}
