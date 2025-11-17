import 'dart:async';
import 'package:flutter/services.dart';
import '../../data/repositories/app_time_limit_repository.dart';
import '../../../focus/domain/services/app_blocking_service.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Service for tracking app usage and enforcing time limits
class AppUsageTrackingService {
  static const MethodChannel _channel =
      MethodChannel('com.stayhard/app_blocking');

  final AppTimeLimitRepository _repository;
  final AppBlockingService _blockingService;

  Timer? _monitoringTimer;
  bool _isMonitoring = false;

  AppUsageTrackingService({
    required AppTimeLimitRepository repository,
    required AppBlockingService blockingService,
  })  : _repository = repository,
        _blockingService = blockingService;

  /// Start monitoring app usage and enforcing time limits
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;

    // Check every 30 seconds
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkAndEnforceTimeLimits(),
    );

    // Initial check
    await _checkAndEnforceTimeLimits();
  }

  /// Stop monitoring app usage
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _isMonitoring = false;
  }

  /// Check all apps with time limits and enforce blocking if exceeded
  Future<void> _checkAndEnforceTimeLimits() async {
    try {
      // Get all enabled time limits
      final limits = await _repository.getTimeLimits();
      final enabledLimits = limits.where((limit) => limit.isEnabled).toList();

      if (enabledLimits.isEmpty) return;

      // Get current usage from Android
      final usageMap = await getAllAppUsageToday();

      // List of apps that should be blocked
      final appsToBlock = <String>[];

      // Check each app with a limit
      for (final limit in enabledLimits) {
        final currentUsageSeconds = usageMap[limit.packageName] ?? 0;
        final currentUsage = Duration(seconds: currentUsageSeconds);

        // Update usage record in Firestore
        final record = await _repository.getTodayUsageRecord(limit.packageName);
        if (record.totalUsage != currentUsage) {
          await _repository.updateUsageRecord(record.id, currentUsage);
        }

        // Check if limit exceeded
        if (currentUsage >= limit.dailyLimit) {
          appsToBlock.add(limit.packageName);
        }
      }

      // Update blocked apps in the accessibility service
      if (appsToBlock.isNotEmpty) {
        await _blockingService.updateBlockedApps(appsToBlock);

        // Start a special "time limit" session if not already active
        final activeSessionId = await _blockingService.getActiveSessionId();
        if (activeSessionId == null) {
          await _blockingService.startFocusSession(
            sessionId: 'time_limit_session',
            blockedApps: appsToBlock,
            blockNotifications: false,
          );
        }
      }
    } catch (e) {
      print('Error checking time limits: $e');
    }
  }

  /// Get app usage for today for a specific package (in seconds)
  Future<int> getAppUsageToday(String packageName) async {
    try {
      final result = await _channel.invokeMethod<int>('getAppUsageToday', {
        'packageName': packageName,
      });
      return result ?? 0;
    } on PlatformException catch (e) {
      print('Error getting app usage: ${e.message}');
      return 0;
    }
  }

  /// Get all app usage for today (package name -> seconds)
  Future<Map<String, int>> getAllAppUsageToday() async {
    try {
      final result = await _channel.invokeMethod<Map>('getAllAppUsageToday');
      if (result == null) return {};

      // Convert to Map<String, int>
      return result.map((key, value) => MapEntry(
            key.toString(),
            (value as num).toInt(),
          ));
    } on PlatformException catch (e) {
      print('Error getting all app usage: ${e.message}');
      return {};
    }
  }

  /// Sync usage data from Android to Firestore
  Future<void> syncUsageData() async {
    try {
      final usageMap = await getAllAppUsageToday();
      final limits = await _repository.getTimeLimits();

      for (final limit in limits) {
        if (!limit.isEnabled) continue;

        final usageSeconds = usageMap[limit.packageName] ?? 0;
        final usage = Duration(seconds: usageSeconds);

        final record = await _repository.getTodayUsageRecord(limit.packageName);
        if (record.totalUsage != usage) {
          await _repository.updateUsageRecord(record.id, usage);
        }
      }
    } catch (e) {
      print('Error syncing usage data: $e');
    }
  }

  /// Get apps that are currently blocked due to time limits
  Future<List<String>> getBlockedAppsByTimeLimit() async {
    return await _repository.getBlockedAppsByTimeLimit();
  }

  /// Check if a specific app is blocked due to time limit
  Future<bool> isAppBlockedByTimeLimit(String packageName) async {
    return await _repository.hasExceededLimit(packageName);
  }

  /// Get remaining time for an app
  Future<Duration> getRemainingTime(String packageName) async {
    return await _repository.getRemainingTime(packageName);
  }

  /// Get usage statistics for an app
  Future<AppUsageStats> getAppUsageStats(String packageName) async {
    final limit = await _repository.getTimeLimitByPackage(packageName);
    final usageSeconds = await getAppUsageToday(packageName);
    final usage = Duration(seconds: usageSeconds);

    Duration remaining = Duration.zero;
    double percentage = 0.0;
    bool isBlocked = false;

    if (limit != null && limit.isEnabled) {
      remaining = limit.dailyLimit - usage;
      if (remaining.isNegative) remaining = Duration.zero;
      percentage = (usage.inSeconds / limit.dailyLimit.inSeconds * 100)
          .clamp(0.0, 100.0);
      isBlocked = usage >= limit.dailyLimit;
    }

    return AppUsageStats(
      packageName: packageName,
      appName: limit?.appName ?? packageName,
      currentUsage: usage,
      dailyLimit: limit?.dailyLimit,
      remainingTime: remaining,
      usagePercentage: percentage,
      isBlocked: isBlocked,
      hasLimit: limit != null && limit.isEnabled,
    );
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
  }
}

/// Model for app usage statistics
class AppUsageStats {
  final String packageName;
  final String appName;
  final Duration currentUsage;
  final Duration? dailyLimit;
  final Duration remainingTime;
  final double usagePercentage;
  final bool isBlocked;
  final bool hasLimit;

  const AppUsageStats({
    required this.packageName,
    required this.appName,
    required this.currentUsage,
    this.dailyLimit,
    required this.remainingTime,
    required this.usagePercentage,
    required this.isBlocked,
    required this.hasLimit,
  });

  String get currentUsageFormatted {
    final hours = currentUsage.inHours;
    final minutes = currentUsage.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get remainingTimeFormatted {
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get dailyLimitFormatted {
    if (dailyLimit == null) return 'No limit';
    final hours = dailyLimit!.inHours;
    final minutes = dailyLimit!.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
