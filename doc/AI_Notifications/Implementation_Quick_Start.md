# AI Notification System - Implementation Quick Start Guide

**Version:** 1.0
**Created:** 2025-11-19
**Purpose:** Fast-track implementation guide with code scaffolding

---

## Quick Summary

This system delivers **intelligent, personality-matched motivational notifications** that:
- Pop up as full-screen overlays (black background, white text, big impact)
- Analyze user's habits, goals, and progress in real-time
- Generate personalized messages using Gemini AI
- Learn and adapt to each user's preferences
- Appear 1-2 seconds after homepage login for first-time setup

---

## Implementation Checklist

### ✅ Phase 0: Prerequisites (Before Starting)

- [ ] Gemini API key is configured and working
- [ ] Firebase Firestore is set up
- [ ] Hive database is initialized
- [ ] WorkManager package is added to `pubspec.yaml`
- [ ] User profile and habit systems are functional
- [ ] Homepage exists and is accessible after onboarding

---

### 🏗️ Phase 1: Foundation (Week 1)

#### 1.1 Create Data Models

**File:** `lib/features/ai_notifications/data/models/ai_notification_config.dart`

```dart
import 'package:hive/hive.dart';

part 'ai_notification_config.g.dart';

@HiveType(typeId: 10)
class AINotificationConfig {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final AIArchetype archetype;

  @HiveField(2)
  final AIIntensity intensity;

  @HiveField(3)
  final bool isEnabled;

  @HiveField(4)
  final DateTime onboardingCompletedAt;

  @HiveField(5)
  final List<int> preferredNotificationHours;

  @HiveField(6)
  final List<int> quietHours;

  AINotificationConfig({
    required this.userId,
    required this.archetype,
    required this.intensity,
    this.isEnabled = true,
    required this.onboardingCompletedAt,
    this.preferredNotificationHours = const [7, 13, 20],
    this.quietHours = const [22, 23, 0, 1, 2, 3, 4, 5, 6],
  });
}

@HiveType(typeId: 11)
enum AIArchetype {
  @HiveField(0)
  drillSergeant,

  @HiveField(1)
  wiseMentor,

  @HiveField(2)
  friendlyCoach,

  @HiveField(3)
  motivationalSpeaker,

  @HiveField(4)
  philosopher,

  @HiveField(5)
  humorousFriend,

  @HiveField(6)
  competitor,

  @HiveField(7)
  growthGuide,
}

@HiveType(typeId: 12)
enum AIIntensity {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}
```

**Run:** `flutter pub run build_runner build` to generate Hive adapters

---

#### 1.2 Create Repository Interface

**File:** `lib/features/ai_notifications/domain/repositories/ai_notification_repository.dart`

```dart
abstract class AINotificationRepository {
  Future<AINotificationConfig?> getConfig(String userId);
  Future<void> saveConfig(AINotificationConfig config);
  Future<void> updateConfig(String userId, {
    AIArchetype? archetype,
    AIIntensity? intensity,
    bool? isEnabled,
    List<int>? preferredHours,
    List<int>? quietHours,
  });
  Stream<AINotificationConfig?> watchConfig(String userId);
}
```

---

#### 1.3 Implement Repository

**File:** `lib/features/ai_notifications/data/repositories/ai_notification_repository_impl.dart`

```dart
class AINotificationRepositoryImpl implements AINotificationRepository {
  final Box<AINotificationConfig> hiveBox;
  final FirebaseFirestore firestore;

  AINotificationRepositoryImpl({
    required this.hiveBox,
    required this.firestore,
  });

  @override
  Future<AINotificationConfig?> getConfig(String userId) async {
    // Try Hive first
    var config = hiveBox.get(userId);
    if (config != null) return config;

    // Fallback to Firestore
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('aiNotificationConfig')
        .doc('config')
        .get();

    if (doc.exists) {
      config = AINotificationConfig.fromMap(doc.data()!);
      await hiveBox.put(userId, config); // Cache it
      return config;
    }

    return null;
  }

  @override
  Future<void> saveConfig(AINotificationConfig config) async {
    // Save to Hive
    await hiveBox.put(config.userId, config);

    // Save to Firestore
    await firestore
        .collection('users')
        .doc(config.userId)
        .collection('aiNotificationConfig')
        .doc('config')
        .set(config.toMap());
  }

  @override
  Stream<AINotificationConfig?> watchConfig(String userId) {
    return hiveBox.watch(key: userId).map((event) => event.value);
  }
}
```

---

#### 1.4 Create Riverpod Providers

**File:** `lib/features/ai_notifications/presentation/providers/ai_notification_providers.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_notification_providers.g.dart';

@riverpod
AINotificationRepository aiNotificationRepository(AiNotificationRepositoryRef ref) {
  final hiveBox = Hive.box<AINotificationConfig>('aiNotificationConfig');
  return AINotificationRepositoryImpl(
    hiveBox: hiveBox,
    firestore: FirebaseFirestore.instance,
  );
}

@riverpod
Stream<AINotificationConfig?> aiNotificationConfig(
  AiNotificationConfigRef ref,
  String userId,
) {
  final repository = ref.watch(aiNotificationRepositoryProvider);
  return repository.watchConfig(userId);
}
```

---

### 🎨 Phase 2: Onboarding UI (Week 1-2)

#### 2.1 Homepage Integration - First-Time Popup

**File:** `lib/features/habits/presentation/pages/homepage.dart`

```dart
class Homepage extends ConsumerStatefulWidget {
  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();
    _checkFirstTimeAISetup();
  }

  Future<void> _checkFirstTimeAISetup() async {
    // Wait 1.5 seconds for UI to settle
    await Future.delayed(Duration(milliseconds: 1500));

    final userId = ref.read(currentUserIdProvider);
    final config = await ref.read(aiNotificationRepositoryProvider).getConfig(userId);

    if (config == null) {
      // User hasn't set up AI notifications yet
      if (mounted) {
        _showAIOnboardingModal();
      }
    }
  }

  void _showAIOnboardingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AIOnboardingFlow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your existing homepage UI
    return Scaffold(...);
  }
}
```

---

#### 2.2 AI Onboarding Modal

**File:** `lib/features/ai_notifications/presentation/widgets/ai_onboarding_flow.dart`

```dart
class AIOnboardingFlow extends StatefulWidget {
  @override
  _AIOnboardingFlowState createState() => _AIOnboardingFlowState();
}

class _AIOnboardingFlowState extends State<AIOnboardingFlow> {
  int currentStep = 0;
  AIArchetype? selectedArchetype;
  AIIntensity selectedIntensity = AIIntensity.medium;

  final List<Widget> steps = [];

  @override
  void initState() {
    super.initState();
    steps = [
      _buildWelcomeScreen(),
      _buildHowItWorksScreen(),
      _buildArchetypeSelectionScreen(),
      _buildIntensitySelectionScreen(),
      _buildPermissionScreen(),
    ];
  }

  Widget _buildWelcomeScreen() {
    return AIOnboardingScreen(
      icon: '🤖',
      title: 'Meet Your Personal\nAccountability Partner',
      description: 'We\'ve built an AI system that sends you personalized '
          'motivational notifications to keep you on track with your habits and goals.',
      primaryButton: TextButton(
        child: Text('Next'),
        onPressed: () => setState(() => currentStep++),
      ),
    );
  }

  Widget _buildHowItWorksScreen() {
    return AIOnboardingScreen(
      stepIndicator: 'Step 2 of 4',
      icon: '📱',
      title: 'Smart, Not Annoying',
      description: 'Your AI analyzes:\n'
          '• Your daily habits & progress\n'
          '• Time of day and context\n'
          '• Your goals and deadlines\n'
          '• Your personality type\n\n'
          'Then sends timely messages when you need them most.',
      primaryButton: TextButton(
        child: Text('Next'),
        onPressed: () => setState(() => currentStep++),
      ),
      secondaryButton: TextButton(
        child: Text('Back'),
        onPressed: () => setState(() => currentStep--),
      ),
    );
  }

  Widget _buildArchetypeSelectionScreen() {
    return AIArchetypeSelector(
      onArchetypeSelected: (archetype) {
        setState(() => selectedArchetype = archetype);
      },
      onNext: () => setState(() => currentStep++),
      onBack: () => setState(() => currentStep--),
    );
  }

  Widget _buildIntensitySelectionScreen() {
    return AIIntensitySelector(
      initialIntensity: selectedIntensity,
      onIntensitySelected: (intensity) {
        setState(() => selectedIntensity = intensity);
      },
      onNext: () => setState(() => currentStep++),
      onBack: () => setState(() => currentStep--),
    );
  }

  Widget _buildPermissionScreen() {
    return AIPermissionScreen(
      onEnable: () async {
        await _saveConfigAndRequestPermission();
        Navigator.of(context).pop();
      },
      onSkip: () async {
        await _saveConfigWithoutPermission();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveConfigAndRequestPermission() async {
    final userId = ref.read(currentUserIdProvider);
    final config = AINotificationConfig(
      userId: userId,
      archetype: selectedArchetype!,
      intensity: selectedIntensity,
      isEnabled: true,
      onboardingCompletedAt: DateTime.now(),
    );

    await ref.read(aiNotificationRepositoryProvider).saveConfig(config);

    // Request OS notification permission
    await requestNotificationPermission();

    // Schedule notifications
    await ref.read(notificationSchedulerProvider).scheduleNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: steps[currentStep],
        ),
      ),
    );
  }
}
```

---

### 🤖 Phase 3: Message Generation (Week 2-3)

#### 3.1 Context Analyzer

**File:** `lib/features/ai_notifications/domain/services/notification_context_analyzer.dart`

```dart
class NotificationContextAnalyzer {
  final HabitRepository habitRepository;
  final GoalRepository goalRepository;
  final AnalyticsService analyticsService;

  Future<NotificationContext> analyzeContext({
    required String userId,
    required NotificationScenario scenario,
  }) async {
    final now = DateTime.now();

    // Gather all data in parallel
    final results = await Future.wait([
      habitRepository.getTodayHabits(userId),
      habitRepository.getCompletionStats(userId),
      goalRepository.getActiveGoals(userId),
      analyticsService.getStreakData(userId),
    ]);

    final todayHabits = results[0] as List<Habit>;
    final stats = results[1] as PerformanceMetrics;
    final goals = results[2] as List<Goal>;
    final streak = results[3] as StreakData;

    return NotificationContext(
      userId: userId,
      scenario: scenario,
      timestamp: now,
      todayHabits: todayHabits,
      completedCount: todayHabits.where((h) => h.isCompletedToday).length,
      pendingHabits: todayHabits.where((h) => !h.isCompletedToday).toList(),
      activeGoals: goals,
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      completionRate7Days: stats.completionRate7Days,
      timeOfDay: _determineTimeOfDay(now),
    );
  }

  String _determineTimeOfDay(DateTime time) {
    if (time.hour >= 5 && time.hour < 12) return 'morning';
    if (time.hour >= 12 && time.hour < 17) return 'afternoon';
    if (time.hour >= 17 && time.hour < 22) return 'evening';
    return 'night';
  }
}
```

---

#### 3.2 Gemini API Message Generator

**File:** `lib/features/ai_notifications/domain/services/ai_message_generator.dart`

```dart
class AIMessageGenerator {
  final GeminiAPIService geminiAPI;
  final MessageCacheService cache;

  Future<String> generateMessage({
    required NotificationContext context,
    required AIArchetype archetype,
    required AIIntensity intensity,
  }) async {
    // Check cache first
    final cachedMessage = await cache.findSimilar(context, archetype);
    if (cachedMessage != null) return cachedMessage;

    // Build prompt
    final prompt = _buildPrompt(context, archetype, intensity);

    try {
      // Call Gemini API
      final response = await geminiAPI.generateContent(prompt);
      final message = _parseResponse(response);

      // Cache the message
      await cache.store(context, archetype, message);

      return message;
    } catch (e) {
      // Fallback to pre-generated message
      return _getFallbackMessage(context, archetype);
    }
  }

  String _buildPrompt(
    NotificationContext context,
    AIArchetype archetype,
    AIIntensity intensity,
  ) {
    final archetypePrompt = _getArchetypePrompt(archetype);
    final intensityDesc = _getIntensityDescription(intensity);

    return '''
System Role: $archetypePrompt

User Context:
- Total habits today: ${context.todayHabits.length}
- Completed: ${context.completedCount}
- Pending habits: ${context.pendingHabits.map((h) => h.name).join(", ")}
- Current streak: ${context.currentStreak} days
- Time of day: ${context.timeOfDay}
- Scenario: ${context.scenario.description}

Instruction:
Generate a $intensityDesc motivational message in the archetype's voice.
${_getScenarioGuidance(context.scenario)}
Keep under 60 words.
Use 1 relevant emoji at the end.
Be authentic to the archetype's personality.

Message:
''';
  }

  String _getArchetypePrompt(AIArchetype archetype) {
    switch (archetype) {
      case AIArchetype.drillSergeant:
        return 'You are a tough, commanding drill sergeant. Use military terminology, '
            'short punchy commands, and high energy. Call the user "soldier" or "recruit". '
            'Zero tolerance for excuses. Tough love approach.';

      case AIArchetype.wiseMentor:
        return 'You are a wise, calm mentor inspired by Stoic philosophy. '
            'Use philosophical insights, ask reflective questions, and provide deep guidance. '
            'Reference ancient wisdom when appropriate. Patient and understanding tone.';

      case AIArchetype.friendlyCoach:
        return 'You are a supportive, enthusiastic coach. Use "we" language, '
            'celebrate every win, provide lots of encouragement. Warm, empathetic, '
            'and genuinely excited about the user\'s progress. Like a best friend who believes in you.';

      case AIArchetype.motivationalSpeaker:
        return 'You are a high-energy motivational speaker (Tony Robbins style). '
            'Use ALL CAPS for emphasis, exclamation points, dramatic language. '
            'Call to greatness and vision. Inspirational and passionate.';

      case AIArchetype.philosopher:
        return 'You are a thoughtful philosopher. Ask profound questions, '
            'explore meaning and purpose, reference great thinkers (Nietzsche, Plato, Kierkegaard). '
            'Deep, contemplative, intellectual depth.';

      case AIArchetype.humorousFriend:
        return 'You are a funny, light-hearted friend. Use humor, pop culture references, '
            'puns, and playful teasing. Make the user smile while motivating them. '
            'Keep it fun and relatable.';

      case AIArchetype.competitor:
        return 'You are a competitive sports coach. Use sports metaphors, '
            'scoreboard language, performance metrics. Frame everything as wins/losses. '
            'Championship mentality. Results-driven.';

      case AIArchetype.growthGuide:
        return 'You are a nurturing growth guide focused on process over outcome. '
            'Use growth mindset language, celebrate learning from failures, '
            'emphasize long-term transformation. Patient and developmental.';
    }
  }

  String _getScenarioGuidance(NotificationScenario scenario) {
    switch (scenario) {
      case NotificationScenario.morningMotivation:
        return 'Focus on energizing the user to start their day strong. '
            'Mention their pending morning habits if relevant.';

      case NotificationScenario.middayCheckIn:
        return 'Provide a progress update. If behind, gently push. '
            'If ahead, celebrate and encourage them to finish strong.';

      case NotificationScenario.eveningReflection:
        return 'Reflect on the day. If all complete, celebrate. '
            'If incomplete, encourage finishing remaining habits before bed.';

      case NotificationScenario.streakMilestone:
        return 'Celebrate this major achievement! Make it feel special. '
            'Challenge them to reach the next milestone.';

      case NotificationScenario.streakRecovery:
        return 'Empathetic and encouraging. Reframe the broken streak as learning. '
            'Highlight their longest streak as proof of capability.';

      default:
        return 'Provide contextually relevant motivation.';
    }
  }
}
```

---

### ⏰ Phase 4: Notification Scheduling (Week 3-4)

#### 4.1 WorkManager Setup

**File:** `lib/core/services/work_manager_service.dart`

```dart
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'sendAINotification':
        await _handleNotificationTask(inputData);
        break;
    }
    return Future.value(true);
  });
}

Future<void> _handleNotificationTask(Map<String, dynamic>? inputData) async {
  if (inputData == null) return;

  final userId = inputData['userId'] as String;
  final scenarioString = inputData['scenario'] as String;
  final scenario = NotificationScenario.values.firstWhere(
    (e) => e.toString() == scenarioString,
  );

  // Initialize dependencies (use GetIt or similar)
  final analyzer = getIt<NotificationContextAnalyzer>();
  final generator = getIt<AIMessageGenerator>();
  final delivery = getIt<NotificationDeliveryService>();
  final configRepo = getIt<AINotificationRepository>();

  // Get user config
  final config = await configRepo.getConfig(userId);
  if (config == null || !config.isEnabled) return;

  // Analyze context
  final context = await analyzer.analyzeContext(
    userId: userId,
    scenario: scenario,
  );

  // Check if should send
  if (!_shouldSendNotification(context, config)) return;

  // Generate message
  final message = await generator.generateMessage(
    context: context,
    archetype: config.archetype,
    intensity: config.intensity,
  );

  // Send notification
  await delivery.sendOverlayNotification(
    userId: userId,
    message: message,
    archetype: config.archetype,
    context: context,
  );
}

bool _shouldSendNotification(
  NotificationContext context,
  AINotificationConfig config,
) {
  final now = DateTime.now();

  // Check quiet hours
  if (config.quietHours.contains(now.hour)) return false;

  // Check notification fatigue (simplified)
  // In production, check engagement metrics from last 7 days
  // If user dismisses notifications quickly, reduce frequency

  // Scenario-specific logic
  if (context.scenario == NotificationScenario.morningMotivation) {
    // Only send if no habits completed yet
    return context.completedCount == 0;
  }

  if (context.scenario == NotificationScenario.urgentAccountability) {
    // Only send if streak at risk (evening, 0 habits completed)
    return context.completedCount == 0 && now.hour >= 20;
  }

  return true; // Default: send
}
```

---

#### 4.2 Notification Scheduler

**File:** `lib/features/ai_notifications/domain/services/notification_scheduler.dart`

```dart
class NotificationScheduler {
  final Workmanager workManager;

  Future<void> scheduleNotifications(String userId) async {
    final config = await getIt<AINotificationRepository>().getConfig(userId);
    if (config == null) return;

    // Cancel existing scheduled tasks
    await workManager.cancelByUniqueName('ai_notification_$userId');

    if (!config.isEnabled) return;

    // Schedule based on intensity
    final times = _getNotificationTimes(config.intensity);

    for (int i = 0; i < times.length; i++) {
      final time = times[i];
      final scenario = _scenarioForTime(time);

      await workManager.registerPeriodicTask(
        'ai_notification_${userId}_$i',
        'sendAINotification',
        frequency: Duration(days: 1),
        initialDelay: _calculateDelay(time),
        inputData: {
          'userId': userId,
          'scenario': scenario.toString(),
        },
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    }
  }

  List<TimeOfDay> _getNotificationTimes(AIIntensity intensity) {
    switch (intensity) {
      case AIIntensity.low:
        return [TimeOfDay(hour: 8, minute: 0)]; // Morning only

      case AIIntensity.medium:
        return [
          TimeOfDay(hour: 8, minute: 0),   // Morning
          TimeOfDay(hour: 13, minute: 0),  // Midday
          TimeOfDay(hour: 20, minute: 0),  // Evening
        ];

      case AIIntensity.high:
        return [
          TimeOfDay(hour: 7, minute: 30),
          TimeOfDay(hour: 12, minute: 0),
          TimeOfDay(hour: 16, minute: 0),
          TimeOfDay(hour: 20, minute: 0),
          TimeOfDay(hour: 21, minute: 30),
        ];
    }
  }

  Duration _calculateDelay(TimeOfDay targetTime) {
    final now = DateTime.now();
    var target = DateTime(
      now.year,
      now.month,
      now.day,
      targetTime.hour,
      targetTime.minute,
    );

    if (target.isBefore(now)) {
      target = target.add(Duration(days: 1));
    }

    return target.difference(now);
  }
}
```

---

### 📱 Phase 5: Overlay UI (Week 4)

#### 5.1 Full-Screen Notification Overlay

**File:** `lib/features/ai_notifications/presentation/widgets/ai_notification_overlay.dart`

```dart
class AINotificationOverlay extends StatefulWidget {
  final String message;
  final AIArchetype archetype;

  @override
  _AINotificationOverlayState createState() => _AINotificationOverlayState();
}

class _AINotificationOverlayState extends State<AINotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    // Auto-dismiss after 60 seconds
    Future.delayed(Duration(seconds: 60), () {
      if (mounted) _dismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    Navigator.of(context).pop();
    _recordDismissal();
  }

  void _viewHabits() {
    Navigator.of(context).pop();
    _recordAction(NotificationAction.viewedHabits);
    // Navigate to habits page
    Navigator.of(context).pushNamed('/habits');
  }

  void _recordDismissal() {
    // Record in analytics that user dismissed without action
    getIt<NotificationAnalyticsService>().recordDismissal();
  }

  void _recordAction(NotificationAction action) {
    getIt<NotificationAnalyticsService>().recordAction(action);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Material(
        color: Colors.black.withOpacity(0.95),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 500) {
                  _dismiss(); // Swipe down to dismiss
                }
              },
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Archetype Icon
                        _buildArchetypeIcon(),

                        SizedBox(height: 40),

                        // Message Text
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 60),

                        // Primary Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _viewHabits,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'View My Habits',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Dismiss Button
                        TextButton(
                          onPressed: _dismiss,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: Text(
                            'Dismiss',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArchetypeIcon() {
    String emoji;
    switch (widget.archetype) {
      case AIArchetype.drillSergeant:
        emoji = '💪';
        break;
      case AIArchetype.wiseMentor:
        emoji = '🧘';
        break;
      case AIArchetype.friendlyCoach:
        emoji = '🎯';
        break;
      case AIArchetype.motivationalSpeaker:
        emoji = '🔥';
        break;
      case AIArchetype.philosopher:
        emoji = '🤔';
        break;
      case AIArchetype.humorousFriend:
        emoji = '😄';
        break;
      case AIArchetype.competitor:
        emoji = '🏆';
        break;
      case AIArchetype.growthGuide:
        emoji = '🌱';
        break;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Text(
            emoji,
            style: TextStyle(fontSize: 80),
          ),
        );
      },
    );
  }
}
```

---

### 🚀 Phase 6: Testing & Launch

#### Integration Test Example

**File:** `integration_test/ai_notification_test.dart`

```dart
void main() {
  group('AI Notification System Integration Tests', () {
    testWidgets('User completes AI onboarding flow', (tester) async {
      // 1. Launch app
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // 2. Navigate to homepage (assume user is logged in)
      // Wait for AI onboarding modal to appear
      await tester.pump(Duration(seconds: 2));

      // 3. Verify modal appeared
      expect(find.text('Meet Your Personal'), findsOneWidget);

      // 4. Tap "Next" through welcome screens
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // 5. Select archetype (Friendly Coach)
      await tester.tap(find.text('FRIENDLY COACH'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // 6. Select intensity (Medium)
      await tester.tap(find.byType(Slider));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // 7. Enable notifications
      await tester.tap(find.text('Enable Notifications'));
      await tester.pumpAndSettle();

      // 8. Verify config was saved
      final config = await getIt<AINotificationRepository>()
          .getConfig('test_user');

      expect(config, isNotNull);
      expect(config!.archetype, AIArchetype.friendlyCoach);
      expect(config.intensity, AIIntensity.medium);
      expect(config.isEnabled, isTrue);
    });

    testWidgets('AI notification overlay appears and is dismissible', (tester) async {
      // Trigger a notification overlay
      await showNotificationOverlay(
        message: "Test message from Drill Sergeant!",
        archetype: AIArchetype.drillSergeant,
      );

      await tester.pumpAndSettle();

      // Verify overlay appeared
      expect(find.text('Test message from Drill Sergeant!'), findsOneWidget);
      expect(find.text('View My Habits'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);

      // Tap dismiss
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      // Verify overlay closed
      expect(find.text('Test message from Drill Sergeant!'), findsNothing);
    });
  });
}
```

---

## 📋 Final Checklist Before Launch

- [ ] All 8 archetypes have sample messages tested
- [ ] Gemini API integration works with error handling
- [ ] Notification scheduling works across app restarts
- [ ] Overlay UI renders correctly on different screen sizes
- [ ] User can configure AI personality and intensity
- [ ] Quiet hours are respected
- [ ] Notification history is tracked
- [ ] Analytics show engagement metrics
- [ ] Battery usage is acceptable (< 5% per day)
- [ ] No crashes during 48-hour test period
- [ ] Beta users provide feedback (satisfaction ≥ 4/5)

---

## 🎯 Success Metrics to Track

After launch, monitor these metrics weekly:

1. **Adoption Rate:** % of users who complete AI onboarding
2. **Engagement Rate:** % of notifications that are opened/acted upon
3. **Retention Impact:** 30-day retention comparison (AI users vs non-AI users)
4. **Habit Completion Impact:** Average completion rate increase for AI users
5. **User Satisfaction:** In-app rating of AI notifications (1-5 scale)

**Target Goals:**
- Adoption: ≥ 70%
- Engagement: ≥ 60%
- Retention lift: +15%
- Completion rate lift: +20%
- Satisfaction: ≥ 4.2/5

---

## 🔧 Troubleshooting Common Issues

### Issue: Notifications not appearing

**Check:**
- [ ] OS notification permission granted
- [ ] WorkManager tasks are scheduled (`adb shell dumpsys activity service WorkManagerService`)
- [ ] User's `isEnabled` config is `true`
- [ ] Current time is not in quiet hours
- [ ] Background restrictions disabled for app

### Issue: Gemini API calls failing

**Check:**
- [ ] API key is correct and active
- [ ] Internet connection available
- [ ] API quota not exceeded
- [ ] Fallback messages work as backup

### Issue: Overlay not dismissing

**Check:**
- [ ] Back button handler is implemented
- [ ] Swipe gesture detector is active
- [ ] Auto-dismiss timer (60s) is working

---

## 📚 Additional Resources

- Main Specification: `AI_Notification_System_Specification.md`
- Gemini API Docs: https://ai.google.dev/docs
- WorkManager Guide: https://pub.dev/packages/workmanager
- Flutter Local Notifications: https://pub.dev/packages/flutter_local_notifications

---

**Ready to implement? Start with Phase 1 and work sequentially!**

*Last Updated: 2025-11-19*
