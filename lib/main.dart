import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/alarms/presentation/pages/alarm_challenge_screen.dart';
import 'features/alarms/presentation/pages/alarm_edit_screen.dart';
import 'features/alarms/presentation/providers/alarm_providers.dart';
import 'features/auth/presentation/pages/auth_gate_screen.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/onboarding/presentation/pages/info_slides_screen.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/user_profile_completion/presentation/pages/onboarding_router.dart';
import 'features/ai_notifications/data/models/ai_notification_config.dart';
import 'shared/data/models/alarm_model.dart';
import 'shared/presentation/widgets/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters for AI Notifications
  Hive.registerAdapter(AIArchetypeAdapter());
  Hive.registerAdapter(AIIntensityAdapter());
  Hive.registerAdapter(NotificationScenarioAdapter());
  Hive.registerAdapter(NotificationActionAdapter());
  Hive.registerAdapter(AINotificationConfigAdapter());
  Hive.registerAdapter(AINotificationRecordAdapter());

  // Open Hive boxes
  await Hive.openBox<AINotificationConfig>('aiNotificationConfig');

  // Initialize Alarm package
  await Alarm.init();

  runApp(
    const ProviderScope(
      child: StayHardApp(),
    ),
  );
}

class StayHardApp extends ConsumerStatefulWidget {
  const StayHardApp({super.key});

  @override
  ConsumerState<StayHardApp> createState() => _StayHardAppState();
}

class _StayHardAppState extends ConsumerState<StayHardApp> {
  @override
  void initState() {
    super.initState();
    // Listen to alarm ring stream
    _listenToAlarmRing();
  }

  void _listenToAlarmRing() {
    ref.listenManual(ringingAlarmProvider, (previous, next) {
      next.whenData((alarmSettings) {
        if (alarmSettings != null && mounted) {
          // Fetch the alarm model from Firestore
          _handleRingingAlarm(alarmSettings);
        }
      });
    });
  }

  Future<void> _handleRingingAlarm(AlarmSettings alarmSettings) async {
    try {
      // Get the alarm repository
      final repository = ref.read(alarmRepositoryProvider);

      // Find the alarm by searching all alarms
      final alarmsStream = repository.getAlarms();
      final alarms = await alarmsStream.first;

      // Find matching alarm by ID hash
      final alarmModel = alarms.firstWhere(
        (alarm) => alarm.id.hashCode == alarmSettings.id,
        orElse: () => AlarmModel(
          id: alarmSettings.id.toString(),
          userId: '',
          label: alarmSettings.notificationSettings.title,
          time: TimeOfDay.fromDateTime(alarmSettings.dateTime),
          isEnabled: true,
          repeatDays: [],
          sound: AlarmSound.defaults.first,
          vibrate: true,
          dismissalMethod: DismissalMethod.classic,
          createdAt: DateTime.now(),
        ),
      );

      // Navigate to alarm challenge screen
      if (mounted) {
        _router.push(
          '/alarms/challenge',
          extra: {
            'alarmId': alarmSettings.id,
            'alarmModel': alarmModel,
          },
        );
      }
    } catch (e) {
      debugPrint('Error handling ringing alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StayHard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

/// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding (Info Slides)
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const InfoSlidesScreen(),
    ),

    // Auth Gate (decides between login and home)
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthGateScreen(),
      routes: [
        // Login
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Register
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Forgot Password
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
      ],
    ),

    // User Profile Completion / Onboarding Flow
    GoRoute(
      path: '/user-onboarding',
      builder: (context, state) => const OnboardingRouter(),
    ),

    // Home Screen (Main Shell with Bottom Navigation)
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShell(),
    ),

    // Alarms Routes
    GoRoute(
      path: '/alarms/create',
      builder: (context, state) => const AlarmEditScreen(),
    ),
    GoRoute(
      path: '/alarms/edit/:id',
      builder: (context, state) {
        final alarmId = state.pathParameters['id'];
        return AlarmEditScreen(alarmId: alarmId);
      },
    ),
    GoRoute(
      path: '/alarms/challenge',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final alarmId = extra['alarmId'] as int;
        final alarmModel = extra['alarmModel'] as AlarmModel;
        return AlarmChallengeScreen(
          alarmId: alarmId,
          alarmModel: alarmModel,
        );
      },
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Page not found: ${state.matchedLocation}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
