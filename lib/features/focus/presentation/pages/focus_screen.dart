import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/focus_providers.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../widgets/focus_session_card.dart';
import '../widgets/active_session_widget.dart';
import '../widgets/permissions_check_widget.dart';
import 'create_focus_session_page.dart';
import 'focus_history_page.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeSessionAsync = ref.watch(activeFocusSessionProvider);
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final accessibilityEnabledAsync =
        ref.watch(accessibilityServiceEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to focus history/statistics
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FocusHistoryPage(),
                ),
              );
            },
            tooltip: 'Focus History',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(focusSessionsProvider);
          ref.invalidate(activeFocusSessionProvider);
          ref.invalidate(accessibilityServiceEnabledProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Permissions check
              accessibilityEnabledAsync.when(
                data: (isEnabled) {
                  if (!isEnabled) {
                    return const PermissionsCheckWidget();
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // Active session widget
              activeSessionAsync.when(
                data: (activeSession) {
                  if (activeSession != null) {
                    return Column(
                      children: [
                        ActiveSessionWidget(session: activeSession),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // Section header
              Text(
                'Focus Sessions',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Sessions list
              sessionsAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  // Filter out active sessions (shown above)
                  final inactiveSessions = sessions
                      .where((s) => s.status != FocusSessionStatus.active)
                      .toList();

                  return Column(
                    children: inactiveSessions
                        .map((session) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FocusSessionCard(session: session),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading sessions',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateFocusSessionPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Session'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.center_focus_strong,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No Focus Sessions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first focus session to block distractions and stay productive',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateFocusSessionPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Focus Session'),
            ),
          ],
        ),
      ),
    );
  }
}
