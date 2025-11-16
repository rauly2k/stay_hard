import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/state/onboarding_state_machine.dart';

/// Request notification permission
class NotificationPermissionPage extends ConsumerWidget {
  const NotificationPermissionPage({super.key});

  Future<void> _requestPermission(BuildContext context, WidgetRef ref) async {
    final status = await Permission.notification.request();

    // Continue regardless of permission result
    if (context.mounted) {
      ref
          .read(onboardingStateMachineProvider.notifier)
          .completeNotificationPermission();
    }
  }

  void _skipForNow(BuildContext context, WidgetRef ref) {
    ref
        .read(onboardingStateMachineProvider.notifier)
        .completeNotificationPermission();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Stay on Track',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Get personalized reminders and motivation to help you build your habits and stay consistent.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Allow button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _requestPermission(context, ref),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Enable Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Skip button
              TextButton(
                onPressed: () => _skipForNow(context, ref),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
