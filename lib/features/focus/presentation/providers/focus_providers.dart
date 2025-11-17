import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositories/focus_repository.dart';
import '../../domain/services/app_blocking_service.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Provider for Focus Repository
final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  return FocusRepository();
});

/// Provider for App Blocking Service
final appBlockingServiceProvider = Provider<AppBlockingService>((ref) {
  return AppBlockingService();
});

/// Provider for all focus sessions
final focusSessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.watchSessions();
});

/// Provider for active focus session
final activeFocusSessionProvider = StreamProvider<FocusSession?>((ref) {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.watchActiveSession();
});

/// Provider for focus statistics
final focusStatisticsProvider = FutureProvider<FocusStatistics>((ref) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getStatistics();
});

/// Provider for installed apps
final installedAppsProvider = FutureProvider<List<InstalledAppInfo>>((ref) async {
  final service = ref.watch(appBlockingServiceProvider);
  return service.getInstalledApps();
});

/// Provider for accessibility service status
final accessibilityServiceEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(appBlockingServiceProvider);
  return service.isAccessibilityServiceEnabled();
});

/// Provider for usage stats permission status
final usageStatsPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(appBlockingServiceProvider);
  return service.hasUsageStatsPermission();
});

/// State notifier for focus session management
class FocusSessionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  FocusRepository get _repository => ref.read(focusRepositoryProvider);
  AppBlockingService get _appBlockingService => ref.read(appBlockingServiceProvider);

  /// Create a new focus session
  Future<void> createSession(FocusSession session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createSession(session);
    });
  }

  /// Start a focus session
  Future<void> startSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Get session details
      final session = await _repository.getSession(sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      // Start in repository (updates status to active)
      await _repository.startSession(sessionId);

      // Start app blocking service
      final success = await _appBlockingService.startFocusSession(
        sessionId: sessionId,
        blockedApps: session.blockedApps,
        blockNotifications: session.blockNotifications,
      );

      if (!success) {
        throw Exception('Failed to start app blocking service');
      }
    });
  }

  /// Pause a focus session
  Future<void> pauseSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.pauseSession(sessionId);
      await _appBlockingService.stopFocusSession();
    });
  }

  /// Resume a focus session
  Future<void> resumeSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final session = await _repository.getSession(sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      await _repository.resumeSession(sessionId);

      final success = await _appBlockingService.startFocusSession(
        sessionId: sessionId,
        blockedApps: session.blockedApps,
        blockNotifications: session.blockNotifications,
      );

      if (!success) {
        throw Exception('Failed to resume app blocking service');
      }
    });
  }

  /// Complete a focus session
  Future<void> completeSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.completeSession(sessionId);
      await _appBlockingService.stopFocusSession();
    });
  }

  /// Cancel a focus session
  Future<void> cancelSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.cancelSession(sessionId);
      await _appBlockingService.stopFocusSession();
    });
  }

  /// Update a focus session
  Future<void> updateSession(FocusSession session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateSession(session);

      // If session is active, update blocked apps in service
      if (session.isActive) {
        await _appBlockingService.updateBlockedApps(session.blockedApps);
      }
    });
  }

  /// Delete a focus session
  Future<void> deleteSession(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteSession(sessionId);
    });
  }
}

/// Provider for focus session notifier
final focusSessionNotifierProvider =
    NotifierProvider<FocusSessionNotifier, AsyncValue<void>>(
  FocusSessionNotifier.new,
);

/// Provider for selected blocked apps (for UI state)
final selectedBlockedAppsProvider =
    StateProvider<List<String>>((ref) => []);

/// Provider for selected focus mode (for UI state)
final selectedFocusModeProvider =
    StateProvider<FocusMode>((ref) => FocusMode.custom);

/// Provider for session duration (for UI state)
final sessionDurationProvider =
    StateProvider<Duration>((ref) => const Duration(minutes: 25));

/// Provider for session name (for UI state)
final sessionNameProvider = StateProvider<String>((ref) => '');

/// Provider for linked habit ID (for UI state)
final linkedHabitIdProvider = StateProvider<String?>((ref) => null);

/// Provider for block notifications toggle (for UI state)
final blockNotificationsProvider = StateProvider<bool>((ref) => false);
