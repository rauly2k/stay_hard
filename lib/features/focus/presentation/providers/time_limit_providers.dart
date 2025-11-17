import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/app_time_limit_repository.dart';
import '../../domain/services/app_usage_tracking_service.dart';
import '../../domain/services/app_blocking_service.dart';
import '../providers/focus_providers.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Provider for App Time Limit Repository
final appTimeLimitRepositoryProvider = Provider<AppTimeLimitRepository>((ref) {
  return AppTimeLimitRepository();
});

/// Provider for App Usage Tracking Service
final appUsageTrackingServiceProvider =
    Provider<AppUsageTrackingService>((ref) {
  final repository = ref.watch(appTimeLimitRepositoryProvider);
  final blockingService = ref.watch(appBlockingServiceProvider);

  final service = AppUsageTrackingService(
    repository: repository,
    blockingService: blockingService,
  );

  // Start monitoring when service is created
  service.startMonitoring();

  // Stop monitoring when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider for all app time limits
final appTimeLimitsProvider = StreamProvider<List<AppTimeLimit>>((ref) {
  final repository = ref.watch(appTimeLimitRepositoryProvider);
  return repository.watchTimeLimits();
});

/// Provider for enabled app time limits only
final enabledAppTimeLimitsProvider = StreamProvider<List<AppTimeLimit>>((ref) {
  final repository = ref.watch(appTimeLimitRepositoryProvider);
  return repository.watchEnabledTimeLimits();
});

/// Provider for apps blocked by time limits
final blockedAppsByTimeLimitProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(appUsageTrackingServiceProvider);
  return service.getBlockedAppsByTimeLimit();
});

/// Provider for current user ID
final userIdProvider = Provider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

/// State notifier for time limit management
class TimeLimitNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  AppTimeLimitRepository get _repository =>
      ref.read(appTimeLimitRepositoryProvider);
  AppUsageTrackingService get _service =>
      ref.read(appUsageTrackingServiceProvider);

  /// Create a new time limit
  Future<void> createTimeLimit(AppTimeLimit limit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createTimeLimit(limit);
      // Sync usage data after creating limit
      await _service.syncUsageData();
    });
  }

  /// Update an existing time limit
  Future<void> updateTimeLimit(AppTimeLimit limit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateTimeLimit(limit);
      // Sync usage data after updating limit
      await _service.syncUsageData();
    });
  }

  /// Delete a time limit
  Future<void> deleteTimeLimit(String limitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTimeLimit(limitId);
    });
  }

  /// Sync all usage data from Android
  Future<void> syncUsageData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.syncUsageData();
    });
  }

  /// Clean up old usage records
  Future<void> cleanupOldRecords() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.cleanupOldRecords();
    });
  }
}

/// Provider for time limit notifier
final timeLimitNotifierProvider =
    NotifierProvider<TimeLimitNotifier, AsyncValue<void>>(
  TimeLimitNotifier.new,
);

/// Provider for a specific app's usage stats
Provider<AsyncValue<AppUsageStats>> appUsageStatsProvider(String packageName) {
  return FutureProvider<AppUsageStats>((ref) async {
    final service = ref.watch(appUsageTrackingServiceProvider);
    return service.getAppUsageStats(packageName);
  });
}
