import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/ai_notification_config.dart';
import '../../data/repositories/ai_notification_repository_impl.dart';
import '../../domain/repositories/ai_notification_repository.dart';

/// Provider for AI Notification Repository
final aiNotificationRepositoryProvider = Provider<AINotificationRepository>((ref) {
  final configBox = Hive.box<AINotificationConfig>('aiNotificationConfig');
  return AINotificationRepositoryImpl(
    configBox: configBox,
    firestore: FirebaseFirestore.instance,
  );
});

/// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});

/// Provider for AI Notification Config (Stream)
final aiNotificationConfigProvider = StreamProvider.family<AINotificationConfig?, String>(
  (ref, userId) {
    final repository = ref.watch(aiNotificationRepositoryProvider);
    return repository.watchConfig(userId);
  },
);

/// Provider for current user's AI Notification Config
final currentUserAIConfigProvider = StreamProvider<AINotificationConfig?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.watch(aiNotificationConfigProvider(userId).stream);
});

/// Provider for checking if user has completed AI onboarding
final hasCompletedAIOnboardingProvider = FutureProvider<bool>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return false;

  final repository = ref.watch(aiNotificationRepositoryProvider);
  final config = await repository.getConfig(userId);
  return config != null;
});

/// Provider for notification history
final notificationHistoryProvider =
    FutureProvider.family<List<AINotificationRecord>, String>(
  (ref, userId) async {
    final repository = ref.watch(aiNotificationRepositoryProvider);
    return repository.getNotificationHistory(userId);
  },
);

/// Provider for notification statistics
final notificationStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
  (ref, userId) async {
    final repository = ref.watch(aiNotificationRepositoryProvider);
    return repository.getNotificationStats(userId);
  },
);

/// State notifier for managing AI notification configuration
class AINotificationConfigNotifier extends StateNotifier<AsyncValue<AINotificationConfig?>> {
  final AINotificationRepository _repository;
  final String userId;

  AINotificationConfigNotifier({
    required AINotificationRepository repository,
    required this.userId,
  })  : _repository = repository,
        super(const AsyncValue.loading()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    state = const AsyncValue.loading();
    try {
      final config = await _repository.getConfig(userId);
      state = AsyncValue.data(config);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveConfig(AINotificationConfig config) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveConfig(config);
      state = AsyncValue.data(config);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateArchetype(AIArchetype archetype) async {
    try {
      await _repository.updateConfig(userId, archetype: archetype);
      await _loadConfig();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateIntensity(AIIntensity intensity) async {
    try {
      await _repository.updateConfig(userId, intensity: intensity);
      await _loadConfig();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleEnabled() async {
    try {
      final currentConfig = state.value;
      if (currentConfig != null) {
        await _repository.updateConfig(
          userId,
          isEnabled: !currentConfig.isEnabled,
        );
        await _loadConfig();
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateQuietHours(List<int> quietHours) async {
    try {
      await _repository.updateConfig(userId, quietHours: quietHours);
      await _loadConfig();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferredHours(List<int> preferredHours) async {
    try {
      await _repository.updateConfig(userId, preferredHours: preferredHours);
      await _loadConfig();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for AI notification config notifier
final aiNotificationConfigNotifierProvider = StateNotifierProvider.family<
    AINotificationConfigNotifier,
    AsyncValue<AINotificationConfig?>,
    String>(
  (ref, userId) {
    final repository = ref.watch(aiNotificationRepositoryProvider);
    return AINotificationConfigNotifier(
      repository: repository,
      userId: userId,
    );
  },
);
