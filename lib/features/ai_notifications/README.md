# AI Notification System

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure Gemini API Key
The AI message generator requires a Gemini API key. You'll need to configure this in your environment or pass it when initializing the service.

Example:
```dart
final messageGenerator = AIMessageGenerator(apiKey: 'YOUR_GEMINI_API_KEY');
```

## Features Implemented

### ✅ Phase 1: Foundation
- Data models with Hive adapters (AINotificationConfig, AIArchetype, AIIntensity)
- Repository interfaces and implementations
- Riverpod providers for state management

### ✅ Phase 2: Onboarding Flow
- 5-step AI onboarding modal
- Archetype selection (8 different AI personalities)
- Intensity level selection (Low, Medium, High)
- Permission request integration
- Automatic trigger on first homepage visit (1.5s delay)

### ✅ Phase 3: AI Message Generation
- Gemini API integration via AIMessageGenerator
- Archetype-specific prompts (Drill Sergeant, Wise Mentor, etc.)
- Context-aware message generation
- Fallback messages for offline/error scenarios

### ✅ Phase 4: Context Analysis
- NotificationContextAnalyzer service
- Habit completion tracking
- Streak calculation (current and longest)
- 7-day completion rate analysis

### ✅ Phase 5: Notification UI
- Full-screen notification overlay with animations
- Swipe-to-dismiss gesture
- Auto-dismiss after 60 seconds
- Archetype-specific emojis and styling

## Remaining Work

### ⏳ Phase 6: WorkManager Scheduling
Need to implement:
- Background notification scheduler
- Optimal timing calculation
- Scenario detection (morning, midday, evening)
- Quiet hours enforcement

### ⏳ Phase 7: AI Settings Screen
Need to implement:
- Settings page in profile
- Change archetype
- Adjust intensity
- Configure quiet hours
- View notification statistics

### ⏳ Phase 8: Analytics & History
Need to implement:
- Notification history page
- Engagement metrics tracking
- A/B testing framework

## Architecture

```
lib/features/ai_notifications/
├── data/
│   ├── models/
│   │   ├── ai_notification_config.dart      # Core data models
│   │   └── archetype_details.dart           # UI archetype details
│   └── repositories/
│       └── ai_notification_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── ai_notification_repository.dart
│   └── services/
│       ├── ai_message_generator.dart        # Gemini AI integration
│       └── notification_context_analyzer.dart
└── presentation/
    ├── providers/
    │   └── ai_notification_providers.dart   # Riverpod providers
    └── widgets/
        ├── ai_onboarding_flow.dart          # 5-step onboarding
        └── ai_notification_overlay.dart     # Full-screen notifications
```

## Usage

### Onboarding
The AI onboarding flow will automatically appear 1.5 seconds after a user's first visit to the homepage. Users can:
1. Learn about the AI notification system
2. Select their preferred AI personality (archetype)
3. Choose notification intensity
4. Grant notification permissions

### Displaying Notifications
```dart
await showAINotificationOverlay(
  context: context,
  message: "Your personalized AI message here!",
  archetype: AIArchetype.drillSergeant,
  onViewHabits: () {
    // Navigate to habits page
  },
);
```

### Generating AI Messages
```dart
final generator = AIMessageGenerator(apiKey: 'YOUR_API_KEY');
final context = await analyzer.analyzeContext(
  userId: userId,
  scenario: NotificationScenario.morningMotivation,
);
final message = await generator.generateMessage(
  context: context,
  archetype: AIArchetype.wiseMentor,
  intensity: AIIntensity.medium,
);
```

## Testing

Before production deployment:
1. Test all 8 archetypes with sample messages
2. Verify Gemini API integration with error handling
3. Test notification overlay on different screen sizes
4. Verify Hive persistence and Firestore sync
5. Test onboarding flow completion tracking

## Notes

- The system uses both Hive (local cache) and Firestore (persistence)
- All configuration changes sync to both storage layers
- Notification records are saved to Firestore for analytics
- The AI message generator caches up to 100 messages to reduce API calls
