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

/// StateNotifier for alarm operations
class AlarmNotifier extends StateNotifier<AsyncValue<void>> {
  final AlarmRepository _repository;
  final AlarmService _alarmService;

  AlarmNotifier(this._repository, this._alarmService) : super(const AsyncValue.data(null));

  Future<void> createAlarm(AlarmModel alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Save to Firestore
      await _repository.createAlarm(alarm);

      // Schedule the alarm using alarm package
      if (alarm.isEnabled) {
        await _alarmService.scheduleAlarm(alarm);
      }
    });
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Update in Firestore
      await _repository.updateAlarm(alarm);

      // Update the scheduled alarm
      await _alarmService.updateAlarm(alarm);
    });
  }

  Future<void> deleteAlarm(String alarmId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Cancel the scheduled alarm
      await _alarmService.cancelAlarm(alarmId);

      // Delete from Firestore
      await _repository.deleteAlarm(alarmId);
    });
  }

  Future<void> toggleAlarm(String alarmId, bool isEnabled) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Update in Firestore
      await _repository.toggleAlarm(alarmId, isEnabled);

      // Get the updated alarm to reschedule or cancel
      final alarm = await _repository.getAlarmById(alarmId);
      if (alarm != null) {
        if (isEnabled) {
          await _alarmService.scheduleAlarm(alarm);
        } else {
          await _alarmService.cancelAlarm(alarmId);
        }
      }
    });
  }
}

/// Provider for AlarmNotifier
final alarmNotifierProvider = StateNotifierProvider<AlarmNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(alarmRepositoryProvider);
  final alarmService = ref.watch(alarmServiceProvider);
  return AlarmNotifier(repository, alarmService);
});
