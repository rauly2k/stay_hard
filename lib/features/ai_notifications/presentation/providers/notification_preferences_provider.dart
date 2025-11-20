import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/notification_preferences.dart';

/// Provider for notification preferences repository
final notificationPreferencesRepositoryProvider =
    Provider<NotificationPreferencesRepository>((ref) {
  return NotificationPreferencesRepositoryImpl();
});

/// Provider for user's notification preferences
final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesNotifier, AsyncValue<NotificationPreferences>>(
  (ref) {
    final repository = ref.watch(notificationPreferencesRepositoryProvider);
    return NotificationPreferencesNotifier(repository);
  },
);

/// Notifier for managing notification preferences state
class NotificationPreferencesNotifier
    extends StateNotifier<AsyncValue<NotificationPreferences>> {
  final NotificationPreferencesRepository _repository;

  NotificationPreferencesNotifier(this._repository)
      : super(const AsyncValue.loading()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      state = const AsyncValue.loading();
      final preferences = await _repository.getPreferences();
      state = AsyncValue.data(preferences);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updatePreferences(NotificationPreferences preferences) async {
    try {
      await _repository.savePreferences(preferences);
      state = AsyncValue.data(preferences);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  void refresh() {
    _loadPreferences();
  }
}

/// Repository interface for notification preferences
abstract class NotificationPreferencesRepository {
  Future<NotificationPreferences> getPreferences();
  Future<void> savePreferences(NotificationPreferences preferences);
}

/// Implementation of notification preferences repository
class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  // In a real implementation, this would use Firestore or Hive
  // For now, we'll use a simple in-memory cache
  NotificationPreferences? _cachedPreferences;

  @override
  Future<NotificationPreferences> getPreferences() async {
    // TODO: Implement actual persistence with Firestore/Hive
    // For now, return default preferences
    if (_cachedPreferences == null) {
      _cachedPreferences =
          NotificationPreferences.defaultPreferences('current-user-id');
    }
    return _cachedPreferences!;
  }

  @override
  Future<void> savePreferences(NotificationPreferences preferences) async {
    // TODO: Implement actual persistence with Firestore/Hive
    _cachedPreferences = preferences;
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
