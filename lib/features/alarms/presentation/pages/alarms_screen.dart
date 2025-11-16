import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/alarm_providers.dart';
import '../widgets/alarm_card.dart';
import '../../../../shared/presentation/widgets/ai_empty_state.dart';

class AlarmsScreen extends ConsumerWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        centerTitle: true,
      ),
      body: alarmsAsync.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return AIEmptyState(
              pageType: 'alarms',
              icon: Icons.alarm,
              title: 'No alarms set',
              subtitle: 'Create your first alarm to start building discipline',
              actionText: 'Create Alarm',
              onActionPressed: () => _navigateToCreateAlarm(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return AlarmCard(
                alarm: alarm,
                onTap: () => _navigateToEditAlarm(context, alarm.id),
                onToggle: (value) => _toggleAlarm(ref, alarm.id, value),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading alarms',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateAlarm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateAlarm(BuildContext context) {
    context.push('/alarms/create');
  }

  void _navigateToEditAlarm(BuildContext context, String alarmId) {
    context.push('/alarms/edit/$alarmId');
  }

  void _toggleAlarm(WidgetRef ref, String alarmId, bool value) {
    ref.read(alarmNotifierProvider.notifier).toggleAlarm(alarmId, value);
  }
}
