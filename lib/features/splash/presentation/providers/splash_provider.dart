import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Route enum for navigation from splash screen
enum SplashRoute {
  infoSlides,
  auth,
  home,
}

/// Splash provider that handles initialization and routing logic
final splashProvider = FutureProvider<SplashRoute>((ref) async {
  // Ensure splash is visible for at least 2 seconds
  await Future.delayed(const Duration(seconds: 2));

  // Check authentication status
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    // User is authenticated, go to home
    return SplashRoute.home;
  } else {
    // User is not authenticated, check if they've seen info slides
    final prefs = await SharedPreferences.getInstance();
    final hasSeenInfoSlides = prefs.getBool('seen_info_slides') ?? false;

    if (hasSeenInfoSlides) {
      // Go directly to auth
      return SplashRoute.auth;
    } else {
      // Show info slides first
      return SplashRoute.infoSlides;
    }
  }
});
