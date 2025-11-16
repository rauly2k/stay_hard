## Step 1: Core Dependencies & Setup

Dependencies: Ensure the following are in pubspec.yaml:
flutter_riverpod (for state management)
firebase_core (for Firebase)
firebase_auth (for authentication)
google_sign_in (for Google login)
shared_preferences (to track if info slides were seen)
flutter_native_splash (to manage the native splash)
google_fonts (for Inter font)

## Step 2: Theme 
From the BRAINSTORMING_COMPLETE.MD your job is to create theme files with those colors, fonts described there

## Step 3: Main & Routing
Main: Update lib/main.dart to initialize Firebase, set up ProviderScope (for Riverpod), and use the AppTheme.
Routing: Set up a basic router. The root of the app will be SplashScreen.

## Step 4: Module 1 - Splash Screen
UI:
Create a StatefulWidget for SplashScreen.
Use a Scaffold with the dark gradient background.
Center the app logo.
Use FadeTransition or AnimatedOpacity to fade the logo in on initState.
Provider: Create lib/features/splash/presentation/providers/splash_provider.dart.
Create a FutureProvider called splashProvider.
This provider will be responsible for the initialization and routing logic.
Logic (in splash_provider):
Future.delayed(const Duration(seconds: 2)) to ensure splash is visible (as per BRAINSTORMING_COMPLETE.md).
Check FirebaseAuth.instance.currentUser.
If currentUser != null: The user is authenticated. Return a route/state for HomeScreen.
If currentUser == null: The user is not authenticated.
Access SharedPreferences.getInstance().
Check for a boolean key: seen_info_slides.
If true: Return a route/state for AuthGateScreen.
If false or key not-existent: Return a route/state for InfoSlidesScreen.
SplashScreen Widget:
In initState, ref.watch(splashProvider) and use .when() to navigate to the correct screen onData received. 

## Step 5: Onboarding-pre-register (info slides)
Here the UI must be taken over from the file example: doc/page_example_onboading_page.dart - this exactly UI must be used for these slides - there will be 4
The PageController will track the current page.
"Next" Button: _pageController.nextPage(...).
"Skip" or "Get Started" Button onPressed:
Access SharedPreferences.getInstance().
Set await prefs.setBool('seen_info_slides', true).
Navigator.pushReplacement to AuthGateScreen.

## Step 6: Authentication
Files:
lib/features/auth/presentation/pages/auth_gate_screen.dart
lib/features/auth/presentation/pages/login_screen.dart
lib/features/auth/presentation/pages/register_screen.dart
lib/features/auth/presentation/pages/forgot_password_screen.dart
lib/features/auth/presentation/providers/auth_provider.dart
lib/features/auth/data/repositories/auth_repository.dart

Auth Repository:
Create an abstract AuthRepository class.
Create AuthRepositoryImpl that takes FirebaseAuth and GoogleSignIn as dependencies.
Implement methods:

Stream<User?> get authStateChanges
Future<void> signInWithGoogle()
Future<void> signInWithEmail(String email, String password)
Future<void> signUpWithEmail(String email, String password)
Future<void> sendPasswordResetEmail(String email)
Future<void> signOut()
Create a Riverpod Provider for authRepositoryProvider.
Auth Provider (State Notifier):
Create a StateNotifier or AsyncNotifier (e.g., authNotifierProvider) that uses the authRepositoryProvider.
Create public methods that call the repository methods and manage loading/error states (e.g., signInWithEmail, etc.).
Auth Gate Screen:
This widget will be the new entry point after Splash/Onboarding.
Create a StreamProvider authStateProvider that watches authRepositoryProvider.authStateChanges.
In the build method, watch(authStateProvider).when(...):
onData: (user) => user != null ? const HomeScreen() : const LoginScreen()
onError: ...
onLoading: ... (Show a loader)
Login/Register/Forgot Password Screens:
Implement the UI for all three screens exactly as specified in Phase_1_Requirements_and_Content.md.
Use TextFormField with GlobalKey<FormState> for validation.
Hook up all buttons to the authNotifierProvider:
Login button -> ref.read(authNotifierProvider.notifier).signInWithEmail(...)
Sign Up button -> ref.read(authNotifierProvider.notifier).signUpWithEmail(...)
Google button -> ref.read(authNotifierProvider.notifier).signInWithGoogle()
Forgot Pass link -> Navigator.push to ForgotPasswordScreen.
Send Link button -> ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(...)
Show loading indicators and error messages based on the authNotifierProvider's state.
Step 5: Module 4 - Placeholder Home Screen
File: lib/features/home/presentation/pages/home_screen.dart

UI:

Create a StatelessWidget HomeScreen.
Use a Scaffold with an AppBar.
AppBar title: Text("Home").
AppBar actions:

[
  IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () {
      // Access the Auth Notifier or Repository to sign out
      // e.g., ref.read(authRepositoryProvider).signOut();
    },
  )
]


Scaffold body: Center(child: Text("Home Screen")).

Logic:
The onPressed for the logout button should call the signOut method from your authRepositoryProvider or authNotifierProvider.
The AuthGateScreen's stream will automatically detect the null user and navigate back to the LoginScreen.