# Focus Feature Fixes and Enhancements

## Summary
This update fixes the app blocking issue and adds a new time-limited app usage feature to the Focus tab.

## Issues Fixed

### 1. App Blocking Not Working Properly
**Problem**: When users opened a blocked app, the blocking overlay appeared once but users could dismiss it and return to the blocked app without being blocked again.

**Solution**:
- Improved the `AppBlockingAccessibilityService` to continuously monitor and re-trigger blocking
- Enhanced the `BlockingOverlayActivity` to properly handle user dismissal
- The accessibility service now re-blocks the app each time the user tries to access it during an active session
- Added better package name filtering to avoid blocking the app itself

**Files Modified**:
- `android/app/src/main/kotlin/com/example/stay_hard/services/AppBlockingAccessibilityService.kt`
- `android/app/src/main/kotlin/com/example/stay_hard/activities/BlockingOverlayActivity.kt`

### 2. Missing Time-Limited App Usage Feature
**Problem**: The Focus feature only supported complete app blocking during sessions. There was no way to set daily time limits for specific apps (e.g., "allow Instagram for 60 minutes per day").

**Solution**: Implemented a comprehensive app time limits system with:

#### New Features:
1. **App Time Limits Configuration**
   - Set daily time limits for any installed app
   - Configurable hours and minutes (e.g., 1h 30m)
   - Enable/disable limits individually
   - Edit or delete existing limits

2. **Usage Tracking**
   - Real-time tracking of app usage throughout the day
   - Automatic sync with Android's UsageStatsManager
   - Usage data stored in Firestore for historical analysis
   - Automatic daily reset at midnight

3. **Automatic Blocking**
   - Apps are automatically blocked when daily limit is reached
   - Background service monitors usage every 30 seconds
   - Blocking persists until the next day
   - Visual progress indicators show remaining time

4. **User Interface**
   - New "App Time Limits" button in Focus screen (timer icon)
   - List view showing all configured limits
   - Real-time usage statistics per app
   - Progress bars showing usage vs limit
   - Add/Edit dialog with app selector and time picker

#### Technical Implementation:

**New Data Models** (`focus_session_model.dart`):
- `AppTimeLimit` - Configuration for daily app time limits
- `AppUsageRecord` - Tracks daily usage per app

**New Repository** (`app_time_limit_repository.dart`):
- CRUD operations for time limits
- Usage record management
- Daily limit checking
- Firestore integration

**New Service** (`app_usage_tracking_service.dart`):
- Background monitoring with 30-second intervals
- Integration with Android UsageStatsManager
- Automatic blocking enforcement
- Usage data synchronization

**New Android Methods** (`MainActivity.kt`):
- `getAppUsageToday(packageName)` - Get usage for specific app
- `getAllAppUsageToday()` - Get usage for all apps
- Uses Android's UsageStatsManager API

**New UI** (`app_time_limits_page.dart`):
- App time limits list with usage stats
- Add/Edit dialog
- Real-time usage tracking display
- Enable/disable toggles

**New Providers** (`time_limit_providers.dart`):
- `appTimeLimitRepositoryProvider`
- `appUsageTrackingServiceProvider`
- `appTimeLimitsProvider` (stream)
- `timeLimitNotifierProvider`

**Integration** (`focus_screen.dart`):
- Added timer icon button in app bar
- Navigates to App Time Limits page

## Usage Instructions

### For Focus Sessions (Existing Feature - Now Fixed):
1. Go to Focus tab
2. Create a new focus session
3. Select apps to block
4. Start the session
5. **Fixed**: Blocked apps now stay blocked even if you try to access them multiple times

### For App Time Limits (New Feature):
1. Go to Focus tab
2. Tap the timer icon in the top right
3. Tap "Add Time Limit" or the + button
4. Select an app from the dropdown
5. Set hours and minutes for daily limit
6. Tap "Save"
7. The app will be automatically blocked when the limit is reached
8. Limits reset daily at midnight

### Required Permissions:
- **Accessibility Service** - Required for app blocking (both features)
- **Usage Stats** - Required for time tracking (new feature)
  - Navigate to Settings > Apps > Special app access > Usage access
  - Enable for StayHard app

## Database Collections

### Existing:
- `focusSessions` - Focus session records

### New:
- `appTimeLimits` - Time limit configurations
- `appUsageRecords` - Daily usage tracking

## Testing Checklist

- [ ] Enable Accessibility Service
- [ ] Enable Usage Stats permission
- [ ] Create a focus session and verify blocking works persistently
- [ ] Add a time limit for an app (e.g., Instagram: 5 minutes)
- [ ] Use the app and verify usage tracking
- [ ] Verify app gets blocked when limit is reached
- [ ] Verify limit resets the next day
- [ ] Test enable/disable toggle
- [ ] Test edit time limit
- [ ] Test delete time limit

## Technical Notes

- The usage tracking service runs in the background with 30-second check intervals
- Usage data syncs to Firestore every check
- Old usage records (>30 days) can be cleaned up via repository method
- Time limits and focus sessions work independently
- Both features use the same accessibility service for blocking
- Android-only implementation (iOS not supported)

## Future Enhancements

- Weekly/monthly usage statistics
- Smart scheduling (e.g., "block during work hours")
- App categories for bulk time limits
- Notifications when approaching limit
- Break reminders
- Export usage reports
