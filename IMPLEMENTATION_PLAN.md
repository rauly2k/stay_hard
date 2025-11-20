# Implementation Plan: Interactive Heatmap & Enhanced Analytics

## Executive Summary

This document outlines the implementation plan for two main feature enhancements:

1. **Interactive Heatmap Calendar** - Transform the compact heatmap into an interactive component with a popup calendar and day detail view
2. **Analytics Page Enhancements** - Ensure real-time data refresh (already mostly implemented)

---

## Current State Analysis

### Analytics Page Status ✅
The analytics page is **already functioning correctly** with real data:

**Location:** `lib/features/analytics/presentation/pages/analytics_screen.dart`

**Current Features:**
- ✅ Pull-to-refresh implemented (lines 25-34)
- ✅ Auto-refresh on page navigation (Riverpod autoDispose)
- ✅ Real data from Firestore via `analyticsStatsProvider`
- ✅ All 4 overview metrics showing real calculations:
  - **Completion Rate (Last 30 Days):** Calculated from actual habit completions
  - **Current Streak:** Days with 70%+ completion rate
  - **Best Streak:** Historical best streak (365-day lookback)
  - **Total Habits Completed:** Sum of all completions across all habits

**Refresh Behavior:**
- Manual: Pull-to-refresh gesture
- Automatic: On navigation to analytics page
- Invalidates: `analyticsStatsProvider`, `heatmapDataProvider`, `timeOfDayInsightsProvider`

**Data Providers:** `lib/features/analytics/presentation/providers/analytics_providers.dart`
- All calculations are done in real-time from Firestore `habits` collection
- Uses `completionLog` map (date keys → boolean values)
- Considers `RepeatConfig` to determine which days habits should appear

### CompactHeatmap Current Implementation
**Location:** `lib/features/home/presentation/widgets/compact_heatmap.dart`

**Current Features:**
- Shows last 30 days in grid format (7 columns)
- Color-coded by completion rate (red → yellow → green)
- Today highlighted with white background + shadow
- Non-interactive (no tap handlers)
- Data source: `heatmapDataProvider`

**Color Scheme:**
- 0% completion: White with 15% alpha (semi-transparent)
- < 33%: Red with gradient alpha
- 33-67%: Red → Orange → Yellow gradient
- > 67%: Yellow → Green gradient
- Today: Always white with glow

---

## Feature 1: Interactive Heatmap Calendar

### 1.1 Overview

Transform the `CompactHeatmap` widget to open an interactive calendar popup when tapped, showing 30-day detailed view with day-specific habit breakdown.

### 1.2 User Flow

```
User taps CompactHeatmap
    ↓ (ripple effect)
Centered modal dialog appears (semi-fullscreen)
    ↓
Shows 30-day calendar grid (color-coded by completion)
    ↓
User taps a specific day
    ↓
Bottom sheet slides up (calendar remains visible)
    ↓
Shows list of habits for that day (completed ✓ / missed ✗)
    ↓
User can:
  - Close bottom sheet → back to calendar
  - Select another day → bottom sheet updates
  - Tap outside or close button → dismiss entire modal
```

### 1.3 Component Architecture

#### New Files to Create

1. **`lib/features/home/presentation/widgets/calendar_popup_dialog.dart`**
   - Stateful widget for the modal dialog
   - Contains 30-day calendar grid
   - Manages selected day state
   - Handles showing/hiding day detail bottom sheet

2. **`lib/features/home/presentation/widgets/day_detail_bottom_sheet.dart`**
   - Stateless widget for habit list
   - Shows completed/missed habits for selected day
   - Checkmarks for completed, X marks for missed

3. **`lib/features/home/presentation/providers/calendar_popup_providers.dart`**
   - `last30DaysHeatmapProvider` - Pre-calculated data for 30 days
   - `habitsForDayProvider(date)` - Habits scheduled for specific day with completion status

#### Files to Modify

1. **`lib/features/home/presentation/widgets/compact_heatmap.dart`**
   - Add `GestureDetector` wrapper with `onTap` handler
   - Add ripple effect (`InkWell` alternative)
   - Call `showDialog` to display calendar popup

### 1.4 Detailed Implementation Steps

#### Step 1: Make CompactHeatmap Interactive

**File:** `lib/features/home/presentation/widgets/compact_heatmap.dart`

**Changes:**
- Wrap entire heatmap in `GestureDetector` or `InkWell`
- Add `onTap` handler that calls `showDialog`
- Add ripple/splash effect for tap feedback

**Code Approach:**
```dart
// Wrap the SizedBox with InkWell
InkWell(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => const CalendarPopupDialog(),
    );
  },
  borderRadius: BorderRadius.circular(12),
  child: SizedBox(
    height: 200,
    // ... existing heatmap code
  ),
)
```

#### Step 2: Create Calendar Popup Providers

**File:** `lib/features/home/presentation/providers/calendar_popup_providers.dart` (NEW)

**Purpose:** Provide data specifically for the popup calendar

**Providers to Create:**

1. **`last30DaysHeatmapProvider`**
   - Returns `Map<String, double>` for exactly 30 days
   - Pre-calculated completion percentages
   - Similar to `heatmapDataProvider` but scoped to 30 days

2. **`habitsForDayDetailProvider(DateTime date)`**
   - Returns `List<HabitDayDetail>`
   - Each item contains:
     - `habitId`: String
     - `habitName`: String (description)
     - `isCompleted`: bool (from completionLog)
     - `shouldShow`: bool (from RepeatConfig check)

**Data Class:**
```dart
class HabitDayDetail {
  final String habitId;
  final String habitName;
  final bool isCompleted;

  const HabitDayDetail({
    required this.habitId,
    required this.habitName,
    required this.isCompleted,
  });
}
```

**Provider Implementation:**
```dart
final last30DaysHeatmapProvider = Provider.autoDispose<Map<String, double>>((ref) {
  final today = DateTime.now();
  final habitsAsync = ref.watch(habitsForDateProvider(today));

  return habitsAsync.when(
    data: (habits) {
      final heatmapData = <String, double>{};

      for (var i = 0; i < 30; i++) {
        final date = today.subtract(Duration(days: i));
        final dateKey = _formatDateKey(date);

        int totalForDay = 0;
        int completedForDay = 0;

        for (var habit in habits) {
          if (_shouldShowHabitOnDate(habit, date)) {
            totalForDay++;
            if (habit.completionLog[dateKey] == true) {
              completedForDay++;
            }
          }
        }

        if (totalForDay > 0) {
          heatmapData[dateKey] = completedForDay / totalForDay;
        } else {
          // Days with no scheduled habits
          heatmapData[dateKey] = -1.0; // Special value for "no habits"
        }
      }

      return heatmapData;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

final habitsForDayDetailProvider = Provider.autoDispose.family<List<HabitDayDetail>, DateTime>(
  (ref, date) {
    final habitsAsync = ref.watch(habitsForDateProvider(date));
    final dateKey = _formatDateKey(date);

    return habitsAsync.when(
      data: (habits) {
        final habitDetails = <HabitDayDetail>[];

        for (var habit in habits) {
          if (_shouldShowHabitOnDate(habit, date)) {
            habitDetails.add(HabitDayDetail(
              habitId: habit.id,
              habitName: habit.description,
              isCompleted: habit.completionLog[dateKey] == true,
            ));
          }
        }

        return habitDetails;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);
```

#### Step 3: Create Calendar Popup Dialog

**File:** `lib/features/home/presentation/widgets/calendar_popup_dialog.dart` (NEW)

**Widget Structure:**
```
Dialog (centered modal)
├── Container (semi-fullscreen, rounded corners)
│   ├── AppBar (title, close button)
│   ├── 30-day Calendar Grid
│   │   ├── Day of week labels (S M T W T F S)
│   │   ├── GridView of 30 days (7 columns)
│   │   │   └── Day cells (color-coded, tappable)
│   │   └── Legend (Low → High)
│   └── [Conditional] Day Detail Bottom Sheet
└── Barrier (tap outside to dismiss)
```

**Key Features:**
- **Dialog Size:** 90% of screen height, 95% of width
- **Border Radius:** 24px
- **Background:** Theme surface color
- **Close Button:** Top-right corner + tap outside
- **Selected Day State:** Managed with `StatefulWidget`

**State Management:**
```dart
class _CalendarPopupDialogState extends State<CalendarPopupDialog> {
  DateTime? selectedDate;

  void _onDayTapped(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _showDayDetailBottomSheet(date);
  }

  void _showDayDetailBottomSheet(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailBottomSheet(date: date),
    );
  }
}
```

**Color Coding Logic:**
```dart
Color _getDayColor(double completionRate, ThemeData theme) {
  if (completionRate == -1.0) {
    // No habits scheduled - greyed out
    return Colors.grey.withOpacity(0.3);
  } else if (completionRate == 0.0) {
    // 0% completion - red
    return Colors.red.withOpacity(0.7);
  } else if (completionRate < 0.33) {
    // Low completion - red gradient
    return Color.lerp(
      Colors.red.withOpacity(0.7),
      Colors.orange.withOpacity(0.8),
      completionRate / 0.33,
    )!;
  } else if (completionRate < 0.67) {
    // Medium completion - orange to yellow
    final t = (completionRate - 0.33) / 0.34;
    return Color.lerp(
      Colors.orange.withOpacity(0.8),
      Colors.yellow.withOpacity(0.85),
      t,
    )!;
  } else {
    // High completion - yellow to green
    final t = (completionRate - 0.67) / 0.33;
    return Color.lerp(
      Colors.yellow.withOpacity(0.85),
      Colors.green.withOpacity(0.95),
      t,
    )!;
  }
}
```

**Day Cell Widget:**
```dart
Widget _buildDayCell(
  BuildContext context,
  ThemeData theme,
  DateTime date,
  double completionRate,
  bool isToday,
) {
  return GestureDetector(
    onTap: () => _onDayTapped(date),
    child: Container(
      decoration: BoxDecoration(
        color: _getDayColor(completionRate, theme),
        borderRadius: BorderRadius.circular(8),
        border: isToday
          ? Border.all(
              color: Colors.white,
              width: 3,
            )
          : null,
      ),
      child: Center(
        child: Text(
          DateFormat('d').format(date),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isToday
              ? Colors.white
              : completionRate > 0.3
                ? Colors.black.withOpacity(0.8)
                : Colors.white.withOpacity(0.9),
            fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
```

#### Step 4: Create Day Detail Bottom Sheet

**File:** `lib/features/home/presentation/widgets/day_detail_bottom_sheet.dart` (NEW)

**Widget Structure:**
```
Container (rounded top corners)
├── Drag Handle
├── Header
│   ├── Date (e.g., "Monday, Jan 15")
│   └── Summary (e.g., "4/5 habits completed")
├── Divider
└── Habit List (ListView)
    └── For each habit:
        ├── Row
        │   ├── Icon (✓ green or ✗ red)
        │   └── Habit Name
```

**Key Features:**
- **Height:** Max 60% of screen height
- **Scrollable:** If many habits
- **Drag to dismiss:** Default ModalBottomSheet behavior
- **Auto-update:** When user selects different day

**Implementation:**
```dart
class DayDetailBottomSheet extends ConsumerWidget {
  final DateTime date;

  const DayDetailBottomSheet({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitDetails = ref.watch(habitsForDayDetailProvider(date));

    final completedCount = habitDetails.where((h) => h.isCompleted).length;
    final totalCount = habitDetails.length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(date),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedCount/$totalCount habits completed',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Habit List
          Flexible(
            child: habitDetails.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No habits scheduled for this day',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: habitDetails.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final habit = habitDetails[index];
                    return _HabitListItem(habit: habit);
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class _HabitListItem extends StatelessWidget {
  final HabitDayDetail habit;

  const _HabitListItem({required this.habit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Icon
        Icon(
          habit.isCompleted ? Icons.check_circle : Icons.cancel,
          color: habit.isCompleted
            ? Colors.green
            : Colors.red,
          size: 24,
        ),
        const SizedBox(width: 12),

        // Habit name
        Expanded(
          child: Text(
            habit.habitName,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
```

### 1.5 Testing Checklist

#### Visual & Interaction Testing
- [ ] CompactHeatmap shows ripple effect on tap
- [ ] Modal dialog appears centered on screen
- [ ] Dialog is dismissible by tapping outside
- [ ] Dialog is dismissible by tapping close button
- [ ] Calendar shows exactly 30 days in correct grid layout
- [ ] Today is highlighted with white border
- [ ] Color coding matches specification:
  - [ ] Grey for days with no habits
  - [ ] Red for 0% completion
  - [ ] Red→Yellow→Green gradient for increasing completion
- [ ] Tapping a day shows bottom sheet
- [ ] Bottom sheet displays correct date
- [ ] Bottom sheet shows correct habits list
- [ ] Completed habits show green checkmark
- [ ] Missed habits show red X
- [ ] Bottom sheet is dismissible by dragging down
- [ ] Bottom sheet is dismissible by tapping outside
- [ ] Selecting different day updates bottom sheet content
- [ ] Bottom sheet can be closed and reopened multiple times

#### Data Accuracy Testing
- [ ] Completion percentages match actual habit data
- [ ] Days with no habits are correctly identified
- [ ] Habit list shows only habits scheduled for that day
- [ ] Completion status reflects actual Firestore data
- [ ] RepeatConfig correctly filters habits (daily, specific days, intervals)

#### Edge Cases
- [ ] Works correctly with 0 habits
- [ ] Works correctly with 1 habit
- [ ] Works correctly with many habits (scrolling)
- [ ] Handles future dates correctly (should show in calendar but with appropriate handling)
- [ ] Handles dates before user's first habit
- [ ] Performance is acceptable with large habit lists

---

## Feature 2: Analytics Page Real Data

### 2.1 Current Implementation Analysis

**Good News:** The analytics page is **already working correctly!**

**Location:** `lib/features/analytics/presentation/pages/analytics_screen.dart`

**Existing Implementation (lines 25-34):**
```dart
RefreshIndicator(
  onRefresh: () async {
    // Invalidate all analytics providers to force recalculation
    ref.invalidate(analyticsStatsProvider);
    ref.invalidate(heatmapDataProvider);
    ref.invalidate(timeOfDayInsightsProvider);
    ref.invalidate(habitsForDateProvider(today));
    // Small delay to ensure data is refreshed
    await Future.delayed(const Duration(milliseconds: 100));
  },
  child: SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    // ... content
  ),
)
```

**Data Flow:**
1. User pulls down → `onRefresh` called
2. All providers invalidated → Forces re-fetch from Firestore
3. New data streamed from Firestore
4. Providers recalculate metrics
5. UI rebuilds with fresh data

**Auto-Refresh Behavior:**
- Navigating to analytics page → Providers auto-refresh (Riverpod's `autoDispose`)
- Riverpod StreamProviders listen to Firestore snapshots → Real-time updates

### 2.2 Verification of Real Data

All 4 metrics are calculated from actual Firestore data:

#### Metric 1: Completion Rate (Last 30 Days)
**Provider:** `analyticsStatsProvider`
**Calculation:** Lines 26-45 in analytics_providers.dart

```dart
// Iterates through last 30 days
for (var i = 0; i < 30; i++) {
  final date = today.subtract(Duration(days: i));
  if (_shouldShowHabitOnDate(habit, date)) {
    totalPossibleCompletions++;
    final dateKey = _formatDateKey(date);
    if (habit.completionLog[dateKey] == true) {
      actualCompletions++;
    }
  }
}

final completionRate = (actualCompletions / totalPossibleCompletions * 100).round();
```

**Data Source:** `habit.completionLog` map from Firestore

#### Metric 2: Current Streak
**Provider:** `analyticsStatsProvider`
**Calculation:** Lines 358-389 in analytics_providers.dart

```dart
int _calculateCurrentStreak(List<Habit> habits, DateTime today) {
  int streak = 0;
  DateTime checkDate = today;

  while (true) {
    int totalForDay = 0;
    int completedForDay = 0;

    for (var habit in habits) {
      if (_shouldShowHabitOnDate(habit, checkDate)) {
        totalForDay++;
        final dateKey = _formatDateKey(checkDate);
        if (habit.completionLog[dateKey] == true) {
          completedForDay++;
        }
      }
    }

    // Check if at least 70% of habits were completed
    if (totalForDay > 0 && (completedForDay / totalForDay) >= 0.7) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
}
```

**Logic:** Consecutive days with ≥70% habit completion
**Data Source:** `habit.completionLog` map from Firestore

#### Metric 3: Best Streak
**Provider:** `analyticsStatsProvider`
**Calculation:** Lines 391-422 in analytics_providers.dart

```dart
int _calculateBestStreak(List<Habit> habits, DateTime today) {
  int bestStreak = 0;
  int currentStreak = 0;

  // Check last 365 days
  for (var i = 0; i < 365; i++) {
    final checkDate = today.subtract(Duration(days: i));
    // ... calculate completion for day

    if (totalForDay > 0 && (completedForDay / totalForDay) >= 0.7) {
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    } else {
      currentStreak = 0;
    }
  }

  return bestStreak;
}
```

**Logic:** Best consecutive days (70%+ completion) in last 365 days
**Data Source:** `habit.completionLog` map from Firestore

#### Metric 4: Total Habits Completed
**Provider:** `analyticsStatsProvider`
**Calculation:** Lines 53-57 in analytics_providers.dart

```dart
int totalCompleted = 0;
for (var habit in habits) {
  totalCompleted += habit.completionLog.values.where((v) => v).length;
}
```

**Logic:** Sum of all `true` values in all habits' completionLog
**Data Source:** `habit.completionLog` map from Firestore

### 2.3 Recommended Enhancements (Optional)

While the current implementation is functional, consider these improvements:

#### Enhancement 1: Loading State Indicator

**Problem:** User doesn't see visual feedback during refresh
**Solution:** Add shimmer loading or progress indicator

**File:** `lib/features/analytics/presentation/pages/analytics_screen.dart`

**Implementation:**
```dart
final stats = ref.watch(analyticsStatsProvider);

// Wrap _MetricCard widgets with AsyncValue handling
stats.when(
  data: (data) => _MetricCard(
    icon: Icons.percent,
    label: 'Completion Rate',
    value: '${data.completionRateLast30Days}%',
    subtitle: 'Last 30 days',
    color: theme.colorScheme.primary,
  ),
  loading: () => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  error: (error, stack) => _MetricCard(
    icon: Icons.error,
    label: 'Error',
    value: '—',
    subtitle: 'Tap to retry',
    color: Colors.red,
  ),
);
```

#### Enhancement 2: Refresh Timestamp

**Purpose:** Show when data was last updated

**Implementation:**
```dart
// Add state variable
DateTime? lastRefreshTime;

// Update in onRefresh
onRefresh: () async {
  ref.invalidate(analyticsStatsProvider);
  // ... other invalidations
  await Future.delayed(const Duration(milliseconds: 100));
  setState(() {
    lastRefreshTime = DateTime.now();
  });
},

// Display in UI
Text(
  lastRefreshTime != null
    ? 'Updated ${_formatTimeAgo(lastRefreshTime!)}'
    : '',
  style: theme.textTheme.bodySmall,
)
```

#### Enhancement 3: Error Handling with Retry

**Purpose:** Handle Firestore errors gracefully

**Implementation:**
```dart
// In providers, add better error handling
return habitsAsync.when(
  data: (habits) {
    // ... calculation logic
  },
  loading: () => AnalyticsStats(
    completionRateLast30Days: 0,
    currentStreak: 0,
    bestStreak: 0,
    totalHabitsCompleted: 0,
  ),
  error: (error, stack) {
    // Log error for debugging
    debugPrint('Analytics error: $error');

    // Return default values
    return AnalyticsStats(
      completionRateLast30Days: 0,
      currentStreak: 0,
      bestStreak: 0,
      totalHabitsCompleted: 0,
    );
  },
);
```

### 2.4 No Changes Required

**Conclusion:** The analytics page already meets all requirements:
- ✅ Pull-to-refresh implemented
- ✅ Auto-refresh on navigation
- ✅ Real data from Firestore
- ✅ All 4 metrics showing accurate calculations

**Action:** No implementation needed unless optional enhancements are desired.

---

## Implementation Timeline

### Phase 1: Calendar Popup Foundation (2-3 hours)
1. Create `calendar_popup_providers.dart` with data providers
2. Create `calendar_popup_dialog.dart` with basic modal structure
3. Make `CompactHeatmap` tappable with dialog trigger
4. Test basic popup open/close behavior

### Phase 2: Calendar Grid & Styling (2-3 hours)
1. Implement 30-day calendar grid layout
2. Add color coding logic matching spec
3. Add day of week labels and legend
4. Add today highlight (white border)
5. Test color accuracy and grid layout

### Phase 3: Day Detail Bottom Sheet (2 hours)
1. Create `day_detail_bottom_sheet.dart`
2. Implement habit list display
3. Add checkmark/X icons for completion status
4. Test bottom sheet interaction
5. Test data accuracy

### Phase 4: Integration & Polish (1-2 hours)
1. Connect calendar tap to bottom sheet
2. Add close button to dialog
3. Add ripple effect to heatmap
4. Test full user flow
5. Handle edge cases (no habits, etc.)

### Phase 5: Analytics Enhancements (Optional, 1-2 hours)
1. Add loading state indicators
2. Add refresh timestamp
3. Improve error handling
4. Test refresh behavior

**Total Estimated Time:** 8-12 hours (core features only)

---

## File Structure Summary

### New Files
```
lib/features/home/presentation/
├── providers/
│   └── calendar_popup_providers.dart      # NEW - Data for popup calendar
└── widgets/
    ├── calendar_popup_dialog.dart         # NEW - Modal with 30-day calendar
    └── day_detail_bottom_sheet.dart       # NEW - Habit list for selected day
```

### Modified Files
```
lib/features/home/presentation/widgets/
└── compact_heatmap.dart                   # MODIFY - Add tap handler
```

### No Changes Required
```
lib/features/analytics/presentation/
├── pages/
│   └── analytics_screen.dart              # Already has refresh ✅
└── providers/
    └── analytics_providers.dart           # Already has real data ✅
```

---

## Dependencies

### Required Packages (Already in pubspec.yaml)
- ✅ `flutter_riverpod: ^3.0.3` - State management
- ✅ `cloud_firestore: ^5.7.1` - Data source
- ✅ `intl: ^0.19.0` - Date formatting

### No Additional Dependencies Needed

---

## Testing Strategy

### Unit Tests
```dart
// Test providers
test('last30DaysHeatmapProvider returns 30 days of data', () {
  // ...
});

test('habitsForDayDetailProvider filters by RepeatConfig', () {
  // ...
});
```

### Widget Tests
```dart
// Test CompactHeatmap interaction
testWidgets('CompactHeatmap opens dialog on tap', (tester) async {
  // ...
});

// Test CalendarPopupDialog
testWidgets('CalendarPopupDialog shows 30 days', (tester) async {
  // ...
});

// Test DayDetailBottomSheet
testWidgets('DayDetailBottomSheet shows habits for date', (tester) async {
  // ...
});
```

### Integration Tests
```dart
// Test full user flow
testWidgets('Full calendar popup flow', (tester) async {
  // 1. Tap heatmap
  // 2. Verify dialog appears
  // 3. Tap a day
  // 4. Verify bottom sheet appears
  // 5. Verify habit list is correct
});
```

---

## Risk Mitigation

### Potential Issues & Solutions

1. **Performance with Large Habit Lists**
   - **Risk:** Slow rendering of day detail bottom sheet
   - **Solution:** Use `ListView.builder` for lazy loading
   - **Solution:** Limit habit description length with ellipsis

2. **State Management Complexity**
   - **Risk:** Selected day state not updating correctly
   - **Solution:** Use `StatefulWidget` for dialog, keep bottom sheet stateless
   - **Solution:** Pass date as parameter to bottom sheet

3. **Color Accuracy**
   - **Risk:** Color coding doesn't match user's existing color scheme
   - **Solution:** Reference existing color scheme from `compact_heatmap.dart`
   - **Solution:** Test with various completion percentages

4. **Bottom Sheet Overlap**
   - **Risk:** Bottom sheet covers important calendar dates
   - **Solution:** Limit bottom sheet to 60% max height
   - **Solution:** Make bottom sheet dismissible

5. **Data Freshness**
   - **Risk:** Popup shows stale data
   - **Solution:** Use `autoDispose` providers
   - **Solution:** Re-fetch on dialog open

---

## Success Criteria

### Feature 1: Interactive Heatmap
- [ ] CompactHeatmap is tappable with visual feedback
- [ ] Modal dialog appears centered and semi-fullscreen
- [ ] Calendar shows exactly last 30 days
- [ ] Color coding matches specification (grey/red/yellow/green)
- [ ] Today is visually distinct (white border)
- [ ] Tapping a day shows bottom sheet
- [ ] Bottom sheet shows correct habits with completion status
- [ ] User can navigate between days
- [ ] All dismissal methods work (close button, tap outside, drag down)

### Feature 2: Analytics Real Data
- [ ] Pull-to-refresh works smoothly
- [ ] Auto-refresh on navigation works
- [ ] All 4 metrics show real data from Firestore
- [ ] Data updates reflect in UI immediately
- [ ] No placeholder/mock data visible

---

## Code Quality Standards

### Consistency
- Follow existing code style from `compact_heatmap.dart`
- Use same color scheme and theme system
- Match existing widget naming conventions

### Documentation
- Add dartdoc comments for all public methods
- Document provider purposes and return types
- Add inline comments for complex calculations

### Error Handling
- Handle `AsyncValue` states (data, loading, error)
- Provide fallback UI for error states
- Log errors for debugging

### Accessibility
- Add semantic labels for icons
- Ensure sufficient color contrast
- Support screen readers

---

## Appendix

### A. Data Model Reference

**Habit Model** (`lib/shared/data/models/habit_model.dart`)
```dart
class Habit {
  final String id;
  final String userId;
  final String templateId;
  final String description;              // Display name
  final RepeatConfig repeatConfig;        // Daily, specific days, or interval
  final Map<String, bool> completionLog;  // "YYYY-MM-DD" -> true/false
  final DateTime createdAt;
  final bool isActive;
  // ... other fields
}
```

**RepeatConfig Types:**
- `isDaily: true` - Shows every day
- `specificDays: [1,3,5]` - Shows on Mon, Wed, Fri (1-7 = Mon-Sun)
- `intervalDays: 3` - Shows every 3 days from createdAt

### B. Color Scheme Reference

**From CompactHeatmap (lines 134-152):**
```dart
if (value == 0.0) {
  backgroundColor = Colors.white.withOpacity(0.15);  // No completion
} else if (value < 0.33) {
  backgroundColor = Colors.red.withOpacity(0.6 + (value * 0.3));  // Low
} else if (value < 0.67) {
  // Red → Orange → Yellow gradient
  backgroundColor = Color.lerp(
    Colors.orange.withOpacity(0.75),
    Colors.yellow.withOpacity(0.85),
    (value - 0.33) / 0.34,
  )!;
} else {
  // Yellow → Green gradient
  backgroundColor = Color.lerp(
    Colors.yellow.withOpacity(0.85),
    Colors.green.withOpacity(0.95),
    (value - 0.67) / 0.33,
  )!;
}
```

**New Requirement for Popup:**
- **0% completion (value = 0.0):** Red
- **No habits scheduled (value = -1.0):** Grey (new case)
- **Positive completion:** Same gradient as above

### C. Provider Helper Functions

These helper functions are already defined in `analytics_providers.dart` and should be reused:

```dart
String _formatDateKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
  final config = habit.repeatConfig;

  if (config.isDaily) {
    return true;
  }

  if (config.specificDays != null && config.specificDays!.isNotEmpty) {
    return config.specificDays!.contains(date.weekday);
  }

  if (config.intervalDays != null) {
    final daysSinceCreation = date.difference(habit.createdAt).inDays;
    return daysSinceCreation % config.intervalDays! == 0;
  }

  return true;
}
```

---

## Conclusion

This implementation plan provides a comprehensive roadmap for:
1. ✅ Adding interactive calendar popup to CompactHeatmap
2. ✅ Creating day detail view with habit breakdown
3. ✅ Confirming analytics page already has real-time data refresh

The analytics page requires **no changes** as it already meets all requirements. The interactive heatmap feature can be implemented in phases with clear testing checkpoints.

**Next Steps:**
1. Review and approve this plan
2. Begin Phase 1: Calendar Popup Foundation
3. Test incrementally after each phase
4. Deploy after all tests pass

---

**Document Version:** 1.0
**Last Updated:** 2025-11-20
**Author:** Claude Code Analysis
**Status:** Ready for Implementation
