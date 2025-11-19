import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Profile menu dropdown component
/// Based on AI_NOTIFICATION_SYSTEM_SPEC.md Section 3
class ProfileMenuDropdown extends StatelessWidget {
  const ProfileMenuDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.person_outline),
      tooltip: 'Profile',
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => [
        // User info header
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),

        // Profile
        const PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person),
            title: Text('Profile'),
            dense: true,
          ),
        ),

        // Settings
        const PopupMenuItem<String>(
          value: 'settings',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            dense: true,
          ),
        ),

        // AI Notifications - PROMINENT POSITION
        PopupMenuItem<String>(
          value: 'ai-notifications',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.notifications_active,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'AI Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            dense: true,
          ),
        ),

        // Subscription
        const PopupMenuItem<String>(
          value: 'subscription',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.card_membership),
            title: Text('Subscription'),
            dense: true,
          ),
        ),

        // Statistics & Analytics
        const PopupMenuItem<String>(
          value: 'analytics',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.bar_chart),
            title: Text('Statistics & Analytics'),
            dense: true,
          ),
        ),

        // Help & Support
        const PopupMenuItem<String>(
          value: 'help',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            dense: true,
          ),
        ),

        // About & Privacy
        const PopupMenuItem<String>(
          value: 'about',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline),
            title: Text('About & Privacy'),
            dense: true,
          ),
        ),

        // Divider before logout
        const PopupMenuDivider(),

        // Logout
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.logout,
              color: theme.colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
            dense: true,
          ),
        ),
      ],
      onSelected: (value) => _handleMenuAction(context, value),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile page coming soon!')),
        );
        break;

      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings page coming soon!')),
        );
        break;

      case 'ai-notifications':
        context.push('/ai-notifications/settings');
        break;

      case 'subscription':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription page coming soon!')),
        );
        break;

      case 'analytics':
        // Analytics is already in the bottom nav, could navigate there
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check the Analytics tab!')),
        );
        break;

      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help & Support coming soon!')),
        );
        break;

      case 'about':
        _showAboutDialog(context);
        break;

      case 'logout':
        _handleLogout(context);
        break;
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'StayHard',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(),
      children: const [
        Text('A habit tracking app with AI-powered motivation.'),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          context.go('/auth');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
