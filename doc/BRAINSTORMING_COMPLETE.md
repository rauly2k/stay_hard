# StayHard App - Complete Brainstorming & Requirements Document

**Version:** 1.0 - Ready for Planning
**Created:** 2025-11-15
**Purpose:** Comprehensive requirements document for Claude to create detailed implementation plan
**Target Audience:** Claude AI instance creating implementation plan

---

## Document Purpose

This document consolidates all brainstorming, requirements, technical decisions, and design specifications for the StayHard App. It serves as the single source of truth for generating a detailed, step-by-step implementation plan.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technical Foundation](#technical-foundation)
3. [Feature Modules Deep Dive](#feature-modules-deep-dive)
4. [Architecture Specifications](#architecture-specifications)
5. [Data Models](#data-models)
6. [Third-Party Integrations](#third-party-integrations)
7. [Platform-Specific Requirements](#platform-specific-requirements)
8. [UI/UX Implementation Strategy](#uiux-implementation-strategy)
9. [User Flows & Journeys](#user-flows--journeys)
10. [Development Phases](#development-phases)
11. [Testing Strategy](#testing-strategy)
12. [Performance & Optimization](#performance--optimization)
13. [Security & Privacy](#security--privacy)

---

## Project Overview

### Vision Statement

StayHard is a Flutter-based motivation and discipline-building mobile application that helps users build sustainable habits through intelligent AI-powered guidance, hard-to-dismiss alarms, focus sessions with app blocking, and comprehensive progress tracking.

### Core Value Propositions

1. **AI-Powered Personalization**: Google Gemini 2.5 Flash integration for intelligent habit matching and daily motivation
2. **Accountability Through Friction**: Hard-to-dismiss alarms with mathematical/typing challenges prevent easy snoozing
3. **Focus Protection**: Native Android app blocking for distraction-free sessions
4. **Comprehensive Tracking**: Detailed analytics linking habits to goals with visual progress indicators
5. **Motivational AI Companion**: Customizable AI notification system with personality archetypes

### Success Metrics

- User completes onboarding and adds first habits within 5 minutes
- 70%+ daily habit completion rate after 30 days of use
- Minimal app crashes (< 0.1% crash-free sessions)
- Offline functionality works seamlessly
- Fast app performance (< 2s cold start, < 500ms screen transitions)

---

## Technical Foundation

### Development Status

**Current State:** Starting from scratch - fresh Flutter project

**Initial Release Platform:** Android only (iOS support in future phases)

### Tech Stack

#### Frontend Framework
- **Flutter SDK:** Latest stable version (3.x)
- **Dart:** Latest stable version compatible with Flutter
- **Material 3:** Complete adherence to Material Design 3 guidelines

#### State Management
- **Primary:** Riverpod (riverpod, flutter_riverpod, riverpod_annotation)
- **Rationale:**
  - Compile-time safety with code generation
  - Excellent async/stream handling
  - Family/autoDispose patterns for optimized rebuilds
  - DevTools integration
  - Clean dependency injection

#### Local Storage
- **Primary Database:** Hive (lightweight, fast NoSQL)
- **Use Cases:**
  - Offline-first data caching
  - User preferences
  - Habit/goal data mirroring from Firestore
  - App state persistence
- **Structure:** Type-safe adapters for all data models

#### Backend & Cloud Services
- **Firebase Services (already configured):**
  - **Authentication:** Email/password, Google Sign-In, Apple Sign-In (iOS future)
  - **Firestore:** Real-time cloud database with offline persistence
  - **Cloud Storage:** User profile images, app assets
  - **Cloud Functions:** (Optional) Server-side business logic
  - **Crashlytics:** Crash reporting and analytics
  - **Performance Monitoring:** App performance metrics

#### AI Integration
- **Google Gemini 2.5 Flash API (already configured):**
  - Habit program matching during onboarding
  - Daily motivational notifications
  - Personalized insights based on user data
  - Progress analysis and suggestions

#### Critical Flutter Packages

**Background Services & Alarms:**
- `workmanager` or `flutter_background_service`: Background task execution
- `flutter_local_notifications`: Local notification management
- `alarm`: Alarm scheduling with wake lock support
- `wakelock_plus`: Keep screen on during challenges

**App Blocking (Android):**
- `accessibility_service` or custom platform channels: Monitor and block app usage
- `usage_stats`: Track app usage times
- `app_usage`: Alternative for usage tracking

**UI/UX:**
- `google_fonts`: Inter font family
- `flutter_svg`: Vector icon support
- `lottie`: Animation files
- `shimmer`: Loading placeholders
- `cached_network_image`: Efficient image loading

**Utilities:**
- `intl`: Date/time formatting, internationalization
- `equatable`: Value equality for models
- `freezed`: Immutable data classes with code generation
- `json_serializable`: JSON serialization
- `shared_preferences`: Simple key-value storage
- `path_provider`: File system paths
- `uuid`: Unique identifier generation

**Charts & Visualization:**
- `fl_chart`: Beautiful customizable charts for analytics
- `syncfusion_flutter_charts`: Alternative for complex charts

**Development Tools:**
- `riverpod_lint`: Linting rules for Riverpod
- `build_runner`: Code generation
- `flutter_launcher_icons`: Generate app icons
- `flutter_native_splash`: Splash screen generation

### Project Structure (Modular Architecture)

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # Root widget with routing
├── core/                              # Shared core functionality
│   ├── theme/                         # Material 3 theme configuration
│   │   ├── app_theme.dart             # Light/dark themes
│   │   ├── color_schemes.dart         # Color palette
│   │   ├── text_theme.dart            # Typography system
│   │   └── component_theme.dart       # Component customization
│   ├── constants/                     # App-wide constants
│   │   ├── app_constants.dart         # General constants
│   │   ├── api_constants.dart         # API endpoints, keys
│   │   └── asset_constants.dart       # Asset paths
│   ├── utils/                         # Utility functions
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   ├── format_utils.dart
│   │   └── platform_utils.dart
│   ├── errors/                        # Error handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── services/                      # Global services
│   │   ├── connectivity_service.dart  # Network status monitoring
│   │   └── logger_service.dart        # Logging utility
│   └── widgets/                       # Reusable widgets
│       ├── buttons/
│       ├── cards/
│       ├── inputs/
│       ├── bottom_sheets/
│       ├── dialogs/
│       └── loaders/
├── features/                          # Feature modules
│   ├── splash/                        # Splash screen
│   ├── onboarding/                    # First-time user experience
│   ├── auth/                          # Authentication
│   ├── habits/                        # Habit management
│   ├── alarms/                        # Alarm system
│   ├── focus/                         # Focus mode & app blocking
│   ├── goals/                         # Goal tracking
│   ├── ai_notifications/              # AI-powered notifications
│   ├── stats/                         # Analytics & statistics
│   └── profile/                       # User profile & settings
└── shared/                            # Shared across features
    ├── data/                          # Data layer
    │   ├── models/                    # Data models
    │   ├── repositories/              # Repository implementations
    │   └── data_sources/              # Local (Hive) & Remote (Firebase)
    ├── domain/                        # Domain layer
    │   ├── entities/                  # Business entities
    │   ├── repositories/              # Repository interfaces
    │   └── usecases/                  # Business logic
    └── providers/                     # Riverpod providers

# Each feature module follows this structure:
features/<feature_name>/
├── data/
│   ├── models/
│   ├── data_sources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/
```

### Architecture Pattern

**Clean Architecture + MVVM with Riverpod**

**Layers:**
1. **Presentation Layer:**
   - UI (Pages/Widgets)
   - State Management (Riverpod Providers)
   - View Models (State Notifiers)

2. **Domain Layer:**
   - Entities (pure Dart classes)
   - Repository Interfaces
   - Use Cases (business logic)

3. **Data Layer:**
   - Models (with JSON serialization)
   - Repository Implementations
   - Data Sources (Local Hive, Remote Firestore)

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Easy to swap data sources
- Scalable and maintainable

---

## Feature Modules Deep Dive

### 1. Splash Screen Module

**Purpose:** App initialization, branding, route determination

**Components:**
- Splash screen with animated logo
- Background initialization tasks
- Route decision logic

**Initialization Tasks:**
- Initialize Hive database
- Check authentication status
- Check onboarding completion
- Load user preferences
- Initialize Firebase services
- Sync offline changes if connectivity available

**Routing Logic:**
```
Launch App
  ↓
Splash Screen (1.5-2s minimum)
  ↓
Check Auth Token
  ↓
If Not Authenticated → 3 Steps App presentation Screen where user gets shown some info about app -> Auth Screen
If Authenticated + No Onboarding → Onboarding Flow
If Authenticated + Onboarding Complete → Home Screen
```

**Technical Details:**
- Use `Timer` or `Future.delayed` for minimum splash duration
- Parallel async initialization tasks
- Error handling for initialization failures
- Progress indicator if initialization takes > 2s

---

### 2. Onboarding Module

**Purpose:** First-time user experience, AI-powered habit matching, profile setup

**Flow Stages:**

#### Stage 1: Welcome & Introduction (3-4 screens)
- Screen 1: Screen with logo in the middle, text Welcome to StayHard tap anywhere to continue
- Screen 2: Screen with logo in the middle, text Ready to start your life reset journey? Answer a few quick questions to get your personialized transformation program. Button let's begin
- Screen 3: A screen with questions (6 of them and answers predefined where user can respond)

#### Stage 2: AI Questionnaire for Habit Matching
**Questionnaire-based AI matching using Gemini 2.5 Flash**

**Questions (8-10 questions):**
1. What are your primary life goals? (Multi-select: Fitness, Career, Learning, Health, Relationships, Creativity, Finance)
2. What time of day are you most productive? (Morning / Afternoon / Evening / Night Owl)
3. How would you rate your current discipline level? (1-5 scale)
4. What areas need the most improvement? (Physical health, Mental health, Productivity, Social life, etc.)
5. How many hours per day can you dedicate to habits? (< 1 hour, 1-2 hours, 2-3 hours, 3+ hours)
6. What motivates you most? (Achievement, Health, Success, Helping others, Personal growth)
7. How do you handle setbacks? (Quit easily, Take a break, Push through, Need external motivation)
8. What is your preferred habit frequency? (Daily, Few times a week, Weekly)
9. Do you prefer structure or flexibility? (Strict schedules, Moderate flexibility, Completely flexible)
10. Rate your stress levels: (Low, Medium, High)

**AI Processing:**
- Send questionnaire responses to Gemini API
- Prompt: "Based on these user responses, recommend 5-10 habits from the following templates that would best suit this user's goals, lifestyle, and personality. For each habit, explain why it's a good fit."
- Parse AI response to extract recommended habit IDs and rationales

**Habit Template Library (20 templates across 5 profiles):**

**Profile 1: Foundation (Basic Self-Care)**
**Profile 2: Body (Physical Health)**
**Profile 3: Mind (Mental Health & Learning)**
**Profile 4: Discipline (Productivity & Focus)**
**Profile 5: Social & Creative**


#### Stage 3: AI Habit Recommendations
- Display AI-recommended habits
- Show rationale for each recommendation
- Allow user to select which ones to add
- Option to browse all templates and add extras
- Minimum 3, maximum 10 habits for initial setup

#### Stage 4: Profile Setup
- Name
- Profile picture (optional, camera/gallery)
- Time zone (auto-detect)
- Notification preferences

#### Stage 5: Permission Requests
- Notification permission (critical)
- Alarm permission (Android 12+)
- Accessibility service (for app blocking, explain clearly)
- Usage stats access (for app blocking)

**Data Stored After Onboarding:**
- User profile (name, picture, preferences)
- Questionnaire responses (for future AI insights)
- Selected habits with default configurations
- Onboarding completion flag
- Permission statuses

---

### 3. Authentication Module

**Purpose:** Secure user authentication with Firebase

**Features:**
- Email/password authentication
- Google Sign-In
- Password reset
- Account creation
- Persistent login state

**Screens:**
1. **Login Screen:**
   - Email input field
   - Password input field
   - "Forgot Password?" link
   - Login button
   - "Or continue with" divider
   - Google Sign-In button
   - "Don't have an account? Sign Up" link

2. **Sign Up Screen:**
   - Name input field
   - Email input field
   - Password input field (with strength indicator)
   - Confirm password field
   - Terms & conditions checkbox
   - Sign Up button
   - Google Sign-In option
   - "Already have an account? Login" link

3. **Forgot Password Screen:**
   - Email input
   - Send reset link button
   - Success/error feedback

**Validation:**
- Email format validation
- Password strength (min 8 chars, 1 uppercase, 1 number, 1 special char)
- Matching password confirmation
- Real-time validation feedback

**Error Handling:**
- User-friendly error messages
- Network error handling
- Firebase-specific errors (user not found, wrong password, email already in use)

**State Management with Riverpod:**
```dart
// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});
```

---

### 4. Habits Module (Core Feature)

**Purpose:** Full CRUD operations for user habits, completion tracking, templates
**Data Model - Habit Entity:**

```dart
class Habit {
  final String id;                    // Unique identifier
  final String userId;                // Owner
  final String name;                  // "Morning Workout"
  final String description;           // Optional details
  final IconData icon;                // Material icon
  final Color color;                  // Habit color
  final HabitCategory category;       // Foundation, Body, Mind, etc.
  final HabitType type;               // Duration, Quantity, Simple, Custom
  final HabitFrequency frequency;     // Daily, Weekly, Custom
  final List<int> weekdays;           // [1,2,3,4,5] for weekdays
  final List<TimeOfDay> scheduledTimes; // Multiple times per day
  final int? targetDuration;          // Minutes (for duration type)
  final int? targetQuantity;          // Number (for quantity type)
  final String? unit;                 // "glasses", "pages", "minutes"
  final bool isFromTemplate;          // True if created from template
  final String? templateId;           // Reference to template
  final bool isActive;                // Active or archived
  final DateTime createdAt;
  final DateTime? archivedAt;
  final Map<String, dynamic>? metadata; // Extra data
}

class HabitCompletion {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;                // Date of completion
  final DateTime completedAt;         // Timestamp
  final int? actualValue;             // For quantity/duration tracking
  final String? notes;                // Optional user notes
  final CompletionSource source;      // Manual, Alarm, Widget
}
```

**Habit Types:**
1. **Simple:** Just mark complete/incomplete (e.g., "Take vitamins")
2. **Duration:** Track time spent (e.g., "Meditate for 20 minutes")
3. **Quantity:** Track count/amount (e.g., "Drink 8 glasses of water")
4. **Custom:** Text input (e.g., "Journal entry")

**Habit Frequency:**
1. **Daily:** Every day
2. **Specific Days:** Select weekdays
3. **Interval:** Every N days
4. **Weekly:** X times per week

**Features:**

#### 4.1 Habit List (Home Screen)
- Display today's habits grouped by time of day (Morning, Afternoon, Evening, Anytime)
- Show completion status
- Quick completion toggle
- Progress summary at top (Hero graphic)
- Filter options (All, Active, Completed, Pending)
- Sort options (By time, By category, By priority)

**Hero Graphic (Top Section):**
- Circular progress ring showing today's completion percentage
- Center stats: "5/8 Complete", "3 Remaining"
- Gradient background
- Motivational quote or AI-generated message

**Habit Card Components:**
- Icon with color
- Habit name
- Description (collapsed, expandable)
- Time chips (Morning, 8:00 AM, etc.)
- Completion button (checkmark circle)
- Swipe actions (Edit, Archive, Delete)

#### 4.2 Add/Edit Habit
**Add Habit Flow:**
1. Choose source: Template or Custom
2. If Template: Browse template bottom sheet
3. Configure habit details:
   - Name, description
   - Icon selection (icon picker)
   - Color selection (color picker)
   - Category selection
   - Type selection (Simple, Duration, Quantity, Custom)
   - Frequency configuration
   - Time scheduling (multiple times allowed)
   - Target values (if applicable)
4. Save habit

**Edit Habit:**
- Same form as add, pre-filled with current values
- Allow archiving
- Show completion history preview

#### 4.3 Habit Templates Bottom Sheet
- List all 20 templates grouped by profile
- Search functionality
- Multi-select mode
- Show icon, name, category, description
- Animated selection state
- "Add X Habits" button in footer
- For each selected template, show configuration dialog

#### 4.4 Habit Detail Page
- Full habit information
- Completion history (calendar view + list)
- Statistics (streak, completion rate, total completions)
- Linked goals
- Edit/Archive/Delete actions
- Completion charts (last 7 days, 30 days)

#### 4.5 Habit Completion
**Manual Completion:**
- Tap checkmark on habit card
- Animation: scale + fill + border change
- Update Firestore and Hive
- Check if goal progress updated
- Trigger any alarms to mark as completed

**Alarm-Triggered Completion:**
- After completing alarm challenge
- Automatically mark habit as complete
- Show success notification

**Widget Completion:**
- (Future) Home screen widget for quick completion

#### 4.6 Offline Handling
- All habit CRUD operations work offline using Hive
- Queue Firestore updates for when online
- Conflict resolution: Last write wins (with timestamp)
- Sync status indicator

**Riverpod Providers:**
```dart
// Habit list provider (stream from Hive + Firestore sync)
final habitsProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
  // Listen to Hive box changes
  // Background sync with Firestore
});

// Today's habits provider
final todayHabitsProvider = Provider.autoDispose<List<Habit>>((ref) {
  final habits = ref.watch(habitsProvider).value ?? [];
  final today = DateTime.now().weekday;
  return habits.where((h) => h.weekdays.contains(today)).toList();
});

// Habit completion provider
final habitCompletionProvider = Provider<HabitCompletionService>((ref) {
  return HabitCompletionService(
    hiveSource: ref.watch(hiveDataSourceProvider),
    firestoreSource: ref.watch(firestoreDataSourceProvider),
  );
});
```

---

### 5. Alarms Module

**Purpose:** Hard-to-dismiss alarms with interactive challenges to ensure user engagement

**Alarm Types & Challenges:**

1. **Simple Alarm:** Standard alarm, single button to dismiss
2. **Math Challenge:** Solve 3-5 arithmetic problems
3. **Typing Challenge:** Type a motivational phrase exactly
4. **Custom Text Challenge:** Answer a personal question (set by user)

**Data Model:**

```dart
class Alarm {
  final String id;
  final String userId;
  final String habitId;              // Optional: link to habit
  final TimeOfDay time;
  final String label;
  final List<int> repeatDays;        // Weekdays [1-7]
  final bool isEnabled;
  final AlarmChallengeType challengeType;
  final int challengeDifficulty;     // 1-3 for math (easy/medium/hard)
  final String? customText;          // For custom challenge
  final AlarmSound sound;
  final int volume;                  // 0-100
  final bool vibrate;
  final int snoozeDuration;          // Minutes
  final int maxSnoozes;              // 0 = no snooze allowed
  final DateTime createdAt;
}

enum AlarmChallengeType {
  simple,
  math,
  typing,
  customText,
}

class AlarmSound {
  final String id;
  final String name;
  final String assetPath;
}
```

**Features:**

#### 5.1 Alarm List Screen
- Display all alarms
- Toggle enabled/disabled
- Quick edit time
- Add new alarm FAB
- Group by linked habit (optional)

#### 5.2 Alarm Creation/Edit
**Form Fields:**
- Time picker (Material time picker)
- Label input
- Repeat days selector (M T W T F S S chips)
- Challenge type selection
- Challenge difficulty (for math)
- Custom text input (for custom challenge)
- Sound selection (list of alarm sounds)
- Volume slider
- Vibrate toggle
- Snooze settings (duration, max snoozes)
- Link to habit (optional dropdown)

#### 5.3 Alarm Challenge Screen (Critical Feature)

**When alarm triggers:**
1. Full-screen overlay (can't dismiss without completing)
2. Alarm sound plays in loop
3. Vibration pattern
4. Screen stays on (wakelock)
5. Volume buttons disabled or repurposed
6. Show challenge UI based on type

**Math Challenge:**
- Display math problem (e.g., "17 + 23 = ?")
- Number pad input
- Difficulty levels:
  - Easy: Single-digit addition/subtraction
  - Medium: Double-digit addition/subtraction
  - Hard: Multiplication, division, multi-step
- Require 3-5 correct answers in a row
- Wrong answer resets counter
- Timer shows elapsed time

**Typing Challenge:**
- Display phrase to type (motivational quotes or custom)
- Text input field
- Must match exactly (case-sensitive)
- Show character-by-character match indicator
- Examples:
  - "I am disciplined and focused"
  - "Today I will achieve my goals"
  - Custom user-defined phrases

**Custom Text Challenge:**
- User sets a personal question during alarm setup
- Examples:
  - "What is your biggest goal today?"
  - "Why did you set this alarm?"
- Requires text input (minimum 10 characters)
- No right/wrong answer, just forces engagement

**Snooze Handling:**
- Snooze button visible only if allowed
- Show snooze count: "2/3 snoozes used"
- After max snoozes, only challenge remains
- Snooze time configurable

#### 5.4 Alarm Service (Background)

**Implementation:**
- Use `alarm` package for reliable alarm scheduling
- Background service with `workmanager` for alarm triggers
- Wake lock to prevent screen sleep during alarm
- Notification persistence while alarm active
- Handle device reboot (persist alarms, reschedule)

**Edge Cases:**
- Phone in Do Not Disturb mode (request override permission)
- App killed by system (use Android AlarmManager API)
- Battery optimization (whitelist app)
- Multiple alarms at same time (queue them)

**Permissions Required:**
- Exact alarm permission (Android 12+)
- Notification permission
- Overlay permission (for full-screen challenge)
- Schedule exact alarm permission

**Riverpod Providers:**
```dart
final alarmsProvider = StreamProvider<List<Alarm>>((ref) {
  // Hive + Firestore sync
});

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

// Trigger alarm challenge
final alarmChallengeProvider = StateNotifierProvider<AlarmChallengeNotifier, AlarmChallengeState>((ref) {
  return AlarmChallengeNotifier(ref.watch(alarmServiceProvider));
});
```

---

### 6. Focus Module (App Blocking)

**Purpose:** Distraction-free focus sessions with native Android app blocking

**Implementation Strategy:** Accessibility Service

**Data Model:**

```dart
class FocusSession {
  final String id;
  final String userId;
  final String name;                 // "Morning Deep Work"
  final Duration duration;           // 25 minutes
  final List<String> blockedApps;    // Package names
  final bool blockNotifications;
  final String? linkedHabitId;       // Optional
  final FocusSessionStatus status;   // Scheduled, Active, Paused, Completed
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime createdAt;
}

enum FocusSessionStatus {
  scheduled,
  active,
  paused,
  completed,
  cancelled,
}

class BlockedApp {
  final String packageName;
  final String appName;
  final String? iconPath;            // Cached icon
  final int blockCount;              // How many times blocked
}
```

**Features:**

#### 6.1 Focus Session Creation
**Form:**
- Session name
- Duration picker (15, 25, 30, 45, 60, 90 minutes or custom)
- Blocked apps selector (multi-select from installed apps)
- Block notifications toggle
- Link to habit (optional)
- Start immediately or schedule for later

**Preset Focus Modes:**
1. **Deep Work:** Block social media, messaging, games (25-60 min)
2. **Study Session:** Block entertainment apps (30-120 min)
3. **Bedtime:** Block all except emergency contacts (entire night)
4. **Minimal Distraction:** Block only specified apps
5. **Custom:** User-defined

#### 6.2 Blocked Apps Selector
- Fetch installed apps using platform channel
- Display app name + icon
- Group by category (Social, Entertainment, Games, Productivity, etc.)
- Search functionality
- Quick select presets ("Block Social Media", "Block Games")
- Multi-select with checkboxes

#### 6.3 Active Focus Session Screen
**During Session:**
- Timer countdown (large, center)
- Circular progress indicator
- Session name
- Blocked apps count
- Pause/Resume button
- End session button (with confirmation)
- Motivational message
- Background gradient animation

**Blocking Mechanism:**
1. Accessibility Service monitors app usage
2. When blocked app is launched, immediately:
   - Show overlay with message: "This app is blocked during your focus session"
   - Display time remaining
   - Option to end session (with warning)
   - Redirect back to Focus screen or home
3. Optional: Play sound/vibration on block attempt
4. Log blocked attempts for statistics

#### 6.4 Focus History & Statistics
- List of past focus sessions
- Total focus time (today, week, month, all-time)
- Most blocked apps
- Longest session
- Focus streak (consecutive days)
- Charts showing focus time trends

#### 6.5 Accessibility Service Setup

**Android Accessibility Service:**
- Create custom AccessibilityService
- Monitor `AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED`
- Check package name against blocked apps list
- If blocked, overlay redirect screen

**Permissions & Setup:**
1. Request accessibility permission in app
2. Guide user to Settings > Accessibility > StayHard > Enable
3. Explain why permission is needed
4. Handle permission revoked scenario

**Platform Channel (Dart ↔ Kotlin):**
```dart
// Method channel for app blocking
class AppBlockingService {
  static const platform = MethodChannel('com.stayhard/app_blocking');

  Future<void> startFocusSession(List<String> blockedApps) async {
    await platform.invokeMethod('startFocusSession', {
      'blockedApps': blockedApps,
    });
  }

  Future<void> stopFocusSession() async {
    await platform.invokeMethod('stopFocusSession');
  }

  Future<List<String>> getInstalledApps() async {
    final apps = await platform.invokeMethod('getInstalledApps');
    return List<String>.from(apps);
  }
}
```

**Native Android Code (Kotlin):**
```kotlin
// AccessibilityService implementation
class AppBlockingService : AccessibilityService() {
    private val blockedApps = mutableSetOf<String>()

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString()
            if (blockedApps.contains(packageName)) {
                // Redirect to blocking overlay
                showBlockingOverlay()
            }
        }
    }

    private fun showBlockingOverlay() {
        // Launch blocking activity
        val intent = Intent(this, BlockingOverlayActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }
}
```

**Riverpod Providers:**
```dart
final focusSessionProvider = StateNotifierProvider<FocusSessionNotifier, FocusSessionState>((ref) {
  return FocusSessionNotifier(
    appBlockingService: ref.watch(appBlockingServiceProvider),
  );
});

final activeFocusSessionProvider = Provider<FocusSession?>((ref) {
  final state = ref.watch(focusSessionProvider);
  return state.activeSession;
});
```

---

### 7. Goals Module

**Purpose:** Goal setting, tracking, linking habits to goals, progress visualization

**Data Model:**

```dart
class Goal {
  final String id;
  final String userId;
  final String name;                 // "Lose 10kg"
  final String description;
  final GoalCategory category;       // Fitness, Career, Learning, Health, etc.
  final IconData icon;
  final Color color;
  final DateTime targetDate;
  final GoalStatus status;           // Active, Completed, Paused, Abandoned
  final int targetValue;             // Numeric target (optional)
  final String? unit;                // "kg", "books", "hours"
  final List<String> linkedHabitIds; // Habits contributing to this goal
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;
}

enum GoalCategory {
  fitness,
  career,
  learning,
  health,
  finance,
  relationships,
  creativity,
  personal,
}

enum GoalStatus {
  active,
  completed,
  paused,
  abandoned,
}

class GoalProgress {
  final String goalId;
  final DateTime date;
  final double progressPercentage;   // 0.0 to 1.0
  final int habitCompletions;        // Linked habits completed that day
}
```

**Features:**

#### 7.1 Goals List Screen
- Display active goals
- Progress bar for each goal
- Days remaining countdown
- Today's linked habit completions (e.g., "3/5 today")
- Filter by status (Active, Completed, All)
- Sort by deadline, progress, category
- Add goal FAB

**Goal Card:**
- Icon with color background
- Goal name + category
- Description (1-2 lines)
- Progress bar (0-100%)
- Stats chips:
  - Linked habits count
  - Today's completions
  - Days remaining (or overdue warning)
- Tap to view details

#### 7.2 Create/Edit Goal
**Form:**
- Goal name
- Description
- Category selection
- Icon picker
- Color picker
- Target date (date picker)
- Target value + unit (optional)
- Link habits (multi-select from user's habits)

**Validation:**
- Target date must be in future
- At least one linked habit recommended
- Name required

#### 7.3 Goal Detail Page

**Sections:**

**Header:**
- Large icon with gradient background
- Goal name
- Category badge
- Status badge
- Edit/Delete actions menu

**Progress Overview:**
- Large circular progress ring
- Percentage complete
- Days remaining / days elapsed
- Target date
- Current value vs target (if applicable)

**Linked Habits:**
- List of linked habits with icons
- Today's completion status for each
- Tap to view habit details
- Add/remove linked habits

**Analytics:**
- Progress chart (last 8 weeks)
- Habit completion trends
- Best performing days/times
- Predictions (if enough data)

**Timeline/Roadmap:**
- Milestones (25%, 50%, 75%, 100%)
- Estimated completion date based on current pace
- Visual timeline with markers

**Activity Feed:**
- Recent completions
- Milestones reached
- Streak achievements

#### 7.4 Goal Progress Calculation

**Automatic Progress Tracking:**
- Calculate progress based on linked habit completions
- Formula: `(completedHabits / targetHabits) * 100`
- Alternative: Time-based progress if target date is set
- Update daily at midnight

**Manual Progress Entry:**
- For goals with target values (e.g., weight loss)
- Allow user to input current value
- Progress = `(startValue - currentValue) / (startValue - targetValue) * 100`

**Goal Completion:**
- Automatically mark complete when 100% reached
- Show celebration animation
- Generate completion certificate (shareable image)
- Offer to set new related goal

#### 7.5 Goal Statistics

**Metrics:**
- Total goals created
- Goals completed
- Success rate
- Average time to completion
- Most active goal category
- Current active goals
- Longest goal streak

**Riverpod Providers:**
```dart
final goalsProvider = StreamProvider<List<Goal>>((ref) {
  // Hive + Firestore sync
});

final activeGoalsProvider = Provider<List<Goal>>((ref) {
  final goals = ref.watch(goalsProvider).value ?? [];
  return goals.where((g) => g.status == GoalStatus.active).toList();
});

final goalProgressProvider = Provider.family<double, String>((ref, goalId) {
  // Calculate progress for specific goal
  final goal = ref.watch(goalsProvider).value?.firstWhere((g) => g.id == goalId);
  final habitCompletions = ref.watch(habitCompletionsProvider);
  // Calculate progress
  return 0.0; // Placeholder
});
```

---

### 8. AI Notifications Module

**Purpose:** Daily motivational notifications with customizable AI archetypes and intensity levels

**Core Concept:**
- AI generates personalized motivational messages daily
- User selects archetype (personality/tone)
- Adjustable intensity (3 levels)
- Messages contextualized based on user's habits, goals, progress

**Data Model:**

```dart
class AINotificationConfig {
  final String userId;
  final AIArchetype archetype;
  final AIIntensity intensity;
  final List<TimeOfDay> scheduledTimes; // Multiple notifications per day
  final bool isEnabled;
  final DateTime lastUpdated;
}

enum AIArchetype {
  drillSergeant,    // Tough, commanding, military-style
  wiseMentor,       // Calm, wise, philosophical guidance
  friendlyCoach,    // Supportive, encouraging, positive
  motivationalSpeaker, // Energetic, inspirational, Tony Robbins-style
  philosopher,      // Deep, thoughtful, Stoic-inspired
  humorousFriend,   // Light-hearted, funny, relatable
  // 1-2 more archetypes
}

enum AIIntensity {
  low,      // Gentle reminders, soft encouragement
  medium,   // Balanced motivation, some push
  high,     // Strong push, challenging, demanding
}

class AINotification {
  final String id;
  final String userId;
  final String message;             // AI-generated text
  final AIArchetype archetype;
  final DateTime scheduledTime;
  final DateTime? sentAt;
  final DateTime? readAt;
  final bool isDismissed;
  final NotificationContext context; // What triggered it
}

class NotificationContext {
  final List<String> relevantHabitIds;
  final List<String> relevantGoalIds;
  final double todayCompletionRate;
  final int currentStreak;
  final String primaryFocus;         // What to emphasize
}
```

**AI Archetype Descriptions:**

1. **Drill Sergeant:**
   - Tone: Commanding, tough love, no-nonsense
   - Example: "Drop and give me 20! No excuses today, soldier. Your goals won't achieve themselves!"
   - Best for: Users who need strict accountability

2. **Wise Mentor:**
   - Tone: Calm, philosophical, guiding
   - Example: "Remember, discipline is choosing between what you want now and what you want most. Today is another opportunity."
   - Best for: Users who prefer gentle wisdom

3. **Friendly Coach:**
   - Tone: Supportive, encouraging, team player
   - Example: "You've got this! Yesterday you crushed it with 7/8 habits. Let's make today even better!"
   - Best for: Users who need positive reinforcement

4. **Motivational Speaker:**
   - Tone: High energy, passionate, inspiring
   - Example: "THIS IS YOUR DAY! The person you want to be is waiting on the other side of today's habits. Let's GO!"
   - Best for: Users who need energy boosts

5. **Philosopher:**
   - Tone: Thoughtful, Stoic, reflective
   - Example: "Seneca said, 'It is not that we have a short time to live, but that we waste a lot of it.' Make today count."
   - Best for: Users interested in deeper meaning

6. **Humorous Friend:**
   - Tone: Fun, relatable, light-hearted
   - Example: "Hey champ! Your meditation streak is higher than my coffee consumption. Almost. Keep it up! ☕😄"
   - Best for: Users who prefer lighthearted approach

**Features:**

#### 8.1 AI Notification Configuration Screen

**Sections:**

**Archetype Selection:**
- Card-based selection with descriptions
- Preview sample messages for each archetype
- Single selection
- Visual icons for each archetype

**Intensity Level:**
- Three radio buttons or slider
- Low: 1-2 notifications per day, gentle
- Medium: 2-3 notifications per day, balanced
- High: 3-5 notifications per day, strong push
- Describe what each level means

**Notification Schedule:**
- Select times of day for notifications
- Suggestions: Morning (wake up), Midday (lunch), Evening (wind down)
- Allow custom times

**Enable/Disable Toggle:**
- Master switch for all AI notifications

#### 8.2 AI Message Generation

**Process:**
1. **Trigger:** Scheduled time reached
2. **Context Gathering:**
   - Fetch user's habits for today
   - Check completion status
   - Get active goals and progress
   - Calculate streaks
   - Identify areas needing attention (e.g., 3 pending habits)
3. **Prompt Construction for Gemini:**
   ```
   You are a {archetype} providing daily motivation to a user.

   User Context:
   - Total habits today: {total}
   - Completed: {completed}
   - Pending: {pending habits list}
   - Current streak: {streak} days
   - Active goals: {goals}
   - Time of day: {morning/afternoon/evening}

   Intensity level: {low/medium/high}

   Generate a {intensity}-level motivational message in the {archetype} style.
   Focus on encouraging the user to complete their pending habits.
   Keep it under 100 characters for notification display.

   Message:
   ```
4. **Send to Gemini API**
5. **Parse Response**
6. **Send Notification**

**Caching & Fallbacks:**
- Cache Gemini responses for offline use
- Pregenerate 20-30 messages per archetype (fallback if API fails)
- Rotate fallback messages to avoid repetition

**Notification Delivery:**
- Use `flutter_local_notifications`
- Display as rich notification with icon
- Tap to open app (to Habits screen)
- Action buttons: "View Habits", "Dismiss"

#### 8.3 AI Insights Screen (Part of Stats Module)

**Purpose:** Display AI-generated weekly/monthly insights

**Weekly Insights:**
- Analyze past week's habit completion data
- Identify patterns (e.g., "You complete 80% more habits on Mondays")
- Suggest improvements (e.g., "Try scheduling meditation earlier, you skip it 70% of the time after 8 PM")
- Celebrate wins (e.g., "You maintained a perfect water intake streak!")

**Monthly Summary:**
- Overall progress report
- Goal achievements
- Habit trends
- Personalized recommendations for next month

**Prompt for Insights:**
```
Analyze this user's habit data for the past {period}:

Data:
{JSON of completions, streaks, timestamps, goals}

Generate a comprehensive insight report including:
1. Top 3 achievements
2. Areas for improvement
3. Patterns discovered (time of day, day of week correlations)
4. Actionable recommendations
5. Motivational conclusion

Format as structured JSON.
```

**Riverpod Providers:**
```dart
final aiNotificationConfigProvider = StreamProvider<AINotificationConfig>((ref) {
  // Hive + Firestore
});

final aiNotificationServiceProvider = Provider<AINotificationService>((ref) {
  return AINotificationService(
    geminiAPI: ref.watch(geminiAPIProvider),
  );
});

// Generate notification
final generateAINotificationProvider = FutureProvider.autoDispose<String>((ref) async {
  final config = ref.watch(aiNotificationConfigProvider).value;
  final habitData = ref.watch(todayHabitsProvider);
  final goalData = ref.watch(activeGoalsProvider);

  final service = ref.watch(aiNotificationServiceProvider);
  return await service.generateMessage(config, habitData, goalData);
});
```

---

### 9. Stats/Analytics Module

**Purpose:** Comprehensive analytics, visualizations, insights, progress tracking

**Features:**

#### 9.1 Statistics Dashboard

**Overview Metrics (Top Cards):**
- Today's completion rate (circular progress)
- Current streak (flame icon)
- Total habits completed (all time)
- Active goals count

**Time Period Selector:**
- Tabs: Today, Week, Month, Year, All Time
- Updates all charts/metrics on change

**Charts & Visualizations:**

1. **Habit Completion Trend (Line/Bar Chart):**
   - X-axis: Days/Weeks/Months
   - Y-axis: Number of completed habits
   - Show goal line (average or target)
   - Use `fl_chart` package

2. **Category Breakdown (Pie/Donut Chart):**
   - Show completion by category (Foundation, Body, Mind, etc.)
   - Color-coded segments
   - Tap segment for detail

3. **Heatmap Calendar:**
   - GitHub-style contribution graph
   - Each day shows completion percentage
   - Color intensity based on performance
   - Tap day for details

4. **Time of Day Analysis (Bar Chart):**
   - Show best performing time periods
   - Morning vs Afternoon vs Evening completion rates

5. **Habit Performance Table:**
   - List all habits with:
     - Name
     - Completion rate (%)
     - Current streak
     - Best streak
   - Sortable columns

**Leaderboard (Future):**
- Compare with friends (opt-in)
- Anonymous global rankings
- Category-specific leaderboards

#### 9.2 Streaks & Achievements

**Streak Tracking:**
- Current streak (consecutive days with >70% completion)
- Longest streak (personal best)
- Streak calendar visualization
- Streak milestones (7 days, 30 days, 100 days, etc.)

**Achievement Badges:**
- First habit completed
- 7-day streak
- 30-day streak
- 100 habits completed
- All habits completed in a day (10 times)
- Goal completed
- Etc.

**Display:**
- Badge gallery
- Progress toward next badge
- Share achievements (image generation)

#### 9.3 Detailed Reports

**Weekly Report:**
- Best day of the week
- Total completions
- Habits added/archived
- Goals progress
- AI-generated summary

**Monthly Report:**
- Month overview
- Comparison to previous month
- Milestone achievements
- Areas of improvement
- Exportable as PDF

#### 9.4 Export & Backup

**Export Options:**
- CSV export (habit data, completions, goals)
- PDF reports
- JSON backup (full data export)

**Backup to Cloud:**
- Automatic Firestore backup
- Manual backup to device storage
- Restore from backup

**Riverpod Providers:**
```dart
final statsProvider = Provider.autoDispose.family<Stats, DateRange>((ref, dateRange) {
  final completions = ref.watch(habitCompletionsProvider);
  // Calculate stats for date range
  return Stats(...);
});

final streakProvider = Provider<StreakData>((ref) {
  final completions = ref.watch(habitCompletionsProvider).value ?? [];
  // Calculate current and longest streak
  return StreakData(...);
});

final achievementsProvider = StreamProvider<List<Achievement>>((ref) {
  // Fetch achievements from Hive/Firestore
});
```

---

### 10. Profile Module

**Purpose:** User profile, settings, preferences, account management

**Features:**

#### 10.1 Profile Screen

**Header:**
- Profile picture (editable, camera/gallery)
- Username
- Email
- Join date
- Quick stats (Total habits, Active goals, Current streak)

**Sections:**

**Account Settings:**
- Edit profile (name, picture)
- Change password
- Linked accounts (Google)
- Delete account (with confirmation)

**App Settings:**
- Theme selection (Light, Dark, System)
- Language (future)
- Notification settings:
  - Enable/disable all notifications
  - Habit reminders
  - Alarm notifications
  - AI motivational notifications
- Time zone
- Date/time format

**AI Preferences:**
- AI archetype selection
- Intensity level
- Notification schedule
- (Shortcut to AI config screen)

**Data & Privacy:**
- Export data
- Backup & restore
- Clear cache
- View privacy policy
- Terms of service

**Focus Settings:**
- Default focus duration
- Default blocked apps
- Accessibility service status

**About:**
- App version
- Credits
- Open source licenses
- Contact support
- Rate app
- Share app

#### 10.2 Onboarding Preferences

**Allow Re-taking Questionnaire:**
- User can retake AI matching questionnaire
- Updates habit recommendations
- "Refresh My Habits" option

#### 10.3 Notification Settings Detail

**Granular Control:**
- Per-habit notification toggle
- Quiet hours (no notifications during this time)
- Notification sound selection
- Vibration pattern

---

## Architecture Specifications

### Data Flow Architecture

**Offline-First Architecture:**

```
UI Layer (Widgets)
      ↓ (user action)
Riverpod Providers (State Management)
      ↓ (call use case)
Use Cases (Business Logic)
      ↓ (call repository)
Repository (Interface)
      ↓
Repository Implementation
   ↙         ↘
Local          Remote
Data Source    Data Source
(Hive)         (Firestore)
```

**Data Sync Strategy:**

1. **Read Operations:**
   - Always read from local Hive first (fast)
   - Background sync from Firestore
   - Update local cache with remote data
   - Emit updated stream to UI

2. **Write Operations:**
   - Write to Hive immediately (instant UI update)
   - Queue Firestore write operation
   - Execute when online
   - Handle conflicts (last write wins with timestamp)

3. **Conflict Resolution:**
   - Use timestamp to determine latest change
   - If remote timestamp > local timestamp, remote wins
   - Notify user of overwritten data (optional)

**Repository Pattern Example:**

```dart
abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Stream<List<Habit>> watchHabits();
  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);
}

class HabitRepositoryImpl implements HabitRepository {
  final HiveDataSource hiveDataSource;
  final FirestoreDataSource firestoreDataSource;
  final ConnectivityService connectivityService;

  @override
  Stream<List<Habit>> watchHabits() {
    // Listen to Hive box changes
    final localStream = hiveDataSource.watchHabits();

    // Background sync from Firestore
    _syncFromFirestore();

    return localStream;
  }

  Future<void> _syncFromFirestore() async {
    if (await connectivityService.isConnected) {
      final remoteHabits = await firestoreDataSource.getHabits();
      await hiveDataSource.saveHabits(remoteHabits);
    }
  }

  @override
  Future<void> addHabit(Habit habit) async {
    // Immediate local save
    await hiveDataSource.addHabit(habit);

    // Queue remote save
    _queueFirestoreWrite(() => firestoreDataSource.addHabit(habit));
  }

  void _queueFirestoreWrite(Function write) async {
    if (await connectivityService.isConnected) {
      try {
        await write();
      } catch (e) {
        // Add to pending queue, retry later
        _pendingWrites.add(write);
      }
    } else {
      _pendingWrites.add(write);
    }
  }
}
```

### State Management with Riverpod

**Provider Types Used:**

1. **Provider:** For read-only, synchronous data
2. **FutureProvider:** For async data fetching
3. **StreamProvider:** For real-time data streams (Hive, Firestore)
4. **StateNotifierProvider:** For complex state with mutations
5. **StateProvider:** For simple mutable state

**Code Generation:**
- Use `riverpod_annotation` for auto-generated providers
- Reduces boilerplate
- Type-safe

**Example Providers:**

```dart
// Auto-generated provider
@riverpod
Stream<List<Habit>> habits(HabitsRef ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchHabits();
}

// State notifier for habit completion
class HabitCompletionNotifier extends StateNotifier<AsyncValue<void>> {
  final HabitRepository repository;

  HabitCompletionNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.toggleCompletion(habitId, date);
    });
  }
}

final habitCompletionProvider = StateNotifierProvider<HabitCompletionNotifier, AsyncValue<void>>((ref) {
  return HabitCompletionNotifier(ref.watch(habitRepositoryProvider));
});
```

---

## Data Models

### Hive Type Adapters

All models must have Hive type adapters for local storage.

**Example:**

```dart
import 'package:hive/hive.dart';

part 'habit.g.dart'; // Generated file

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  // ... more fields
}
```

Run `flutter pub run build_runner build` to generate adapters.

### Firestore Data Structure

**Collections:**

```
users/
  {userId}/
    profile: {name, email, createdAt, ...}

habits/
  {habitId}/
    {habit fields}
    userId: {userId}

completions/
  {completionId}/
    habitId: {habitId}
    userId: {userId}
    date: {timestamp}

goals/
  {goalId}/
    {goal fields}
    userId: {userId}

alarms/
  {alarmId}/
    {alarm fields}
    userId: {userId}

focusSessions/
  {sessionId}/
    {session fields}
    userId: {userId}

aiNotifications/
  {notificationId}/
    {notification fields}
    userId: {userId}
```

**Security Rules:**
- Users can only read/write their own data
- Validate data types on write
- Limit query sizes to prevent abuse

---

## Third-Party Integrations

### Firebase Setup

**Services Used:**
1. **Authentication:**
   - Email/password provider
   - Google Sign-In provider
   - Configure OAuth consent screen

2. **Firestore:**
   - Database creation (us-central region recommended)
   - Security rules configuration
   - Indexes for queries

3. **Cloud Storage:**
   - Bucket for profile pictures
   - Security rules (user can only upload to their folder)

4. **Crashlytics:**
   - Automatic crash reporting
   - Integrate with code

5. **Performance Monitoring:**
   - Track app startup time
   - Screen rendering performance
   - Network request performance

**Configuration Files:**
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS, future)

### Google Gemini API Setup

**API Key:**
- Already configured
- Store in environment variables or secure storage
- Never commit to version control

**API Endpoints:**
- Use `google_generative_ai` package
- Endpoint: Gemini 2.5 Flash model
- Request structure: JSON with prompt
- Response parsing: Extract generated text

**Rate Limiting:**
- Cache responses when possible
- Implement retry logic with exponential backoff
- Fallback to pregenerated messages if quota exceeded

**Error Handling:**
- Network errors: Use cached/fallback messages
- API errors: Log and notify user gracefully
- Timeout: Set reasonable timeout (10s)

---

## Platform-Specific Requirements

### Android Requirements

**Minimum SDK:** API 24 (Android 7.0)
**Target SDK:** API 34 (Android 14)

**Permissions (AndroidManifest.xml):**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS"
    tools:ignore="ProtectedPermissions" />
<uses-permission android:name="android.permission.BIND_ACCESSIBILITY_SERVICE"
    tools:ignore="ProtectedPermissions" />
```

**Services:**

```xml
<service
    android:name=".services.AppBlockingAccessibilityService"
    android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
    android:exported="true">
    <intent-filter>
        <action android:name="android.accessibilityservice.AccessibilityService" />
    </intent-filter>
    <meta-data
        android:name="android.accessibilityservice"
        android:resource="@xml/accessibility_service_config" />
</service>

<receiver android:name=".receivers.AlarmReceiver" android:exported="false" />
<receiver android:name=".receivers.BootReceiver" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
    </intent-filter>
</receiver>
```

**Gradle Configuration:**

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    // Firebase
    implementation platform('com.google.firebase:firebase-bom:32.x.x')
    implementation 'com.google.firebase:firebase-auth-ktx'
    implementation 'com.google.firebase:firebase-firestore-ktx'
    implementation 'com.google.firebase:firebase-storage-ktx'
    implementation 'com.google.firebase:firebase-crashlytics-ktx'
    implementation 'com.google.firebase:firebase-analytics-ktx'

    // Play Services (for Google Sign-In)
    implementation 'com.google.android.gms:play-services-auth:20.x.x'
}
```

**ProGuard Rules (for release builds):**
- Preserve Firebase models
- Preserve Hive adapters
- Preserve Gemini API models

---

## UI/UX Implementation Strategy

### Material 3 Theme Setup

**Reference:** See `UI_GUIDELINES.md` for complete specifications

**Key Implementation Points:**

1. **Color Scheme:**
   - Primary: #FF6B35 (StayHard Orange)
   - Use `ColorScheme.fromSeed()` with primary color
   - Support light and dark themes

2. **Typography:**
   - Use `GoogleFonts.interTextTheme()`
   - Define all text styles in theme

3. **Component Themes:**
   - ElevatedButton: 12px radius, no elevation, primary color
   - OutlinedButton: 12px radius, primary border
   - Card: 16px radius, subtle shadow
   - InputDecoration: Filled style, 12px radius

**Theme Implementation:**

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF6B35),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    // ... more component themes
  );

  static ThemeData darkTheme = // ... similar setup with dark colors
}
```

### Responsive Design

**Breakpoints:**
- Small: < 360dp
- Medium: 360-600dp (most phones)
- Large: > 600dp (tablets, future)

**Adaptive Layouts:**
- Use `LayoutBuilder` for responsive padding/sizing
- Adjust font sizes for small screens
- Stack buttons vertically on small screens

### Animation Guidelines

**Standard Durations:**
- Micro-interactions: 100ms (button press)
- Standard transitions: 200-300ms (container changes, navigation)
- Complex animations: 600ms (habit completion, progress rings)
- Hero animations: 1500ms (stats visualizations)

**Curves:**
- `Curves.easeInOut`: General purpose
- `Curves.easeOutCubic`: Deceleration (entering screen)
- `Curves.easeInCubic`: Acceleration (exiting screen)

---

## User Flows & Journeys

### First-Time User Journey

```
1. Install App
   ↓
2. Splash Screen (initialization)
   ↓
3. Welcome Onboarding (3 screens)
   ↓
4. AI Questionnaire (8-10 questions)
   ↓
5. AI Processing & Habit Recommendations
   ↓
6. Select Habits (minimum 3)
   ↓
7. Configure Habits (time, frequency for each)
   ↓
8. Profile Setup (name, picture, preferences)
   ↓
9. Permission Requests (notifications, alarms, accessibility)
   ↓
10. Home Screen (with initial habits)
```

### Daily User Journey

```
Morning:
1. Wake up to alarm with challenge
   ↓
2. Complete challenge to dismiss alarm
   ↓
3. Habit marked complete automatically
   ↓
4. Receive AI motivational notification
   ↓
5. Open app to view today's habits
   ↓
6. Complete morning habits (quick check-off)

Midday:
7. Receive AI reminder about pending habits
   ↓
8. Start focus session to avoid distractions
   ↓
9. Complete work-related habit during focus

Evening:
10. Check progress (stats screen)
   ↓
11. Complete remaining habits
   ↓
12. Review goals progress
   ↓
13. Set alarms for tomorrow
   ↓
14. Receive evening AI motivation
```

### Habit Completion Flow

```
User taps habit completion button
   ↓
Scale animation (100ms)
   ↓
Mark habit as complete (Hive + Firestore)
   ↓
Completion animation (600ms)
   ↓
Check if linked to goal → Update goal progress
   ↓
Check for achievements → Show badge if earned
   ↓
Update stats
   ↓
Trigger sync
```

---

## Development Phases

### Phase 1: Foundation (Weeks 1-2)

**Goals:**
- Set up project structure
- Implement core infrastructure
- Authentication working

**Tasks:**
1. Create Flutter project with proper structure
2. Set up Firebase (already configured, just integrate)
3. Configure Hive database
4. Implement Material 3 theme (based on UI_GUIDELINES.md)
5. Set up Riverpod state management
6. Create reusable widgets (buttons, cards, inputs)
7. Implement splash screen
8. Implement authentication (email/password, Google Sign-In)
9. Basic navigation setup (routing)

**Deliverable:** User can sign up, log in, and see empty home screen

---

### Phase 2: Onboarding & Habits (Weeks 3-4)

**Goals:**
- Complete onboarding flow
- Habit CRUD operations working
- Basic UI for habits

**Tasks:**
1. Build onboarding screens (welcome, questionnaire)
2. Integrate Gemini API for habit matching
3. Create habit templates (20 templates, 5 profiles)
4. Implement habit model and repository
5. Build habit list screen with cards
6. Implement add/edit habit screens
7. Create habit templates bottom sheet
8. Implement habit completion toggle
9. Offline sync for habits

**Deliverable:** Users can complete onboarding, add habits from templates or custom, view habit list, mark habits complete

---

### Phase 3: Alarms & Focus (Weeks 5-6)

**Goals:**
- Alarms with challenges working
- Focus mode with app blocking functional

**Tasks:**
1. Implement alarm model and repository
2. Build alarm list and add/edit screens
3. Integrate `alarm` package for scheduling
4. Create alarm challenge screens (math, typing, custom)
5. Implement background alarm service
6. Handle alarm dismissal and snooze logic
7. Build focus session creation screen
8. Fetch installed apps (platform channel)
9. Create accessibility service for app blocking
10. Implement focus session active screen
11. Focus history and stats

**Deliverable:** Users can set alarms with challenges, alarms trigger reliably, users can create focus sessions that block apps

---

### Phase 4: Goals & Stats (Weeks 7-8)

**Goals:**
- Goal tracking fully functional
- Analytics and statistics screens complete

**Tasks:**
1. Implement goal model and repository
2. Build goal list and add/edit screens
3. Create goal detail page with analytics
4. Implement goal progress calculation
5. Link habits to goals
6. Build stats dashboard
7. Implement charts (habit trends, category breakdown, heatmap)
8. Calculate streaks
9. Create achievements system
10. Build profile screen with settings

**Deliverable:** Users can create goals linked to habits, view detailed analytics, see streaks and achievements

---

### Phase 5: AI Notifications & Polish (Weeks 9-10)

**Goals:**
- AI notifications working
- App polished and ready for testing

**Tasks:**
1. Implement AI notification config model
2. Build AI archetype selection screen
3. Create notification generation service
4. Integrate Gemini for personalized messages
5. Schedule and send AI notifications
6. Build AI insights screen (weekly/monthly reports)
7. Polish all UI screens (animations, micro-interactions)
8. Performance optimization
9. Error handling and edge cases
10. Add loading states and empty states
11. Comprehensive testing (unit, widget, integration)

**Deliverable:** Fully functional app with AI notifications, polished UI, ready for beta testing

---

### Phase 6: Testing & Launch Prep (Weeks 11-12)

**Goals:**
- Bug fixes
- Beta testing
- Prepare for release

**Tasks:**
1. Internal testing (all features)
2. Beta testing with select users
3. Gather feedback and fix critical bugs
4. Optimize performance (app size, startup time, memory)
5. Write user documentation
6. Prepare Play Store assets (screenshots, description, icon)
7. Set up crash reporting and analytics
8. Final security audit
9. Prepare privacy policy and terms of service
10. Submit to Google Play Store

**Deliverable:** App live on Play Store (beta or production)

---

## Testing Strategy

### Unit Tests

**Coverage Areas:**
- Use cases (business logic)
- Utility functions
- Validation logic
- Data models (serialization)

**Tools:**
- `test` package
- `mockito` for mocking dependencies

**Example:**
```dart
test('Habit completion should update completion list', () {
  final habit = Habit(id: '1', name: 'Test');
  final usecase = CompleteHabitUseCase(mockRepository);

  usecase.execute(habit.id, DateTime.now());

  verify(mockRepository.addCompletion(any)).called(1);
});
```

---

### Widget Tests

**Coverage Areas:**
- Individual widgets
- UI interactions
- State changes

**Tools:**
- `flutter_test` package

**Example:**
```dart
testWidgets('Habit card shows completion button', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: HabitCard(habit: testHabit),
    ),
  );

  expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
});
```

---

### Integration Tests

**Coverage Areas:**
- User flows (login → onboarding → habits)
- Database operations
- Navigation

**Tools:**
- `integration_test` package

---

## Performance & Optimization

### Performance Targets

- **Cold Start:** < 2 seconds
- **Warm Start:** < 500ms
- **Screen Transitions:** < 300ms
- **Habit List Rendering:** < 100ms (for 50 habits)
- **Database Operations:** < 50ms (local Hive)
- **App Size:** < 50MB

### Optimization Techniques

1. **Lazy Loading:**
   - Load habits only for current date range
   - Paginate goal/completion lists

2. **Image Optimization:**
   - Compress profile pictures
   - Use cached_network_image
   - Lazy load images

3. **Database Indexing:**
   - Index Firestore queries (habitId, userId, date)
   - Optimize Hive queries

4. **Code Splitting:**
   - Deferred loading for non-critical screens

5. **Build Optimization:**
   - ProGuard/R8 for release builds
   - Remove debug code
   - Tree shaking

---

## Security & Privacy

### Data Privacy

**User Data Collected:**
- Profile information (name, email)
- Habit data (names, times, completions)
- Goal data
- App usage within app (analytics)
- NO personally identifiable information sold or shared

**User Controls:**
- Export all data
- Delete account (permanently delete all data)
- Opt out of analytics

**Privacy Policy:**
- Must be displayed during onboarding
- Link in profile settings
- Comply with GDPR, CCPA

### Security Measures

1. **Authentication:**
   - Firebase Auth (secure by default)
   - Password hashing (handled by Firebase)
   - Email verification (optional)

2. **Data Transmission:**
   - HTTPS only
   - Firestore security rules (user can only access own data)

3. **Local Storage:**
   - Hive encryption (optional, for sensitive data)
   - Secure storage for API keys

4. **API Keys:**
   - Store Gemini API key securely (not in code)
   - Use environment variables or Flutter secure storage

5. **Permissions:**
   - Request permissions only when needed
   - Explain why permissions are needed

---

## Conclusion

This document provides a comprehensive foundation for generating a detailed implementation plan. It covers:

- All feature modules with technical specifications
- Architecture and data flow
- UI/UX implementation based on UI_GUIDELINES.md
- Third-party integrations (Firebase, Gemini)
- Platform-specific requirements (Android)
- Development phases with timelines
- Testing and optimization strategies
- Security and privacy considerations

**Next Steps for Claude:**
1. Use this document to create a step-by-step implementation plan
2. Break down each phase into actionable tasks
3. Provide code examples for critical components
4. Specify exact file paths and structure
5. Include testing instructions for each feature
6. Provide setup guides for Firebase and Gemini integration

---

**Document Version:** 1.0
**Created:** 2025-11-15
**Status:** Ready for Planning
**Author:** Claude (Brainstorming Session)
