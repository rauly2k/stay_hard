import 'package:cloud_firestore/cloud_firestore.dart';

/// Status of a focus session
enum FocusSessionStatus {
  scheduled,
  active,
  paused,
  completed,
  cancelled,
}

/// Preset focus mode types
enum FocusMode {
  deepWork,
  study,
  bedtime,
  minimalDistraction,
  custom,
}

/// Extension to get display names for focus modes
extension FocusModeExtension on FocusMode {
  String get displayName {
    switch (this) {
      case FocusMode.deepWork:
        return 'Deep Work';
      case FocusMode.study:
        return 'Study Session';
      case FocusMode.bedtime:
        return 'Bedtime';
      case FocusMode.minimalDistraction:
        return 'Minimal Distraction';
      case FocusMode.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case FocusMode.deepWork:
        return 'Block social media, messaging, games (25-60 min)';
      case FocusMode.study:
        return 'Block entertainment apps (30-120 min)';
      case FocusMode.bedtime:
        return 'Block all except emergency contacts';
      case FocusMode.minimalDistraction:
        return 'Block only specified apps';
      case FocusMode.custom:
        return 'User-defined blocking rules';
    }
  }

  int get defaultDurationMinutes {
    switch (this) {
      case FocusMode.deepWork:
        return 25;
      case FocusMode.study:
        return 30;
      case FocusMode.bedtime:
        return 480; // 8 hours
      case FocusMode.minimalDistraction:
        return 30;
      case FocusMode.custom:
        return 25;
    }
  }
}

/// Focus session model for distraction-free work
class FocusSession {
  final String id;
  final String userId;
  final String name;
  final Duration duration;
  final List<String> blockedApps; // Package names
  final bool blockNotifications;
  final String? linkedHabitId;
  final FocusSessionStatus status;
  final FocusMode mode;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  final int blockAttempts; // Number of times user tried to open blocked apps

  const FocusSession({
    required this.id,
    required this.userId,
    required this.name,
    required this.duration,
    required this.blockedApps,
    required this.blockNotifications,
    this.linkedHabitId,
    required this.status,
    required this.mode,
    this.startTime,
    this.endTime,
    required this.createdAt,
    this.blockAttempts = 0,
  });

  /// Calculate remaining time if session is active
  Duration? get remainingTime {
    if (status != FocusSessionStatus.active || startTime == null) {
      return null;
    }
    final elapsed = DateTime.now().difference(startTime!);
    final remaining = duration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if session is currently active
  bool get isActive => status == FocusSessionStatus.active;

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    if (startTime == null) return 0.0;
    final elapsed = DateTime.now().difference(startTime!);
    final progress = elapsed.inMilliseconds / duration.inMilliseconds;
    return progress.clamp(0.0, 1.0);
  }

  FocusSession copyWith({
    String? id,
    String? userId,
    String? name,
    Duration? duration,
    List<String>? blockedApps,
    bool? blockNotifications,
    String? linkedHabitId,
    FocusSessionStatus? status,
    FocusMode? mode,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    int? blockAttempts,
  }) {
    return FocusSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      blockedApps: blockedApps ?? this.blockedApps,
      blockNotifications: blockNotifications ?? this.blockNotifications,
      linkedHabitId: linkedHabitId ?? this.linkedHabitId,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      blockAttempts: blockAttempts ?? this.blockAttempts,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'duration': duration.inMinutes,
        'blockedApps': blockedApps,
        'blockNotifications': blockNotifications,
        'linkedHabitId': linkedHabitId,
        'status': status.name,
        'mode': mode.name,
        'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
        'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
        'createdAt': Timestamp.fromDate(createdAt),
        'blockAttempts': blockAttempts,
      };

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      duration: Duration(minutes: json['duration'] as int),
      blockedApps: (json['blockedApps'] as List<dynamic>).cast<String>(),
      blockNotifications: json['blockNotifications'] as bool? ?? false,
      linkedHabitId: json['linkedHabitId'] as String?,
      status: FocusSessionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FocusSessionStatus.scheduled,
      ),
      mode: FocusMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => FocusMode.custom,
      ),
      startTime: (json['startTime'] as Timestamp?)?.toDate(),
      endTime: (json['endTime'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      blockAttempts: json['blockAttempts'] as int? ?? 0,
    );
  }
}

/// Model for blocked app information
class BlockedApp {
  final String packageName;
  final String appName;
  final String? iconPath; // Cached icon path
  final int blockCount; // Number of times this app has been blocked
  final DateTime? lastBlocked;

  const BlockedApp({
    required this.packageName,
    required this.appName,
    this.iconPath,
    this.blockCount = 0,
    this.lastBlocked,
  });

  BlockedApp copyWith({
    String? packageName,
    String? appName,
    String? iconPath,
    int? blockCount,
    DateTime? lastBlocked,
  }) {
    return BlockedApp(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      iconPath: iconPath ?? this.iconPath,
      blockCount: blockCount ?? this.blockCount,
      lastBlocked: lastBlocked ?? this.lastBlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'appName': appName,
        'iconPath': iconPath,
        'blockCount': blockCount,
        'lastBlocked':
            lastBlocked != null ? Timestamp.fromDate(lastBlocked!) : null,
      };

  factory BlockedApp.fromJson(Map<String, dynamic> json) {
    return BlockedApp(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      iconPath: json['iconPath'] as String?,
      blockCount: json['blockCount'] as int? ?? 0,
      lastBlocked: (json['lastBlocked'] as Timestamp?)?.toDate(),
    );
  }
}

/// Model for installed app information
class InstalledAppInfo {
  final String packageName;
  final String name;
  final String? icon; // Base64 encoded icon or path

  const InstalledAppInfo({
    required this.packageName,
    required this.name,
    this.icon,
  });

  factory InstalledAppInfo.fromJson(Map<String, dynamic> json) {
    return InstalledAppInfo(
      packageName: json['packageName'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'name': name,
        'icon': icon,
      };
}

/// Focus statistics model
class FocusStatistics {
  final int totalSessions;
  final int completedSessions;
  final Duration totalFocusTime;
  final Duration averageSessionDuration;
  final int currentStreak; // Consecutive days with focus sessions
  final int longestStreak;
  final Map<String, int> mostBlockedApps; // packageName -> block count
  final DateTime? lastSessionDate;

  const FocusStatistics({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalFocusTime,
    required this.averageSessionDuration,
    required this.currentStreak,
    required this.longestStreak,
    required this.mostBlockedApps,
    this.lastSessionDate,
  });

  double get completionRate {
    if (totalSessions == 0) return 0.0;
    return completedSessions / totalSessions;
  }

  factory FocusStatistics.empty() {
    return const FocusStatistics(
      totalSessions: 0,
      completedSessions: 0,
      totalFocusTime: Duration.zero,
      averageSessionDuration: Duration.zero,
      currentStreak: 0,
      longestStreak: 0,
      mostBlockedApps: {},
    );
  }
}

/// Model for app time limit configuration
class AppTimeLimit {
  final String id;
  final String userId;
  final String packageName;
  final String appName;
  final Duration dailyLimit; // Maximum time allowed per day
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? lastModified;

  const AppTimeLimit({
    required this.id,
    required this.userId,
    required this.packageName,
    required this.appName,
    required this.dailyLimit,
    this.isEnabled = true,
    required this.createdAt,
    this.lastModified,
  });

  AppTimeLimit copyWith({
    String? id,
    String? userId,
    String? packageName,
    String? appName,
    Duration? dailyLimit,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return AppTimeLimit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'packageName': packageName,
        'appName': appName,
        'dailyLimitMinutes': dailyLimit.inMinutes,
        'isEnabled': isEnabled,
        'createdAt': Timestamp.fromDate(createdAt),
        'lastModified':
            lastModified != null ? Timestamp.fromDate(lastModified!) : null,
      };

  factory AppTimeLimit.fromJson(Map<String, dynamic> json) {
    return AppTimeLimit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      dailyLimit: Duration(minutes: json['dailyLimitMinutes'] as int),
      isEnabled: json['isEnabled'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastModified: (json['lastModified'] as Timestamp?)?.toDate(),
    );
  }
}

/// Model for tracking daily app usage
class AppUsageRecord {
  final String id;
  final String userId;
  final String packageName;
  final DateTime date; // Date of usage (normalized to start of day)
  final Duration totalUsage; // Total time used on this day
  final DateTime lastUpdated;

  const AppUsageRecord({
    required this.id,
    required this.userId,
    required this.packageName,
    required this.date,
    required this.totalUsage,
    required this.lastUpdated,
  });

  /// Check if this record is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  AppUsageRecord copyWith({
    String? id,
    String? userId,
    String? packageName,
    DateTime? date,
    Duration? totalUsage,
    DateTime? lastUpdated,
  }) {
    return AppUsageRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      packageName: packageName ?? this.packageName,
      date: date ?? this.date,
      totalUsage: totalUsage ?? this.totalUsage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'packageName': packageName,
        'date': Timestamp.fromDate(date),
        'totalUsageSeconds': totalUsage.inSeconds,
        'lastUpdated': Timestamp.fromDate(lastUpdated),
      };

  factory AppUsageRecord.fromJson(Map<String, dynamic> json) {
    return AppUsageRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      packageName: json['packageName'] as String,
      date: (json['date'] as Timestamp).toDate(),
      totalUsage: Duration(seconds: json['totalUsageSeconds'] as int),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }
}
