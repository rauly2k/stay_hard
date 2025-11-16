import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/alarm_model.dart';
import '../../data/repositories/alarm_repository.dart';
import '../../domain/services/alarm_service.dart';

/// Provider for AlarmRepository instance
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepository();
});

/// Provider for AlarmService instance
final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

/// Provider for all alarms stream
final alarmsStreamProvider = StreamProvider<List<AlarmModel>>((ref) {
  final repository = ref.watch(alarmRepositoryProvider);
  return repository.getAlarms();
});

/// Provider for enabled alarms only
final enabledAlarmsProvider = StreamProvider<List<AlarmModel>>((ref) {
  final repository = ref.watch(alarmRepositoryProvider);
  return repository.getEnabledAlarms();
});

/// Provider for single alarm by ID
final alarmByIdProvider = FutureProvider.family<AlarmModel?, String>((ref, alarmId) async {
  final repository = ref.watch(alarmRepositoryProvider);
  return repository.getAlarmById(alarmId);
});

/// Notifier for alarm operations
class AlarmNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createAlarm(AlarmModel alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(alarmRepositoryProvider);
      final alarmService = ref.read(alarmServiceProvider);

      // Save to Firestore
      await repository.createAlarm(alarm);

      // Schedule the alarm using alarm package
      if (alarm.isEnabled) {
        await alarmService.scheduleAlarm(alarm);
      }
    });
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(alarmRepositoryProvider);
      final alarmService = ref.read(alarmServiceProvider);

      // Update in Firestore
      await repository.updateAlarm(alarm);

      // Update the scheduled alarm
      await alarmService.updateAlarm(alarm);
    });
  }

  Future<void> deleteAlarm(String alarmId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(alarmRepositoryProvider);
      final alarmService = ref.read(alarmServiceProvider);

      // Cancel the scheduled alarm
      await alarmService.cancelAlarm(alarmId);

      // Delete from Firestore
      await repository.deleteAlarm(alarmId);
    });
  }

  Future<void> toggleAlarm(String alarmId, bool isEnabled) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(alarmRepositoryProvider);
      final alarmService = ref.read(alarmServiceProvider);

      // Update in Firestore
      await repository.toggleAlarm(alarmId, isEnabled);

      // Get the updated alarm to reschedule or cancel
      final alarm = await repository.getAlarmById(alarmId);
      if (alarm != null) {
        if (isEnabled) {
          await alarmService.scheduleAlarm(alarm);
        } else {
          await alarmService.cancelAlarm(alarmId);
        }
      }
    });
  }
}

/// Provider for AlarmNotifier
final alarmNotifierProvider = NotifierProvider<AlarmNotifier, AsyncValue<void>>(() {
  return AlarmNotifier();
});
