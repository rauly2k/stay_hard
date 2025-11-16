import 'package:flutter/material.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Alarms Page',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in Phase 5',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
