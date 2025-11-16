import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/auth_gate_screen.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/onboarding/presentation/pages/info_slides_screen.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'firebase_options.dart';
import 'features/user_profile_completion/presentation/pages/onboarding_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: StayHardApp(),
    ),
  );
}

class StayHardApp extends StatelessWidget {
  const StayHardApp({super.key});

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

    // Home Screen
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
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
