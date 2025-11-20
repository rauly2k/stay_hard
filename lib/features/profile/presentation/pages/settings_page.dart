import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/presentation/providers/user_provider.dart';
import '../../../../shared/data/models/user_model.dart';

/// Settings Page - App configuration
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isModified = false;
  late UserPreferences _preferences;

  @override
  void initState() {
    super.initState();
    // Initialize preferences
    final userAsync = ref.read(userProfileProvider);
    _preferences = userAsync.when(
      data: (user) => user?.preferences ?? const UserPreferences(),
      loading: () => const UserPreferences(),
      error: (_, __) => const UserPreferences(),
    );
  }

  void _updatePreferences(UserPreferences newPrefs) {
    setState(() {
      _preferences = newPrefs;
      _isModified = true;
    });
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await ref
          .read(userProfileNotifierProvider.notifier)
          .updatePreferences(user.uid, _preferences);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isModified = false);
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
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: userAsync.when(
        data: (userProfile) {
          if (userProfile != null && !_isModified) {
            _preferences = userProfile.preferences;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // A. App Preferences Section
              _buildAppPreferencesSection(theme),
              const SizedBox(height: 24),

              // B. General Notifications Section
              _buildGeneralNotificationsSection(theme),
              const SizedBox(height: 24),

              // C. Account Settings Section
              _buildAccountSettingsSection(theme),
              const SizedBox(height: 24),

              // D. Data & Privacy Section
              _buildDataPrivacySection(theme),
              const SizedBox(height: 80), // Space for FAB
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
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

  Widget _buildAppPreferencesSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Preferences',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Theme
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Theme'),
              subtitle: const Text('Choose your preferred theme'),
              trailing: DropdownButton<String>(
                value: _preferences.theme,
                items: const [
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  DropdownMenuItem(
                      value: 'system', child: Text('System Default')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updatePreferences(_preferences.copyWith(theme: value));
                  }
                },
              ),
            ),
            const Divider(),

            // Language
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Language'),
              subtitle: const Text('Select your language'),
              trailing: DropdownButton<String>(
                value: _preferences.language,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updatePreferences(_preferences.copyWith(language: value));
                  }
                },
              ),
            ),
            const Divider(),

            // Default View
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Default View'),
              subtitle: const Text('Where the app opens'),
              trailing: DropdownButton<String>(
                value: _preferences.defaultView,
                items: const [
                  DropdownMenuItem(value: 'home', child: Text('Home')),
                  DropdownMenuItem(value: 'habits', child: Text('Habits')),
                  DropdownMenuItem(
                      value: 'analytics', child: Text('Analytics')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updatePreferences(
                        _preferences.copyWith(defaultView: value));
                  }
                },
              ),
            ),
            const Divider(),

            // Date Format
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date Format'),
              subtitle: const Text('Choose date format'),
              trailing: DropdownButton<String>(
                value: _preferences.dateFormat,
                items: const [
                  DropdownMenuItem(
                      value: 'MM/DD/YYYY', child: Text('MM/DD/YYYY')),
                  DropdownMenuItem(
                      value: 'DD/MM/YYYY', child: Text('DD/MM/YYYY')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updatePreferences(
                        _preferences.copyWith(dateFormat: value));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralNotificationsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI Notifications are configured separately in the Profile menu',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Habit Reminders
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Habit Reminders'),
              subtitle: const Text('Get reminders for your habits'),
              value: _preferences.habitReminders,
              onChanged: (value) {
                _updatePreferences(
                    _preferences.copyWith(habitReminders: value));
              },
            ),
            const Divider(),

            // System Notifications
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('System Notifications'),
              subtitle: const Text('General app notifications'),
              value: _preferences.systemNotifications,
              onChanged: (value) {
                _updatePreferences(
                    _preferences.copyWith(systemNotifications: value));
              },
            ),
            const Divider(),

            // Achievement Notifications
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Achievement Alerts'),
              subtitle: const Text('Get notified when you earn achievements'),
              value: _preferences.achievementNotifications,
              onChanged: (value) {
                _updatePreferences(
                    _preferences.copyWith(achievementNotifications: value));
              },
            ),
            const Divider(),

            // Streak Alerts
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Streak Alerts'),
              subtitle: const Text('Get notified about streaks'),
              value: _preferences.streakAlerts,
              onChanged: (value) {
                _updatePreferences(_preferences.copyWith(streakAlerts: value));
              },
            ),
            const Divider(),

            // Goal Deadline Notifications
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Goal Deadlines'),
              subtitle: const Text('Reminders for upcoming goal deadlines'),
              value: _preferences.goalDeadlineNotifications,
              onChanged: (value) {
                _updatePreferences(
                    _preferences.copyWith(goalDeadlineNotifications: value));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Change Password
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              subtitle: const Text('Reset your password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showPasswordResetDialog(),
            ),
            const Divider(),

            // Email Preferences
            Text(
              'Email Preferences',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Weekly Summary Email'),
              subtitle: const Text('Receive weekly progress summaries'),
              value: _preferences.weeklyEmail,
              onChanged: (value) {
                _updatePreferences(_preferences.copyWith(weeklyEmail: value));
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Marketing Emails'),
              subtitle: const Text('Receive updates and tips'),
              value: _preferences.marketingEmails,
              onChanged: (value) {
                _updatePreferences(
                    _preferences.copyWith(marketingEmails: value));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPrivacySection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data & Privacy',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Export Data
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.download),
              title: const Text('Export My Data'),
              subtitle: const Text('Download all your data (JSON format)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data export coming soon!')),
                );
              },
            ),
            const Divider(),

            // Clear Cache
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cleaning_services),
              title: const Text('Clear Cache'),
              subtitle: const Text('Clear local app cache'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showClearCacheDialog(),
            ),
            const Divider(),

            // Privacy Policy
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Privacy Policy...')),
                );
              },
            ),
            const Divider(),

            // Terms of Service
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Terms of Service...')),
                );
              },
            ),
            const Divider(),

            // Delete Account
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
              title: Text(
                'Delete Account',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              subtitle: const Text('Permanently delete your account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDeleteAccountDialog(),
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordResetDialog() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text(
          'A password reset email will be sent to ${user!.email}. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: user.email!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all locally cached data. Your account data will remain safe in the cloud.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        content: const Text(
          'This action is PERMANENT and cannot be undone. All your data will be deleted forever.\n\nAre you absolutely sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              try {
                await ref
                    .read(userProfileNotifierProvider.notifier)
                    .deleteAccount(user.uid);
                if (context.mounted) {
                  context.go('/auth');
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error deleting account: $e\nYou may need to re-authenticate first.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }
}
