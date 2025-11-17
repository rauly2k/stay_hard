import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../providers/focus_providers.dart';

class FocusSessionCard extends ConsumerWidget {
  final FocusSession session;

  const FocusSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showSessionDetails(context, ref),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor(theme).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getModeIcon(),
                      color: _getStatusColor(theme),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatusChip(theme),
                            const SizedBox(width: 8),
                            Text(
                              session.mode.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action menu
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(context, ref, value),
                    itemBuilder: (context) => [
                      if (session.status == FocusSessionStatus.scheduled)
                        const PopupMenuItem(
                          value: 'start',
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text('Start Session'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  _buildStatChip(
                    theme,
                    Icons.timer_outlined,
                    '${session.duration.inMinutes} min',
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    theme,
                    Icons.block,
                    '${session.blockedApps.length} apps',
                  ),
                  if (session.blockAttempts > 0) ...[
                    const SizedBox(width: 8),
                    _buildStatChip(
                      theme,
                      Icons.warning_amber,
                      '${session.blockAttempts} attempts',
                      color: theme.colorScheme.error,
                    ),
                  ],
                ],
              ),

              // Progress bar for completed sessions
              if (session.status == FocusSessionStatus.completed &&
                  session.startTime != null &&
                  session.endTime != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed on ${_formatDate(session.endTime!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final color = _getStatusColor(theme);
    final text = _getStatusText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, IconData icon, String text,
      {Color? color}) {
    final chipColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (session.status) {
      case FocusSessionStatus.scheduled:
        return theme.colorScheme.primary;
      case FocusSessionStatus.active:
        return Colors.green;
      case FocusSessionStatus.paused:
        return Colors.orange;
      case FocusSessionStatus.completed:
        return theme.colorScheme.primary;
      case FocusSessionStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  String _getStatusText() {
    switch (session.status) {
      case FocusSessionStatus.scheduled:
        return 'Scheduled';
      case FocusSessionStatus.active:
        return 'Active';
      case FocusSessionStatus.paused:
        return 'Paused';
      case FocusSessionStatus.completed:
        return 'Completed';
      case FocusSessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData _getModeIcon() {
    switch (session.mode) {
      case FocusMode.deepWork:
        return Icons.work_outline;
      case FocusMode.study:
        return Icons.school_outlined;
      case FocusMode.bedtime:
        return Icons.bedtime_outlined;
      case FocusMode.minimalDistraction:
        return Icons.do_not_disturb_on_outlined;
      case FocusMode.custom:
        return Icons.tune;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  void _showSessionDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SessionDetailsSheet(session: session),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    final notifier = ref.read(focusSessionNotifierProvider.notifier);

    switch (action) {
      case 'start':
        notifier.startSession(session.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Focus session started')),
        );
        break;

      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text(
          'Are you sure you want to delete this focus session? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(focusSessionNotifierProvider.notifier).deleteSession(session.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session deleted')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SessionDetailsSheet extends StatelessWidget {
  final FocusSession session;

  const _SessionDetailsSheet({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    session.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session.mode.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDetailSection(
                    theme,
                    'Duration',
                    '${session.duration.inMinutes} minutes',
                    Icons.timer_outlined,
                  ),
                  const SizedBox(height: 16),

                  _buildDetailSection(
                    theme,
                    'Blocked Apps',
                    '${session.blockedApps.length} apps blocked',
                    Icons.block,
                  ),
                  const SizedBox(height: 16),

                  if (session.blockNotifications)
                    _buildDetailSection(
                      theme,
                      'Notifications',
                      'Blocked during session',
                      Icons.notifications_off_outlined,
                    ),

                  if (session.blockAttempts > 0) ...[
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      theme,
                      'Block Attempts',
                      '${session.blockAttempts} attempts to access blocked apps',
                      Icons.warning_amber,
                    ),
                  ],

                  const SizedBox(height: 24),
                  Text(
                    'Created ${_formatDate(session.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailSection(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
