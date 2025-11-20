import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/focus_providers.dart';
import '../../../../shared/data/models/focus_session_model.dart' hide FocusMode;
import '../widgets/focus_session_card.dart';
import '../widgets/active_session_widget.dart';
import '../widgets/permissions_check_widget.dart';
import '../widgets/focus_mode_selector.dart';
import '../widgets/focus_mode_card.dart';
import 'create_focus_session_page.dart';
import 'focus_history_page.dart';
import 'app_time_limits_page.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  FocusMode _selectedMode = FocusMode.pomodoro;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(focusSessionsProvider);
    final hasActiveSession = sessionsAsync.maybeWhen(
      data: (sessions) => sessions.any((s) => s.status == FocusSessionStatus.active),
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Mode'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
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
      body: Column(
        children: [
          // Mode selector
          FocusModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: (mode) {
              setState(() {
                _selectedMode = mode;
              });
            },
          ),

          // Mode content
          Expanded(
            child: _selectedMode == FocusMode.pomodoro
                ? _buildPomodoroMode(sessionsAsync, hasActiveSession)
                : _buildAppLimitsMode(),
          ),
        ],
      ),
      floatingActionButton: _selectedMode == FocusMode.pomodoro && !hasActiveSession
          ? FloatingActionButton.extended(
              heroTag: 'focus_fab',
              onPressed: () => _navigateToCreateSession(context),
              icon: const Icon(Icons.add),
              label: const Text('New Session'),
            )
          : null,
    );
  }

  Widget _buildPomodoroMode(
    AsyncValue<List<FocusSession>> sessionsAsync,
    bool hasActiveSession,
  ) {
    final theme = Theme.of(context);
    final accessibilityEnabledAsync = ref.watch(accessibilityServiceEnabledProvider);

    return RefreshIndicator(
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
                  return Column(
                    children: const [
                      PermissionsCheckWidget(),
                      SizedBox(height: 16),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            ),

            // Sessions content
            sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return _buildEmptyPomodoroState();
                }

                final activeSessions = sessions
                    .where((s) => s.status == FocusSessionStatus.active)
                    .toList();
                final otherSessions = sessions
                    .where((s) => s.status != FocusSessionStatus.active)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active session
                    if (activeSessions.isNotEmpty) ...[
                      Text(
                        'Active Session',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...activeSessions.map((session) => Column(
                        children: [
                          ActiveSessionWidget(session: session),
                          const SizedBox(height: 24),
                        ],
                      )),
                    ],

                    // Recent sessions
                    if (otherSessions.isNotEmpty) ...[
                      Text(
                        'Recent Sessions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...otherSessions.take(5).map((session) => _buildSessionCard(session)),
                    ],
                  ],
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
                      const Text('Error loading focus sessions'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPomodoroState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FocusModeCard(
          title: 'Pomodoro Focus Timer',
          description: 'Start focused work sessions with timed intervals. '
              'Block distracting apps and stay on track with the Pomodoro technique.',
          icon: Icons.timer,
          onSetup: () => _navigateToCreateSession(context),
          isConfigured: false,
        ),
      ),
    );
  }

  Widget _buildAppLimitsMode() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FocusModeCard(
          title: 'App Time Limits',
          description: 'Set daily usage limits for apps to prevent overuse. '
              'Control your screen time and build healthier digital habits.',
          icon: Icons.app_blocking,
          onSetup: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppTimeLimitsPage(),
              ),
            );
          },
          isConfigured: false, // TODO: Check if user has configured limits
        ),
      ],
    );
  }

  Widget _buildSessionCard(FocusSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          session.status == FocusSessionStatus.completed
              ? Icons.check_circle
              : Icons.cancel,
          color: session.status == FocusSessionStatus.completed
              ? Colors.green
              : Colors.red,
        ),
        title: Text(session.name),
        subtitle: Text(
          '${session.duration.inMinutes} minutes${session.startTime != null ? ' • ${_formatDate(session.startTime!)}' : ''}',
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  void _navigateToCreateSession(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateFocusSessionPage(),
      ),
    );
  }
}
