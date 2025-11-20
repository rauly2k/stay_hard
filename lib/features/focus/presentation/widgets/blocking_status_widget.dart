import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/focus_providers.dart';

/// Debug widget to show the current blocking status
/// Helps diagnose why apps might not be getting blocked
class BlockingStatusWidget extends ConsumerWidget {
  const BlockingStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityEnabledAsync = ref.watch(accessibilityServiceEnabledProvider);
    final activeSessionAsync = ref.watch(activeFocusSessionProvider);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Blocking Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Accessibility Service Status
            accessibilityEnabledAsync.when(
              data: (isEnabled) => _buildStatusRow(
                context,
                'Accessibility Service',
                isEnabled,
                isEnabled
                    ? 'Service is enabled ✓'
                    : 'Service is NOT enabled - blocking won\'t work!',
              ),
              loading: () => _buildLoadingRow(context, 'Accessibility Service'),
              error: (_, __) => _buildStatusRow(
                context,
                'Accessibility Service',
                false,
                'Error checking status',
              ),
            ),

            const Divider(),

            // Active Session Status
            activeSessionAsync.when(
              data: (session) {
                if (session != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusRow(
                        context,
                        'Active Session',
                        true,
                        session.name,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mode: ${session.mode.displayName}',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              'Blocked apps: ${session.blockedApps.length}',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              'Status: ${session.status.name}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return _buildStatusRow(
                  context,
                  'Active Session',
                  false,
                  'No active session',
                );
              },
              loading: () => _buildLoadingRow(context, 'Active Session'),
              error: (_, __) => _buildStatusRow(
                context,
                'Active Session',
                false,
                'Error checking status',
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Troubleshooting:',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Enable Accessibility Service in Android Settings',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '2. Start a focus session with blocked apps',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '3. Check Android logs with: adb logcat | grep AppBlockingService',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '4. Make sure the app package names are correct',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    bool isActive,
    String description,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingRow(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
