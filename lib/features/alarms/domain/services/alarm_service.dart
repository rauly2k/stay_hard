import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import '../../../../shared/data/models/alarm_model.dart';

/// Service for managing alarm scheduling and triggering
class AlarmService {
  /// Initialize alarm service
  static Future<void> initialize() async {
    await Alarm.init();
  }

  /// Schedule an alarm using the alarm package
  Future<void> scheduleAlarm(AlarmModel alarmModel) async {
    try {
      // Calculate next alarm time
      final now = DateTime.now();
      final alarmDateTime = _calculateNextAlarmTime(alarmModel, now);

      if (alarmDateTime == null) {
        debugPrint('No valid alarm time for alarm: ${alarmModel.id}');
        return;
      }

      // Create alarm settings
      final alarmSettings = AlarmSettings(
        id: alarmModel.id.hashCode, // Convert string ID to int
        dateTime: alarmDateTime,
        assetAudioPath: alarmModel.sound.assetPath,
        loopAudio: true,
        vibrate: alarmModel.vibrate,
        volumeSettings: VolumeSettings.fade(
          fadeDuration: const Duration(seconds: 3),
          volume: 0.8,
        ),
        notificationSettings: NotificationSettings(
          title: alarmModel.label,
          body: 'Time to wake up!',
          stopButton: null, // No stop button - force user to solve challenge
        ),
      );

      // Schedule the alarm
      await Alarm.set(alarmSettings: alarmSettings);

      debugPrint(
        'Alarm scheduled: ${alarmModel.id} at $alarmDateTime',
      );
    } catch (e) {
      debugPrint('Error scheduling alarm: $e');
      rethrow;
    }
  }

  /// Cancel a scheduled alarm
  Future<void> cancelAlarm(String alarmId) async {
    try {
      await Alarm.stop(alarmId.hashCode);
      debugPrint('Alarm cancelled: $alarmId');
    } catch (e) {
      debugPrint('Error cancelling alarm: $e');
      rethrow;
    }
  }

  /// Update an existing alarm (cancel old and schedule new)
  Future<void> updateAlarm(AlarmModel alarmModel) async {
    await cancelAlarm(alarmModel.id);
    if (alarmModel.isEnabled) {
      await scheduleAlarm(alarmModel);
    }
  }

  /// Check if an alarm is currently ringing
  static Future<bool> isRinging(int alarmId) async {
    return await Alarm.isRinging(alarmId);
  }

  /// Get stream of ringing alarms
  static Stream<AlarmSettings> get ringStream => Alarm.ringStream.stream;

  /// Calculate next alarm time based on alarm configuration
  DateTime? _calculateNextAlarmTime(AlarmModel alarmModel, DateTime now) {
    if (alarmModel.repeatDays.isEmpty) {
      // One-time alarm
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        alarmModel.time.hour,
        alarmModel.time.minute,
      );

      // If time has passed today, schedule for tomorrow
      if (alarmTime.isBefore(now)) {
        return alarmTime.add(const Duration(days: 1));
      }
      return alarmTime;
    }

    // Repeating alarm - find next occurrence
    DateTime candidate = DateTime(
      now.year,
      now.month,
      now.day,
      alarmModel.time.hour,
      alarmModel.time.minute,
    );

    // If time has passed today, start checking from tomorrow
    if (candidate.isBefore(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    // Find next valid day (max 7 days ahead)
    for (int i = 0; i < 7; i++) {
      final weekday = candidate.weekday;
      if (alarmModel.shouldRingOn(weekday)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }

    return null; // Should never happen if repeatDays is not empty
  }

  /// Reschedule all active alarms (e.g., after app restart)
  Future<void> rescheduleAllAlarms(List<AlarmModel> alarms) async {
    for (final alarm in alarms) {
      if (alarm.isEnabled) {
        await scheduleAlarm(alarm);
      }
    }
  }

  /// Stop all alarms
  Future<void> stopAll() async {
    await Alarm.stopAll();
  }
}
