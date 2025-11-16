import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Dismissal method types for alarms
enum DismissalMethod {
  classic,
  math,
  textTyping,
  customText,
}

/// Difficulty level for math and typing challenges
enum ChallengeDifficulty {
  easy,
  medium,
  hard,
}

/// Alarm sound options
class AlarmSound {
  final String id;
  final String name;
  final String assetPath;

  const AlarmSound({
    required this.id,
    required this.name,
    required this.assetPath,
  });

  static const List<AlarmSound> defaults = [
    AlarmSound(id: 'radar', name: 'Radar', assetPath: 'assets/audio/radar.mp3'),
    AlarmSound(id: 'apex', name: 'Apex', assetPath: 'assets/audio/apex.mp3'),
    AlarmSound(id: 'ascend', name: 'Ascend', assetPath: 'assets/audio/ascend.mp3'),
  ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assetPath': assetPath,
      };

  factory AlarmSound.fromJson(Map<String, dynamic> json) {
    return AlarmSound(
      id: json['id'] as String,
      name: json['name'] as String,
      assetPath: json['assetPath'] as String,
    );
  }
}

/// User's alarm instance
class AlarmModel {
  final String id;
  final String userId;
  final TimeOfDay time;
  final String label;
  final List<int> repeatDays; // 1-7 for Mon-Sun (1=Monday, 7=Sunday)
  final bool isEnabled;
  final DismissalMethod dismissalMethod;
  final ChallengeDifficulty? challengeDifficulty; // For math/typing challenges
  final String? customText; // For custom text challenge
  final AlarmSound sound;
  final bool vibrate;
  final DateTime createdAt;

  const AlarmModel({
    required this.id,
    required this.userId,
    required this.time,
    required this.label,
    required this.repeatDays,
    required this.isEnabled,
    required this.dismissalMethod,
    this.challengeDifficulty,
    this.customText,
    required this.sound,
    required this.vibrate,
    required this.createdAt,
  });

  AlarmModel copyWith({
    String? id,
    String? userId,
    TimeOfDay? time,
    String? label,
    List<int>? repeatDays,
    bool? isEnabled,
    DismissalMethod? dismissalMethod,
    ChallengeDifficulty? challengeDifficulty,
    String? customText,
    AlarmSound? sound,
    bool? vibrate,
    DateTime? createdAt,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      label: label ?? this.label,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      dismissalMethod: dismissalMethod ?? this.dismissalMethod,
      challengeDifficulty: challengeDifficulty ?? this.challengeDifficulty,
      customText: customText ?? this.customText,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'time': {
          'hour': time.hour,
          'minute': time.minute,
        },
        'label': label,
        'repeatDays': repeatDays,
        'isEnabled': isEnabled,
        'dismissalMethod': dismissalMethod.name,
        'challengeDifficulty': challengeDifficulty?.name,
        'customText': customText,
        'sound': sound.toJson(),
        'vibrate': vibrate,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    final timeData = json['time'] as Map<String, dynamic>;
    return AlarmModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      time: TimeOfDay(
        hour: timeData['hour'] as int,
        minute: timeData['minute'] as int,
      ),
      label: json['label'] as String? ?? 'Alarm',
      repeatDays: (json['repeatDays'] as List<dynamic>?)?.cast<int>() ?? [],
      isEnabled: json['isEnabled'] as bool? ?? true,
      dismissalMethod: DismissalMethod.values.firstWhere(
        (e) => e.name == (json['dismissalMethod'] as String?),
        orElse: () => DismissalMethod.classic,
      ),
      challengeDifficulty: json['challengeDifficulty'] != null
          ? ChallengeDifficulty.values.firstWhere(
              (e) => e.name == json['challengeDifficulty'],
              orElse: () => ChallengeDifficulty.medium,
            )
          : null,
      customText: json['customText'] as String?,
      sound: json['sound'] != null
          ? AlarmSound.fromJson(json['sound'] as Map<String, dynamic>)
          : AlarmSound.defaults.first,
      vibrate: json['vibrate'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Get formatted time string (e.g., "06:30")
  String getFormattedTime() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get repeat days description (e.g., "Weekdays", "Mon, Wed, Fri", "Once")
  String getRepeatDescription() {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Every day';
    if (repeatDays.length == 5 &&
        repeatDays.containsAll([1, 2, 3, 4, 5])) {
      return 'Weekdays';
    }
    if (repeatDays.length == 2 && repeatDays.containsAll([6, 7])) {
      return 'Weekends';
    }

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return repeatDays.map((day) => days[day - 1]).join(', ');
  }

  /// Check if alarm should ring on a specific day
  bool shouldRingOn(int weekday) {
    if (repeatDays.isEmpty) return false; // Once alarms handled separately
    return repeatDays.contains(weekday);
  }
}

extension ListIntExtension on List<int> {
  bool containsAll(List<int> other) {
    return other.every((element) => contains(element));
  }
}
