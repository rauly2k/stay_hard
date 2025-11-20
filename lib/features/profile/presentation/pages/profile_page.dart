import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stay_hard/features/ai_notifications/presentation/providers/ai_notification_providers.dart';
import '../../../../shared/presentation/providers/user_provider.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../../ai_notifications/data/models/ai_notification_config.dart';
import '../../../ai_notifications/data/models/archetype_details.dart';

/// Profile Page - User dashboard
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final userProfileAsync = ref.watch(userProfileProvider);
    final activeGoalsAsync = ref.watch(activeGoalsProvider);
    final notificationConfigAsync = ref.watch(currentUserAIConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: userProfileAsync.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('No user data'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // A. Basic Info Section
              _buildBasicInfoSection(context, theme, user, userProfile, ref),
              const SizedBox(height: 24),

              // B. Personal Motivation Section
              _buildPersonalMotivationSection(
                  context, theme, userProfile, ref),
              const SizedBox(height: 24),

              // C. My Goals Section
              activeGoalsAsync.when(
                data: (goals) => _buildMyGoalsSection(context, theme, goals),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // D. Account Stats Section
              _buildAccountStatsSection(context, theme, userProfile),
              const SizedBox(height: 24),

              // E. Preferences Summary Section
              notificationConfigAsync.when(
                data: (config) => _buildPreferencesSummarySection(
                    context, theme, userProfile, config),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBasicInfoSection(
    BuildContext context,
    ThemeData theme,
    User? user,
    dynamic userProfile,
    WidgetRef ref,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Photo
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.colorScheme.primary,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Text(
                              (user?.displayName?.isNotEmpty == true)
                                  ? user!.displayName!.substring(0, 1).toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Photo upload coming soon!')),
                            );
                          },
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Name
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user?.displayName ?? 'User',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _showEditNameDialog(
                                context, ref, user?.uid ?? ''),
                          ),
                        ],
                      ),
                      // Email
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      // Member Since
                      if (userProfile.createdAt != null)
                        Text(
                          'Member since ${DateFormat('MMM yyyy').format(userProfile.createdAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalMotivationSection(
    BuildContext context,
    ThemeData theme,
    dynamic userProfile,
    WidgetRef ref,
  ) {
    final hasCommitment = userProfile.commitmentMessage != null &&
        userProfile.commitmentMessage.isNotEmpty;

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'My Word to Myself',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasCommitment) ...[
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
                child: Text(
                  '"${userProfile.commitmentMessage}"',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () => _showEditCommitmentDialog(
                      context, ref, userProfile.uid, userProfile.commitmentMessage),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Update My Commitment'),
                ),
              ),
            ] else ...[
              Text(
                'You haven\'t set your commitment message yet.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _showEditCommitmentDialog(
                    context, ref, userProfile.uid, null),
                icon: const Icon(Icons.add),
                label: const Text('Add Commitment Message'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMyGoalsSection(
    BuildContext context,
    ThemeData theme,
    List<dynamic> goals,
  ) {
    final activeGoals = goals.where((g) => g.status == 'active').take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Goals',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Goals tab (index 1 in bottom nav)
                    context.go('/home');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (activeGoals.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No active goals yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...activeGoals.map((goal) => _buildGoalSummaryTile(theme, goal)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSummaryTile(ThemeData theme, dynamic goal) {
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    final isOverdue = daysRemaining < 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? theme.colorScheme.error.withValues(alpha: 0.1)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOverdue
                        ? 'Overdue'
                        : '${daysRemaining.abs()} days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverdue
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Target: ${DateFormat('MMM dd, yyyy').format(goal.targetDate)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (goal.habitIds.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${goal.habitIds.length} linked habit${goal.habitIds.length != 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatsSection(
    BuildContext context,
    ThemeData theme,
    dynamic userProfile,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Stats',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatTile(
              theme,
              'Member Since',
              userProfile.createdAt != null
                  ? DateFormat('MMM dd, yyyy').format(userProfile.createdAt)
                  : 'N/A',
              Icons.calendar_today,
            ),
            _buildStatTile(
              theme,
              'Current Streak',
              '0 days', // TODO: Implement streak calculation
              Icons.local_fire_department,
            ),
            _buildStatTile(
              theme,
              'Total Habits Tracked',
              '0 habits', // TODO: Implement habit count
              Icons.check_circle_outline,
            ),
            _buildStatTile(
              theme,
              'Completion Rate',
              '0%', // TODO: Implement completion rate
              Icons.analytics_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSummarySection(
    BuildContext context,
    ThemeData theme,
    dynamic userProfile,
    AINotificationConfig? config,
  ) {
    final archetypeDetails = config != null
        ? ArchetypeDetails.getForType(config.archetype)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Preferences',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_active,
                  color: theme.colorScheme.primary),
              title: const Text('AI Notification Style'),
              subtitle: Text(archetypeDetails?.name ?? 'Not set'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/ai-notifications/settings'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.palette, color: theme.colorScheme.primary),
              title: const Text('Theme'),
              subtitle: Text(
                userProfile.preferences.theme == 'system'
                    ? 'System Default'
                    : userProfile.preferences.theme == 'dark'
                        ? 'Dark'
                        : 'Light',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/settings'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  Icon(Icons.date_range, color: theme.colorScheme.primary),
              title: const Text('Date Format'),
              subtitle: Text(userProfile.preferences.dateFormat),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String uid) {
    final controller = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                try {
                  await ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateDisplayName(uid, name);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name updated successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditCommitmentDialog(
    BuildContext context,
    WidgetRef ref,
    String uid,
    String? currentMessage,
  ) {
    final controller = TextEditingController(text: currentMessage ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update My Commitment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Commitment Message',
            hintText: 'Dear future me...',
          ),
          maxLines: 5,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final message = controller.text.trim();
              if (message.isNotEmpty) {
                try {
                  await ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateCommitmentMessage(uid, message);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Commitment updated successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
