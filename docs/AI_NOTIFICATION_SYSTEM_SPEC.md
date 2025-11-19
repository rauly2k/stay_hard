# AI Notification System - Implementation Specification

## Overview
This document outlines the comprehensive AI notification system for the Stay Hard habit tracking application. The system provides intelligent interventions to keep users motivated, engaged, and successful in building their habits.

---

## 1. AI Notification Intervention System

### 1.1 Notification Triggers & Categories

The system implements **7 distinct intervention categories**, each with specific triggers:

#### **1. Morning Motivation**
- **Trigger**: Daily at user's preferred morning time (configurable in settings)
- **Purpose**: Start the day with inspirational AI-generated motivation
- **Frequency**: Once per day (morning slot)
- **Context**: Uses user's active habits, current streaks, and selected AI style

#### **2. Missed Habit Recovery**
- **Trigger**: When user hasn't completed a habit for 2+ consecutive days
- **Purpose**: Gentle nudge to get back on track without guilt
- **Frequency**: Maximum once per missed habit per day
- **Context**: References specific missed habits, offers supportive comeback messaging

#### **3. Low Morale Boost**
- **Trigger**: When completion rate drops below 40% in the last 7 days
- **Purpose**: Detect struggling patterns and provide encouragement
- **Frequency**: Maximum twice per week
- **Context**: Analyzes patterns, focuses on small wins and progress made

#### **4. Streak Celebration**
- **Trigger**: When user reaches milestone streaks (7, 14, 30, 60, 100, 365 days)
- **Purpose**: Celebrate achievements and reinforce positive behavior
- **Frequency**: On milestone completion only
- **Context**: Highlights specific habit streaks, celebrates consistency

#### **5. Evening Check-in**
- **Trigger**: Daily at user's preferred evening time (configurable in settings)
- **Purpose**: Reflect on the day, plan for tomorrow
- **Frequency**: Once per day (evening slot)
- **Context**: Summarizes day's completions, gentle reminder for incomplete habits

#### **6. Comeback Support**
- **Trigger**: When user returns to app after 7+ days of inactivity
- **Purpose**: Welcome back without judgment, help restart habits
- **Frequency**: Once per return period
- **Context**: Emphasizes fresh start, removes pressure of broken streaks

#### **7. Progress Insights**
- **Trigger**: Weekly (every Sunday evening) or monthly (last day of month)
- **Purpose**: AI analysis of habit patterns, trends, and personalized tips
- **Frequency**: Weekly or monthly based on user preference
- **Context**: Data-driven insights, suggestions for improvement

---

## 2. Habit Completion Feedback System

### 2.1 Feedback Strategy
The app uses a **smart hybrid approach** for post-completion feedback:

#### **Milestone-Based Feedback**
When user completes a habit and reaches a milestone:
- Show celebratory AI-generated message
- Visual confetti/animation effect
- Emphasis on streak number and achievement

#### **Smart Detection Feedback**
AI determines when user needs encouragement based on:
- Recent completion patterns (struggling habits get more encouragement)
- Time of day (evening completions get extra praise)
- Comeback after missed days (special supportive messaging)

#### **Daily Check-in Integration**
- Morning motivational notifications set positive tone
- Evening check-ins provide reflection and encouragement
- Keeps user inspired during consistent habit building, not just difficult times

### 2.2 UI Implementation
```
On Habit Completion:
1. Standard checkmark animation (always)
2. IF milestone OR smart detection triggered:
   - Show AI-generated motivational card
   - Card appears for 3-4 seconds with dismiss option
   - Card content matches user's selected AI style
3. Update streak counter with animation
```

---

## 3. Profile Menu Structure

### 3.1 Profile Icon (Top Right) - Dropdown Menu

When user taps profile icon, show dropdown menu with:

```
┌─────────────────────────────────┐
│ [User Avatar] John Doe          │
│ john@example.com                │
├─────────────────────────────────┤
│ 👤 Profile                      │
│ ⚙️  Settings                    │
│ 🔔 AI Notifications             │  ← Prominent position
│ 💳 Subscription                 │
│ 📊 Statistics & Analytics       │
│ ❓ Help & Support               │
│ 🔒 About & Privacy              │
├─────────────────────────────────┤
│ 🚪 Logout                       │
└─────────────────────────────────┘
```

### 3.2 Menu Items Explained

#### **Profile**
- View/edit personal information
- Change avatar
- Display name, email, join date

#### **Settings**
- General app settings
- Theme preferences (dark/light mode)
- Language selection
- Data management

#### **AI Notifications** ⭐
- **Prominent top-level menu item**
- Quick enable/disable toggle
- Access to detailed notification settings
- Link to Testing Page (see Section 4)

#### **Subscription**
- Current plan details
- Upgrade/downgrade options
- Billing history
- Payment method management

#### **Statistics & Analytics**
- Detailed habit completion data
- Graphs and charts
- Streaks overview
- Personal records

#### **Help & Support**
- FAQs
- Tutorial videos
- Contact support form
- Community forum link

#### **About & Privacy**
- App version information
- Terms of service
- Privacy policy
- Data handling information
- Licenses

---

## 4. AI Notifications Settings Page

### 4.1 Page Structure

```
AI Notifications Settings
═════════════════════════════════

┌─ Master Controls ─────────────┐
│ [ ✓ ] Enable AI Notifications │
│                                │
│ AI Style: [Supportive] ▼       │
│ (Note: Set in main Settings)   │
└────────────────────────────────┘

┌─ Notification Preferences ────┐
│ Daily Notification Limit       │
│ [3] notifications per day      │
│                                │
│ Quiet Hours                    │
│ From: [22:00] To: [07:00]      │
└────────────────────────────────┘

┌─ Intervention Categories ─────┐
│ [ ✓ ] Morning Motivation       │
│       Time: [08:00] [Edit]     │
│                                │
│ [ ✓ ] Evening Check-in         │
│       Time: [20:00] [Edit]     │
│                                │
│ [ ✓ ] Missed Habit Recovery    │
│       Trigger after: [2] days  │
│                                │
│ [ ✓ ] Low Morale Boost         │
│       Sensitivity: [Medium] ▼  │
│                                │
│ [ ✓ ] Streak Celebrations      │
│       Milestones: [7,30,100]   │
│                                │
│ [ ✓ ] Comeback Support         │
│       After [7] days away      │
│                                │
│ [ ✓ ] Progress Insights        │
│       Frequency: [Weekly] ▼    │
└────────────────────────────────┘

┌─ Testing & Preview ───────────┐
│ [🧪 Test Notifications]        │
│                                │
│ Preview how different          │
│ interventions will look        │
└────────────────────────────────┘

[Save Changes]
```

### 4.2 Setting Details

#### **Master Toggle**
- Global on/off switch for all AI notifications
- When off, user still gets system notifications (reminders they set manually)

#### **Daily Limit Cap**
- Adjustable: 1-10 notifications per day
- Prevents notification fatigue
- Smart system prioritizes most relevant notifications if limit reached

#### **Quiet Hours**
- No AI notifications during set hours
- Typically sleep hours (22:00 - 07:00)
- Can customize start/end times

#### **Per-Category Controls**
Each intervention category has:
- Enable/disable toggle
- Category-specific settings (time, frequency, sensitivity)
- Description tooltip explaining when it triggers

---

## 5. AI Notification Testing Page

### 5.1 Purpose
Allow users to preview and test different AI notification interventions before they occur naturally. Helps users:
- Understand what each notification type looks like
- Verify their selected AI style is working as expected
- Adjust settings based on actual examples
- Ensure notifications feel motivating, not annoying

### 5.2 Page Layout

```
🧪 Test AI Notifications
═════════════════════════════════

Current AI Style: [Supportive] ▼
Habit Context: [Using your actual habits]

┌─ Intervention Types ──────────┐
│                                │
│ 🌅 Morning Motivation          │
│ Start your day with AI-        │
│ generated inspiration          │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 🔄 Missed Habit Recovery       │
│ See how we help you get        │
│ back on track                  │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 📉 Low Morale Boost            │
│ Encouragement during           │
│ tough times                    │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 🏆 Streak Celebration          │
│ Celebrate your milestones      │
│ Milestone: [7 days] ▼          │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 🌙 Evening Check-in            │
│ Reflect on your day            │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 🚀 Comeback Support            │
│ Welcome back after time        │
│ away from the app              │
│ [Generate & Send Test]         │
│                                │
├────────────────────────────────┤
│ 📊 Progress Insights           │
│ Weekly habit analysis and      │
│ personalized tips              │
│ [Generate & Send Test]         │
│                                │
└────────────────────────────────┘

[Back to Settings]
```

### 5.3 Testing Behavior

When user presses **[Generate & Send Test]** button:

1. **Real AI Generation**: System calls actual AI service with:
   - Selected AI style (Supportive, Direct, Humorous, etc.)
   - User's actual habit data for context
   - Specific intervention category prompt
   - User's name and personalization data

2. **Notification Delivery**:
   - Generates notification in real-time
   - Sends actual push notification to device
   - Displays notification preview in-app simultaneously

3. **Loading State**:
   - Button shows "Generating..." with spinner
   - Takes 2-5 seconds for AI generation
   - Then "Sent!" confirmation with checkmark

4. **Rate Limiting**:
   - Maximum 3 test notifications per minute
   - Prevents abuse of AI service
   - Shows cooldown timer if limit reached

### 5.4 Contextual Testing

For **Streak Celebration** category:
- Dropdown to select milestone (7, 14, 30, 60, 100 days)
- AI generates appropriate celebration for that milestone

For **Progress Insights**:
- Uses actual user data from past week/month
- Generates real insights, not mock data

---

## 6. Technical Implementation Requirements

### 6.1 Database Schema Additions

```sql
-- User notification preferences
CREATE TABLE user_notification_preferences (
  user_id UUID PRIMARY KEY,
  enabled BOOLEAN DEFAULT true,
  daily_limit INTEGER DEFAULT 5,
  quiet_hours_start TIME DEFAULT '22:00',
  quiet_hours_end TIME DEFAULT '07:00',
  morning_time TIME DEFAULT '08:00',
  evening_time TIME DEFAULT '20:00',
  updated_at TIMESTAMP
);

-- Per-category preferences
CREATE TABLE notification_category_preferences (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  category VARCHAR(50), -- 'morning_motivation', 'missed_habit', etc.
  enabled BOOLEAN DEFAULT true,
  custom_settings JSONB, -- Category-specific settings
  created_at TIMESTAMP
);

-- Notification history (for analytics & limiting)
CREATE TABLE notification_history (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  category VARCHAR(50),
  sent_at TIMESTAMP,
  was_opened BOOLEAN DEFAULT false,
  was_dismissed BOOLEAN DEFAULT false
);

-- Test notifications log
CREATE TABLE test_notifications_log (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  category VARCHAR(50),
  generated_at TIMESTAMP,
  ai_style VARCHAR(50)
);
```

### 6.2 Backend Services Required

#### **NotificationTriggerService**
- Runs scheduled checks (cron jobs)
- Evaluates user states against intervention triggers
- Respects quiet hours, daily limits
- Prioritizes notifications if limit would be exceeded

#### **AIGenerationService**
- Interfaces with AI API (existing in project)
- Generates context-aware notification content
- Uses user's selected AI style
- Handles retries and fallbacks

#### **NotificationDeliveryService**
- Sends push notifications via FCM/APNs
- Tracks delivery status
- Handles notification actions (opened, dismissed)

#### **AnalyticsService**
- Tracks notification effectiveness
- Identifies which interventions work best per user
- Provides data for Progress Insights category

### 6.3 Frontend Components

#### **ProfileMenuDropdown** (New)
- Animated dropdown from top-right profile icon
- Menu items with icons and navigation

#### **AINotificationsSettingsPage** (New)
- Form with toggles, time pickers, sliders
- Real-time validation
- Persistent settings save

#### **NotificationTestingPage** (New)
- Card-based layout for each intervention type
- Test buttons with loading states
- Real-time AI generation and notification send

#### **CompletionFeedbackModal** (Enhanced)
- Appears after habit completion
- Shows AI-generated motivational content
- Animations and visual rewards

### 6.4 Mobile Notification Setup

#### **Push Notification Permissions**
- Request on first app launch or when user enables AI notifications
- Graceful fallback if denied (in-app alerts only)
- Re-prompt logic if user changes mind

#### **Notification Channels (Android)**
```kotlin
- AI_MOTIVATION (Morning/Evening)
- AI_INTERVENTION (Missed habits, Low morale)
- AI_CELEBRATION (Streaks, Milestones)
- AI_INSIGHTS (Progress reports)
```

Each channel allows user to control:
- Sound
- Vibration
- Importance level

#### **Notification Categories (iOS)**
Similar categorization for iOS notification settings

### 6.5 AI Prompt Templates

Each intervention category needs a prompt template:

```javascript
const PROMPT_TEMPLATES = {
  morning_motivation: `
    Generate a motivating morning message for a user.
    User's name: {userName}
    AI Style: {aiStyle}
    Active habits: {habitsList}
    Current longest streak: {longestStreak}
    Tone: Inspirational, energizing, focused on new day
    Length: 2-3 sentences max
  `,

  missed_habit_recovery: `
    Generate a supportive message for user who missed a habit.
    User's name: {userName}
    AI Style: {aiStyle}
    Missed habit: {habitName}
    Days missed: {daysMissed}
    Tone: Gentle, non-judgmental, encouraging comeback
    Length: 2-3 sentences max
  `,

  // ... templates for each category
};
```

---

## 7. User Flow Diagrams

### 7.1 First-Time AI Notification Setup

```
App Launch (New User)
  ↓
Onboarding: "Enable AI Notifications?"
  ↓
[Yes] → Request Push Permissions
  ↓
Set Morning/Evening Times
  ↓
Select AI Style
  ↓
"AI Notifications Active!"
  ↓
Prompt: "Want to test them first?"
  ↓
[Optional] → Navigate to Testing Page
```

### 7.2 Notification Trigger Flow

```
Cron Job Runs (e.g., 8:00 AM)
  ↓
Check: Morning Motivation enabled?
  ↓
Check: Within quiet hours?
  ↓
Check: Daily limit reached?
  ↓
Fetch user context (habits, streaks)
  ↓
Call AI Generation Service
  ↓
Generate personalized message
  ↓
Send Push Notification
  ↓
Log to notification_history
```

### 7.3 Testing Page Flow

```
User opens Testing Page
  ↓
Selects "Morning Motivation"
  ↓
Taps [Generate & Send Test]
  ↓
Button → "Generating..."
  ↓
Call AI Service with user context
  ↓
Receive generated notification
  ↓
Send as real push notification
  ↓
Show in-app preview simultaneously
  ↓
Button → "Sent! ✓"
  ↓
Log to test_notifications_log
```

---

## 8. Success Metrics & Analytics

### 8.1 Track These Metrics

- **Notification Open Rate**: % of AI notifications opened
- **Notification Dismiss Rate**: % dismissed without action
- **Conversion to Action**: Did notification lead to habit completion?
- **Optimal Send Times**: When are notifications most effective?
- **Category Effectiveness**: Which interventions work best?
- **User Retention**: Do AI notifications improve long-term engagement?

### 8.2 A/B Testing Opportunities

- Different AI styles for same intervention
- Timing variations (morning: 7am vs 8am vs 9am)
- Notification frequency impact
- Copy length (short vs detailed)

---

## 9. Edge Cases & Error Handling

### 9.1 AI Service Failures
- If AI generation fails → Use pre-written fallback messages
- Retry logic: 2 retries with exponential backoff
- Alert monitoring team if failure rate >5%

### 9.2 No User Data
- New users: Generate generic encouraging messages
- Use placeholders until user has 3+ days of data

### 9.3 Notification Permission Denied
- Show all AI content as in-app banners instead
- Periodic gentle prompts to enable push notifications
- Never block functionality

### 9.4 Timezone Handling
- Store user timezone from device
- Calculate quiet hours and send times in user's local time
- Handle timezone changes (travel)

### 9.5 Daily Limit Reached
- Prioritize interventions: Celebration > Recovery > Motivation
- Queue lower-priority notifications for next day
- Show subtle in-app indicator: "More AI insights available tomorrow"

---

## 10. Privacy & Data Considerations

### 10.1 Data Used for AI Generation
- User's first name only
- Habit names and completion data
- Streak information
- Selected AI style preference
- **NOT USED**: Email, full name, payment info, device identifiers

### 10.2 Data Storage
- AI-generated notifications stored for 30 days (analytics)
- Automatically purged after 30 days
- User can request immediate deletion in Privacy settings

### 10.3 Transparency
- Privacy page clearly states what data is sent to AI service
- Option to disable AI features entirely (falls back to standard reminders)
- No data sold to third parties

---

## 11. Rollout Strategy

### Phase 1: Internal Testing (Week 1-2)
- Implement Testing Page first
- Team tests all intervention categories
- Refine prompts and timing

### Phase 2: Beta Users (Week 3-4)
- Release to 100 opt-in beta users
- Collect feedback on notification quality
- Monitor metrics and adjust

### Phase 3: Gradual Rollout (Week 5-8)
- Enable for 10% of users
- Increase to 25%, 50%, 75% weekly
- Monitor server load and AI costs

### Phase 4: Full Launch (Week 9)
- Enable for all users with opt-out option
- Major marketing push
- Feature in app store listing

---

## 12. Future Enhancements

### 12.1 Adaptive AI Learning
- Track which interventions work best per user
- Automatically adjust frequency and timing
- Personalize intervention types to user preferences

### 12.2 Social Features
- Share streak celebrations with friends
- Group challenges with collective AI motivation
- Accountability partner notifications

### 12.3 Voice Notifications
- Option for audio AI motivation messages
- Text-to-speech using user's preferred AI style
- Great for morning alarms

### 12.4 Wearable Integration
- Send AI notifications to smartwatches
- Haptic feedback for gentle nudges
- Quick habit completion from watch

---

## Document Version
**Version**: 1.0
**Created**: 2025-11-19
**Purpose**: Implementation specification for Claude Code agent
**Status**: Ready for implementation

---

## Implementation Checklist

Use this checklist when implementing the system:

- [ ] Database schema created with all tables
- [ ] Backend services implemented (Trigger, Generation, Delivery)
- [ ] Cron jobs set up for scheduled notifications
- [ ] Profile menu dropdown component created
- [ ] AI Notifications Settings page built
- [ ] Testing page implemented with real AI generation
- [ ] Push notification permissions flow
- [ ] Notification channels/categories configured
- [ ] AI prompt templates defined for all 7 categories
- [ ] Habit completion feedback modal enhanced
- [ ] Analytics tracking implemented
- [ ] Error handling and fallbacks tested
- [ ] Privacy documentation updated
- [ ] User testing completed
- [ ] Performance testing (load, AI costs)
- [ ] Documentation for users (help section)

---

## Questions for Implementation Team

Before starting implementation, clarify:

1. **AI Service**: Which AI API are you currently using? (OpenAI, Anthropic, custom?)
2. **Push Notifications**: Already set up with FCM/APNs or needs initial configuration?
3. **Existing Settings**: Is there a settings page structure to follow/extend?
4. **Design System**: Any UI component library or design tokens to use?
5. **Backend Stack**: What's the backend framework? (Node.js, Python, etc.)
6. **Database**: Confirm database type (PostgreSQL, MySQL, etc.)

---

**End of Specification Document**
