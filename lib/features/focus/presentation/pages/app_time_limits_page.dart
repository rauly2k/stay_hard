import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stay_hard/features/focus/presentation/providers/focus_providers.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../providers/time_limit_providers.dart';
import '../../domain/services/app_usage_tracking_service.dart';

/// Page for managing app time limits
class AppTimeLimitsPage extends ConsumerStatefulWidget {
  const AppTimeLimitsPage({super.key});

  @override
  ConsumerState<AppTimeLimitsPage> createState() => _AppTimeLimitsPageState();
}

class _AppTimeLimitsPageState extends ConsumerState<AppTimeLimitsPage> {
  @override
  Widget build(BuildContext context) {
    final timeLimitsAsync = ref.watch(appTimeLimitsProvider);
    final usageService = ref.watch(appUsageTrackingServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Time Limits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTimeLimitDialog(context),
            tooltip: 'Add Time Limit',
          ),
        ],
      ),
      body: timeLimitsAsync.when(
        data: (limits) {
          if (limits.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(appTimeLimitsProvider);
              await usageService.syncUsageData();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: limits.length,
              itemBuilder: (context, index) {
                return _AppTimeLimitCard(
                  limit: limits[index],
                  onEdit: () => _showEditTimeLimitDialog(context, limits[index]),
                  onDelete: () => _deleteTimeLimit(limits[index].id),
                  onToggle: (enabled) => _toggleTimeLimit(limits[index], enabled),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading time limits: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No App Time Limits',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set daily time limits for specific apps',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddTimeLimitDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Time Limit'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTimeLimitDialog(BuildContext context) async {
    final result = await showDialog<AppTimeLimit>(
      context: context,
      builder: (context) => const _AddTimeLimitDialog(),
    );

    if (result != null) {
      await ref
          .read(timeLimitNotifierProvider.notifier)
          .createTimeLimit(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time limit added for ${result.appName}')),
        );
      }
    }
  }

  Future<void> _showEditTimeLimitDialog(
      BuildContext context, AppTimeLimit limit) async {
    final result = await showDialog<AppTimeLimit>(
      context: context,
      builder: (context) => _AddTimeLimitDialog(existingLimit: limit),
    );

    if (result != null) {
      await ref
          .read(timeLimitNotifierProvider.notifier)
          .updateTimeLimit(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time limit updated for ${result.appName}')),
        );
      }
    }
  }

  Future<void> _deleteTimeLimit(String limitId) async {
    await ref.read(timeLimitNotifierProvider.notifier).deleteTimeLimit(limitId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time limit removed')),
      );
    }
  }

  Future<void> _toggleTimeLimit(AppTimeLimit limit, bool enabled) async {
    final updated = limit.copyWith(
      isEnabled: enabled,
      lastModified: DateTime.now(),
    );
    await ref.read(timeLimitNotifierProvider.notifier).updateTimeLimit(updated);
  }
}

/// Card widget for displaying an app time limit
class _AppTimeLimitCard extends ConsumerWidget {
  final AppTimeLimit limit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _AppTimeLimitCard({
    required this.limit,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageService = ref.watch(appUsageTrackingServiceProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        limit.appName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daily limit: ${_formatDuration(limit.dailyLimit)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: limit.isEnabled,
                  onChanged: onToggle,
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<AppUsageStats>(
              future: usageService.getAppUsageStats(limit.packageName),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final stats = snapshot.data!;
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: stats.usagePercentage / 100,
                      backgroundColor: Colors.grey[200],
                      color: stats.isBlocked ? Colors.red : Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Used: ${stats.currentUsageFormatted}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          stats.isBlocked
                              ? 'Blocked'
                              : 'Remaining: ${stats.remainingTimeFormatted}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: stats.isBlocked ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

/// Dialog for adding or editing a time limit
class _AddTimeLimitDialog extends ConsumerStatefulWidget {
  final AppTimeLimit? existingLimit;

  const _AddTimeLimitDialog({this.existingLimit});

  @override
  ConsumerState<_AddTimeLimitDialog> createState() =>
      _AddTimeLimitDialogState();
}

class _AddTimeLimitDialogState extends ConsumerState<_AddTimeLimitDialog> {
  InstalledAppInfo? selectedApp;
  int hours = 1;
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingLimit != null) {
      hours = widget.existingLimit!.dailyLimit.inHours;
      minutes = widget.existingLimit!.dailyLimit.inMinutes.remainder(60);
    }
  }

  @override
  Widget build(BuildContext context) {
    final installedAppsAsync = ref.watch(installedAppsProvider);

    return AlertDialog(
      title: Text(widget.existingLimit == null
          ? 'Add Time Limit'
          : 'Edit Time Limit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.existingLimit == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select App'),
                  const SizedBox(height: 8),
                  installedAppsAsync.when(
                    data: (apps) {
                      return DropdownButton<InstalledAppInfo>(
                        value: selectedApp,
                        isExpanded: true,
                        hint: const Text('Choose an app'),
                        items: apps.map((app) {
                          return DropdownMenuItem(
                            value: app,
                            child: Text(app.name),
                          );
                        }).toList(),
                        onChanged: (app) {
                          setState(() {
                            selectedApp = app;
                          });
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, _) => const Text('Error loading apps'),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App: ${widget.existingLimit!.appName}'),
                  const SizedBox(height: 16),
                ],
              ),
            const Text('Daily Time Limit'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hours'),
                      DropdownButton<int>(
                        value: hours,
                        isExpanded: true,
                        items: List.generate(13, (index) => index).map((h) {
                          return DropdownMenuItem(
                            value: h,
                            child: Text('$h'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            hours = value ?? 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minutes'),
                      DropdownButton<int>(
                        value: minutes,
                        isExpanded: true,
                        items: [0, 15, 30, 45].map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text('$m'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            minutes = value ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canSave() ? _save : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  bool _canSave() {
    if (widget.existingLimit != null) {
      return hours > 0 || minutes > 0;
    }
    return selectedApp != null && (hours > 0 || minutes > 0);
  }

  void _save() {
    final userId = ref.read(userIdProvider);
    final dailyLimit = Duration(hours: hours, minutes: minutes);

    final limit = widget.existingLimit?.copyWith(
          dailyLimit: dailyLimit,
          lastModified: DateTime.now(),
        ) ??
        AppTimeLimit(
          id: const Uuid().v4(),
          userId: userId,
          packageName: selectedApp!.packageName,
          appName: selectedApp!.name,
          dailyLimit: dailyLimit,
          isEnabled: true,
          createdAt: DateTime.now(),
        );

    Navigator.pop(context, limit);
  }
}
