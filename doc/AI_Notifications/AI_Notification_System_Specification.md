# AI Notification System - Complete Specification & Implementation Guide

**Version:** 1.0
**Created:** 2025-11-19
**Purpose:** Comprehensive specification for intelligent, adaptive AI notification system
**Status:** Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Overview & Philosophy](#system-overview--philosophy)
3. [User Journey & Onboarding Flow](#user-journey--onboarding-flow)
4. [AI Archetype System](#ai-archetype-system)
5. [Notification Intelligence Engine](#notification-intelligence-engine)
6. [Technical Architecture](#technical-architecture)
7. [Data Models](#data-models)
8. [UI/UX Specifications](#uiux-specifications)
9. [Implementation Roadmap](#implementation-roadmap)
10. [Testing & Validation](#testing--validation)

---

## 1. Executive Summary

### Vision Statement

The AI Notification System is an intelligent, adaptive companion that transforms traditional "nagging reminders" into personalized motivational experiences. By analyzing user behavior, habit patterns, and goal progress in real-time, the system delivers contextually relevant, personality-matched messages that inspire action without creating notification fatigue.

### Core Objectives

1. **Personalized Motivation:** Deliver AI-generated messages tailored to user personality, current context, and progress
2. **Adaptive Intelligence:** Learn from user behavior and adjust notification strategy dynamically
3. **Non-Intrusive Engagement:** Balance motivation with respect for user attention and time
4. **Contextual Awareness:** Understand what the user needs to hear at any given moment
5. **Long-term Retention:** Keep users engaged through evolving, intelligent communication

### Key Differentiators

- **Dynamic User Profiling:** System continuously learns and adapts to user's changing needs
- **Contextual Intelligence:** Notifications consider time, location, recent activity, and emotional state
- **Multiple AI Personalities:** Users choose from 6-8 distinct AI archetypes with adjustable intensity
- **Screen Overlay Delivery:** High-impact, full-screen notification overlays for maximum attention
- **Two-Way Intelligence:** System learns from user responses and dismissal patterns

---

## 2. System Overview & Philosophy

### The Problem with Traditional Notifications

Traditional habit app notifications fail because they:
- Send generic, repetitive messages that become invisible
- Don't consider user's current context or emotional state
- Create notification fatigue through poor timing
- Fail to evolve as the user progresses
- Don't account for individual personality differences

### Our Solution: The Adaptive AI Companion

The StayHard AI Notification System acts as a **personal accountability partner** that:

1. **Understands You:** Analyzes your personality profile, habits, goals, and daily patterns
2. **Speaks Your Language:** Communicates in a tone and style that resonates with your personality
3. **Knows When to Push:** Identifies moments when you need motivation vs when you need space
4. **Celebrates Progress:** Recognizes achievements and milestones in meaningful ways
5. **Learns and Adapts:** Evolves its communication strategy based on what works for you

### Design Principles

#### 1. **Intelligence Over Frequency**
- Quality > Quantity: Send fewer, smarter notifications
- Each notification must provide value
- Default to silence when uncertain

#### 2. **Respect User Attention**
- No notification during user-set quiet hours
- Understand notification fatigue signals (rapid dismissals, declining engagement)
- Adapt frequency based on user responsiveness

#### 3. **Contextual Relevance**
- Consider: time of day, day of week, current streak, pending habits, goal deadlines
- Different messages for different contexts (morning motivation vs evening reflection)
- Adjust tone based on recent performance (encouragement vs celebration vs accountability)

#### 4. **Personality Alignment**
- Match communication style to user-selected AI archetype
- Allow intensity adjustment (gentle → moderate → intense)
- Maintain consistency in personality while varying content

#### 5. **Dynamic Adaptation**
- Track: notification engagement rates, habit completion rates post-notification, dismissal patterns
- Adjust: frequency, timing, archetype recommendations, message types
- Learn: optimal times to notify, most effective message types, when user needs support

---

## 3. User Journey & Onboarding Flow

### First-Time Setup Experience

#### **Stage 1: Homepage First-Time Experience (1-2 seconds after login)**

**Trigger:** User completes onboarding and lands on homepage for the first time

**Implementation:**
```
User logs in → Homepage loads → Wait 1.5 seconds → Show AI Notification Introduction Modal
```

**Introduction Modal Flow:**

##### **Screen 1: Welcome to Your AI Companion**

```
┌─────────────────────────────────────┐
│  [Close X Button - Top Right]       │
│                                      │
│     🤖                               │
│   [Large AI Icon]                   │
│                                      │
│   Meet Your Personal                │
│   Accountability Partner             │
│                                      │
│   We've built an AI system that     │
│   sends you personalized            │
│   motivational notifications to     │
│   keep you on track with your       │
│   habits and goals.                 │
│                                      │
│   [Next Button]                     │
└─────────────────────────────────────┘
```

**Design Specs:**
- Semi-transparent dark overlay (80% opacity black)
- Modal card: White background, 16px border radius, centered
- Padding: 32px all sides
- Icon: 96px × 96px, animated (gentle pulse)
- Title: Display Medium (28sp), Bold, Primary color
- Body: Body Large (16sp), Regular, On-Surface color
- Button: Elevated, Full width, 56dp height
- Animation: Fade in 300ms, scale from 0.8

##### **Screen 2: How It Works**

```
┌─────────────────────────────────────┐
│  [Close X]            Step 2 of 4   │
│                                      │
│   📱 → 💬 → ⚡                       │
│   [Flow Illustration]                │
│                                      │
│   Smart, Not Annoying               │
│                                      │
│   Your AI analyzes:                 │
│   • Your daily habits & progress    │
│   • Time of day and context         │
│   • Your goals and deadlines        │
│   • Your personality type           │
│                                      │
│   Then sends timely messages        │
│   when you need them most.          │
│                                      │
│  [Back]             [Next]          │
└─────────────────────────────────────┘
```

##### **Screen 3: Choose Your AI Personality**

```
┌─────────────────────────────────────┐
│  [Close X]            Step 3 of 4   │
│                                      │
│   Pick Your Communication Style      │
│                                      │
│   [Scrollable Archetype Cards]       │
│                                      │
│   ┌───────────────────────────────┐ │
│   │ 💪 DRILL SERGEANT              │ │
│   │ "Drop and give me 20!"        │ │
│   │ Tough love, no excuses        │ │
│   │          [Select]             │ │
│   └───────────────────────────────┘ │
│                                      │
│   ┌───────────────────────────────┐ │
│   │ 🧘 WISE MENTOR                 │ │
│   │ "Discipline is freedom"       │ │
│   │ Calm, philosophical guidance  │ │
│   │          [Select]             │ │
│   └───────────────────────────────┘ │
│                                      │
│   [4 more archetypes...]            │
│                                      │
│  [Back]             [Next]          │
└─────────────────────────────────────┘
```

**Interaction:**
- Each card tappable
- Selected card: Border highlight, checkmark icon
- Preview button: Shows sample message in bottom sheet
- Can only select one archetype

##### **Screen 4: Set Notification Intensity**

```
┌─────────────────────────────────────┐
│  [Close X]            Step 4 of 4   │
│                                      │
│   How Often Should I Reach Out?     │
│                                      │
│   [Intensity Slider]                │
│   ◯───────◉───────◯                │
│   Low   Medium    High              │
│                                      │
│   ┌─────────────────────────────┐  │
│   │ 📊 Medium Intensity          │  │
│   │                              │  │
│   │ • 2-3 notifications per day  │  │
│   │ • Morning motivation         │  │
│   │ • Midday check-in            │  │
│   │ • Evening reflection         │  │
│   │                              │  │
│   │ Recommended for most users   │  │
│   └─────────────────────────────┘  │
│                                      │
│  [Back]          [Get Started]      │
└─────────────────────────────────────┘
```

**Intensity Descriptions:**

**Low (Gentle Companion):**
- 1-2 notifications per day
- Morning motivation only
- Gentle encouragement tone
- Focus on positive reinforcement
- Best for: Users who prefer minimal interruption

**Medium (Active Coach) - RECOMMENDED:**
- 2-3 notifications per day
- Morning + Midday + Evening
- Balanced mix of encouragement and accountability
- Context-aware messaging
- Best for: Most users, balanced approach

**High (Intense Accountability):**
- 3-5 notifications per day
- Multiple touchpoints throughout day
- Strong accountability language
- Proactive reminders about pending habits
- Best for: Users who need maximum accountability

##### **Screen 5: Notification Permissions**

```
┌─────────────────────────────────────┐
│  [Close X]               Final Step │
│                                      │
│     🔔                              │
│   [Bell Icon]                       │
│                                      │
│   Enable Notifications              │
│                                      │
│   To receive your personalized      │
│   AI messages, we need permission   │
│   to send notifications.            │
│                                      │
│   You can:                          │
│   • Adjust intensity anytime        │
│   • Set quiet hours                 │
│   • Change AI personality           │
│   • Turn off completely             │
│                                      │
│  [Skip for Now]  [Enable Notifications] │
└─────────────────────────────────────┘
```

**Action Flow:**
- "Enable Notifications" → Request OS permission → Save config → Close modal → Return to homepage
- "Skip for Now" → Save config with notifications disabled → Close modal → Show tooltip on profile icon ("Set up AI notifications anytime")

### Configuration Persistence

**Data Saved:**
```dart
class AINotificationConfig {
  final String userId;
  final AIArchetype selectedArchetype;
  final AIIntensity intensity;
  final bool isEnabled;
  final DateTime onboardingCompletedAt;
  final List<TimeOfDay> preferredNotificationTimes; // Auto-calculated based on intensity
  final NotificationFrequency frequency;
}
```

### Re-Configuration Access

**Access Points:**
1. **Profile Screen → AI Notifications Settings**
2. **Long-press any AI notification → "Configure AI Companion"**
3. **Settings → Notifications → AI Companion**

---

## 4. AI Archetype System

### Overview

Users select one of 6-8 distinct AI personality archetypes. Each archetype represents a different communication style, tone, and motivational approach.

### Archetype Catalog

#### **1. 💪 The Drill Sergeant**

**Personality Traits:**
- Commanding, authoritative, no-nonsense
- Military-style discipline
- Tough love approach
- Direct and demanding
- Zero tolerance for excuses

**Communication Style:**
- Short, punchy sentences
- Imperative commands
- Military terminology
- High energy, urgency

**Sample Messages:**

*Morning (No habits completed):*
```
"Morning, recruit! Your mission today: 8 habits.
Zero completed. Drop the phone. Get to work.
That's an order! 🎖️"
```

*Midday (50% complete):*
```
"Halfway? HALFWAY ISN'T DONE! You've got 4 more
habits waiting. No breaks until the mission is
complete. MOVE IT!"
```

*Evening (100% complete):*
```
"OUTSTANDING WORK! Mission accomplished.
8 out of 8. This is what discipline looks like.
Same time tomorrow, soldier. DISMISSED! 💪"
```

*Streak milestone (7 days):*
```
"7-DAY STREAK! You're starting to look like a
WARRIOR! But this is just basic training.
Let's make it 30. HOORAH!"
```

**Best For:** Users from "Operator" or "Phoenix" profiles who respond well to tough accountability

---

#### **2. 🧘 The Wise Mentor**

**Personality Traits:**
- Calm, philosophical, reflective
- Stoic wisdom
- Deep, thoughtful guidance
- Patient and understanding
- Focus on meaning and purpose

**Communication Style:**
- Philosophical quotes
- Reflective questions
- Calm, measured tone
- Ancient wisdom references (Stoics, Eastern philosophy)

**Sample Messages:**

*Morning (No habits completed):*
```
"Good morning. 'The obstacle is the way.' Your
habits are not tasks—they are the path itself.
Begin with one. The journey starts now. 🌅"
```

*Midday (Low completion):*
```
"Remember: We suffer more in imagination than
in reality. Those 5 pending habits? They're
lighter than the weight of regret. You know
what to do."
```

*Evening (100% complete):*
```
"Today, you chose discipline over comfort.
That's wisdom in action. As Marcus Aurelius
said: 'The impediment to action advances action.'
Rest well. 🕊️"
```

*Streak broken:*
```
"A setback is not a failure—it's information.
Your 23-day streak proved what you're capable of.
Tomorrow, you begin again. That's resilience."
```

**Best For:** Users from "Stoic Path" profile or those seeking deeper meaning

---

#### **3. 🎯 The Friendly Coach**

**Personality Traits:**
- Supportive, encouraging, upbeat
- Team player mentality
- Positive reinforcement focus
- Celebrates effort and progress
- Empathetic and warm

**Communication Style:**
- Enthusiastic, energetic
- Uses "we" language
- Lots of encouragement
- Celebrates small wins
- Relatable, friendly tone

**Sample Messages:**

*Morning (Starting fresh):*
```
"Hey champ! ☀️ It's a brand new day with 8 fresh
habits waiting for you. I know you've got this—
yesterday you crushed 7/8. Let's go for perfect
today! 💙"
```

*Midday (Good progress):*
```
"Look at you! 5 out of 8 already! 🎉 You're
absolutely CRUSHING it today. Just 3 more to
go and you'll have another perfect day. I'm
so proud of you!"
```

*Evening (Missed some habits):*
```
"Hey, I see you completed 5 today. That's still
62%—not bad! Tomorrow is another chance to do
even better. You've got my support. Sleep well! 🌙"
```

*Streak milestone (30 days):*
```
"🎊 30 DAYS! Are you kidding me?! This is HUGE!
I knew you had it in you! You're not just building
habits—you're building a whole new life. So proud! 💪💙"
```

**Best For:** Users from "Pioneer" or "Phoenix" profiles who need positive support

---

#### **4. 🔥 The Motivational Speaker**

**Personality Traits:**
- High energy, passionate, inspiring
- Tony Robbins / Les Brown style
- Grand vision focus
- Dramatic, powerful language
- Calls to greatness

**Communication Style:**
- ALL CAPS emphasis
- Exclamation points
- Dramatic language
- Vision-casting
- Inspirational quotes

**Sample Messages:**

*Morning (Starting day):*
```
"RISE AND GRIND! ⚡ Today isn't just another day—
it's THE day you prove to yourself what you're
made of! You have 8 opportunities to WIN today.
Let's DOMINATE! 🔥🔥🔥"
```

*Midday (Behind schedule):*
```
"You've got 5 habits left and FOUR HOURS to
complete them. This is YOUR moment! Not tomorrow.
Not next week. RIGHT NOW! Your future self is
BEGGING you to take action. ANSWER THE CALL! 💪⚡"
```

*Evening (100% complete):*
```
"YES!! YOU DID IT! You didn't just complete habits—
you DESTROYED your goals today! This is what
CHAMPIONS do! Every. Single. Day. Keep this
energy! You're UNSTOPPABLE! 🏆🔥"
```

*Goal achieved:*
```
"🎉 GOAL ACHIEVED! Do you realize what you just
accomplished?! While others were making excuses,
you were MAKING PROGRESS! This is just the
beginning of your GREATNESS! NEXT LEVEL, HERE WE COME!"
```

**Best For:** Users from "Architect" or "Operator" profiles who respond to high energy

---

#### **5. 🤔 The Philosopher**

**Personality Traits:**
- Thoughtful, introspective, contemplative
- Questions assumptions
- Explores meaning and purpose
- References great thinkers
- Deep, considered observations

**Communication Style:**
- Asks reflective questions
- Philosophical frameworks
- Historical references
- Invites contemplation
- Intellectual depth

**Sample Messages:**

*Morning (Planning day):*
```
"Kierkegaard asked: 'What is a poet? An unhappy
person who conceals profound anguish in his heart
but whose lips are so formed that groans become
beautiful music.' What will your habits compose
today? 📖"
```

*Midday (Behind on habits):*
```
"Sartre said we are 'condemned to be free'—
meaning we must choose. Right now, you're choosing.
5 habits await. Will you choose who you want to
become? Or who you've always been?"
```

*Evening (Reflecting on day):*
```
"Plato believed we are prisoners mistaking shadows
for reality. But today, you completed 8/8 habits.
You stepped out of the cave. That's not metaphor—
that's liberation. 🕯️"
```

*Long-term reflection:*
```
"Nietzsche: 'He who has a why can bear almost any
how.' You've maintained this streak for 45 days.
What's your why? Understanding it makes you
unbreakable."
```

**Best For:** Users from "Stoic Path" or intellectual users seeking depth

---

#### **6. 😄 The Humorous Friend**

**Personality Traits:**
- Light-hearted, funny, relatable
- Self-deprecating humor
- Pop culture references
- Keeps things fun
- Makes you smile while motivating

**Communication Style:**
- Jokes and puns
- Emoji-heavy
- Memes and cultural references
- Playful teasing
- Casual, friendly language

**Sample Messages:**

*Morning (Starting day):*
```
"☕ Good morning, sleepyhead! Your habits are
doing that thing where they wait for you to
remember they exist. 8 habits. 1 amazing person.
Let's do this before your coffee gets cold! 😄"
```

*Midday (Good progress):*
```
"5 out of 8? You're like the Avengers before the
final battle—almost assembled! 🦸 Just 3 more
habits and you can say 'I am Iron Man' to today.
(Minus the whole dying part.)"
```

*Evening (Completed all):*
```
"8/8! 🎉 You absolute LEGEND! You're basically
the Keanu Reeves of habit completion. Breathtaking.
Your streak is now higher than my expectations
for Monday mornings. 🌟"
```

*Streak broken:*
```
"Okay, so the streak broke. Even Tony Stark's
suits malfunction sometimes. 🤷 The difference?
He builds version 2.0. Tomorrow, you're version
2.0. Let's go, Iron Person!"
```

**Best For:** Users from "Pioneer" profile or those who prefer lighthearted approach

---

#### **7. 🏆 The Competitor**

**Personality Traits:**
- Competitive, results-driven, strategic
- Sports/performance mindset
- Scoreboard mentality
- Wins and losses framing
- Benchmarks and goals

**Communication Style:**
- Sports metaphors
- Score tracking
- Competition framing
- Performance metrics
- Winner mindset

**Sample Messages:**

*Morning (Game day):*
```
"🏀 Game day! Today's matchup: YOU vs YOUR GOALS.
8 habits on the board. Current record: 21 wins,
2 losses this month. Protect home court. Leave
it all on the floor. Tip-off: NOW."
```

*Midday (Halftime):*
```
"⏱️ HALFTIME REPORT: 3/8 completed. You're down
but not out. Champions make second-half adjustments.
5 habits left. 6 hours on the clock. This is
when legends are made. EXECUTE."
```

*Evening (Victory):*
```
"🏆 FINAL SCORE: 8-0. PERFECT GAME! That's 22
wins this month. You're averaging 92% completion—
Hall of Fame numbers. Championship mentality.
Rest up, champ. Tomorrow, defend the title."
```

*Leaderboard update:*
```
"📊 LEADERBOARD UPDATE: Your 28-day streak puts
you in the top 5% of all users. But you're not
here for participation trophies. Eyes on #1.
Keep grinding."
```

**Best For:** Users from "Operator" profile or competitive personalities

---

#### **8. 🌱 The Growth Guide**

**Personality Traits:**
- Nurturing, patient, developmental
- Focus on process over outcome
- Growth mindset philosophy
- Celebrates learning from failures
- Long-term transformation focus

**Communication Style:**
- Carol Dweck / growth mindset language
- Process-oriented feedback
- Learning from setbacks
- Patience and nurturing
- Long-term vision

**Sample Messages:**

*Morning (New day):*
```
"🌱 Every seed needs time to become a tree.
Today's 8 habits aren't just tasks—they're
nourishment for your growth. Water them with
intention. Growth happens in the doing."
```

*Midday (Struggling):*
```
"I notice you're at 2/8 today. That's okay.
Growth isn't linear. What matters is that you're
showing up. Every attempt strengthens the neural
pathways. You're not failing—you're learning."
```

*Evening (Partial completion):*
```
"6/8 today. That's growth. Six weeks ago, you
averaged 3/8. You've doubled your capacity.
See how far you've come? Tomorrow, you'll stretch
a little further. 🌿"
```

*Setback reframe:*
```
"Your streak broke at 15 days. But look what you
learned: you CAN do 15 days. That's now your floor,
not your ceiling. Next time, you'll go further.
That's how growth works. 📈"
```

**Best For:** Users from "Phoenix" or "Stoic Path" profiles focused on transformation

---

### Archetype Selection Strategy

**Recommendation Engine:**

The system should suggest archetypes based on:

1. **User's Onboarding Personality Profile:**
   - Phoenix → Friendly Coach or Growth Guide
   - Architect → Competitor or Motivational Speaker
   - Operator → Drill Sergeant or Competitor
   - Stoic Path → Wise Mentor or Philosopher
   - Pioneer → Humorous Friend or Friendly Coach

2. **User's Quiz Responses:**
   - "How do you handle setbacks?"
     - "Push through" → Drill Sergeant
     - "Need external motivation" → Motivational Speaker
     - "Take a break" → Growth Guide

3. **User Behavior Patterns:**
   - High completion rate → Can handle more intensity
   - Frequent streak breaks → Needs more supportive archetype
   - Dismisses notifications quickly → Wrong archetype, suggest change

---

## 5. Notification Intelligence Engine

### The Brain: Context Analysis System

The AI Notification Engine analyzes multiple data points in real-time to determine:
1. **WHAT** to say (message content)
2. **WHEN** to say it (timing)
3. **HOW** to say it (tone adjustment)
4. **IF** to say anything at all (send or skip)

### Data Inputs for Context Analysis

#### **1. User Profile Data**
- Selected AI archetype
- Intensity setting
- Personality quiz results
- Onboarding program (Phoenix, Architect, etc.)
- Account age
- Timezone

#### **2. Real-Time Habit Data**
- Today's completion count
- Today's completion percentage
- Pending habits (sorted by time of day)
- Overdue habits
- Recently completed habits (last 30 minutes)

#### **3. Historical Performance Data**
- Current streak
- Longest streak
- Average completion rate (7 days, 30 days, all-time)
- Best day of week
- Worst day of week
- Time-of-day performance patterns

#### **4. Goal Data**
- Active goals count
- Goals with approaching deadlines (< 7 days)
- Goal progress percentage
- Linked habits for active goals

#### **5. Temporal Context**
- Current time
- Day of week
- Time since last notification
- Time until next scheduled habit
- Is it a weekend?
- Is it a holiday?

#### **6. Engagement Metrics**
- Notification open rate (last 7 days)
- Average time to dismiss notification
- Notifications dismissed without action vs with action
- Best performing notification times
- Response pattern to different message types

#### **7. App Usage Patterns**
- Last app open time
- Daily app sessions count
- Average session duration
- Focus session activity
- Recent achievements unlocked

### Notification Trigger Scenarios

The system triggers notifications based on specific scenarios:

#### **Scenario 1: Morning Motivation (7:00 AM - 9:00 AM)**

**Trigger Conditions:**
- User has morning habits scheduled
- Zero habits completed yet today
- User typically opens app between 7-9 AM

**Context Analysis:**
```dart
class MorningMotivationContext {
  final int totalHabitsToday;
  final int morningHabitsCount;
  final int currentStreak;
  final double yesterdayCompletionRate;
  final bool isWeekend;
  final List<Habit> morningHabits;
}
```

**Message Generation Prompt:**
```
System Role: You are a [ARCHETYPE] providing morning motivation.

User Context:
- Total habits today: {totalHabitsToday}
- Morning habits due: {morningHabitsCount}
- Current streak: {currentStreak} days
- Yesterday's performance: {yesterdayCompletionRate}%
- Day: {dayOfWeek}

Instruction:
Generate a {INTENSITY}-level morning motivation message in the {ARCHETYPE} style.
Focus on energizing the user to start their day strong.
Mention their morning habits if relevant.
Keep under 60 words.

Message:
```

**Sample Output (Drill Sergeant, Medium):**
```
"Morning, soldier! You've got a 12-day streak on the line
and 3 morning habits waiting for orders. Yesterday you hit
87%—today we're going for 100%. Start with your workout.
LET'S MOVE! 💪"
```

---

#### **Scenario 2: Midday Check-in (12:00 PM - 2:00 PM)**

**Trigger Conditions:**
- At least 4 hours since last notification
- User has completed < 50% of habits
- User typically active during lunch hours

**Context Analysis:**
```dart
class MiddayCheckInContext {
  final int completedCount;
  final int totalCount;
  final double completionPercentage;
  final List<Habit> pendingAfternoonHabits;
  final int hoursRemainingInDay;
  final bool hasFocusSessionToday;
}
```

**Message Types:**

**If behind (< 30% complete):**
- **Tone:** Gentle accountability (Low), Firm push (Medium), Demanding (High)
- **Focus:** Highlight pending habits, remaining time, encourage action

**If on track (30-70% complete):**
- **Tone:** Encouraging, celebrating progress
- **Focus:** Acknowledge effort, inspire to finish strong

**If ahead (> 70% complete):**
- **Tone:** Celebratory, reinforcing
- **Focus:** Praise progress, challenge to complete remaining

---

#### **Scenario 3: Evening Reflection (7:00 PM - 9:00 PM)**

**Trigger Conditions:**
- End of day approaching
- User has habits still pending OR all completed
- User typically winds down in evening

**Context Analysis:**
```dart
class EveningReflectionContext {
  final int completedCount;
  final int totalCount;
  final bool allComplete;
  final int currentStreak;
  final bool streakAtRisk; // If 0 habits completed
  final List<Habit> eveningHabits;
}
```

**Message Branches:**

**Branch A: All habits completed (100%)**
```
Generate a congratulatory, celebratory message.
Emphasize the accomplishment.
Reinforce the streak.
Inspire consistency for tomorrow.
```

**Branch B: Mostly complete (70-99%)**
```
Generate an encouraging message.
Acknowledge strong effort.
Gently remind about remaining habits.
Frame as "so close to perfect."
```

**Branch C: Behind schedule (< 70%)**
```
Generate an accountability message.
List remaining habits.
Emphasize time left in day.
Appeal to commitment and goals.
```

**Branch D: Nothing completed (Streak at risk!)**
```
Generate an urgent, high-priority message.
Use STRONG language (appropriate to archetype).
Emphasize streak loss risk.
Call to immediate action.
Frame as critical moment.
```

---

#### **Scenario 4: Streak Milestone Celebration**

**Trigger Conditions:**
- User completes all habits for the day
- Current streak reaches milestone (7, 14, 30, 60, 100, 365 days)

**Milestones:**
- 7 days: First Week Warrior
- 14 days: Two-Week Titan
- 30 days: Monthly Master
- 60 days: Bi-Monthly Beast
- 100 days: Century Centurion
- 365 days: Year-Long Legend

**Message Style:**
- High energy, celebratory
- Specific milestone mention
- Contextualize achievement (top X% of users)
- Challenge to next milestone
- Shareable accomplishment

---

#### **Scenario 5: Streak Recovery (After Breakage)**

**Trigger Conditions:**
- User's streak broke in last 24 hours
- User completes at least one habit today (recovery signal)

**Message Tone:**
- Empathetic and understanding
- Reframe failure as learning
- Highlight past achievement (longest streak)
- Encourage fresh start
- Remove shame/guilt

---

#### **Scenario 6: Goal Deadline Approaching**

**Trigger Conditions:**
- User has active goal with deadline within 7 days
- Goal progress < 75%
- At least 24 hours since last goal-related notification

**Message Focus:**
- Urgency without panic
- Specific habits linked to this goal
- Remaining time calculation
- Action plan suggestion
- Belief in ability to achieve

---

#### **Scenario 7: Habit Recommendation**

**Trigger Conditions:**
- User has < 5 active habits
- User's completion rate > 80% for 14+ days (mastery)
- Haven't suggested new habit in 30 days

**Message Purpose:**
- Celebrate mastery of current habits
- Suggest adding new habit from templates
- Align with user's goals
- Frame as "level up" opportunity

---

### Adaptive Learning System

The engine continuously learns and optimizes notification strategy:

#### **A/B Testing Framework**

**Test Variables:**
1. **Notification Time:**
   - Morning: 7 AM vs 8 AM vs 9 AM
   - Midday: 12 PM vs 1 PM vs 2 PM
   - Evening: 7 PM vs 8 PM vs 9 PM

2. **Message Length:**
   - Short (< 40 words)
   - Medium (40-60 words)
   - Long (60-80 words)

3. **Message Tone (within archetype):**
   - Soft variant
   - Standard variant
   - Intense variant

4. **Call-to-Action:**
   - Specific ("Complete your workout now")
   - General ("Let's tackle your habits")
   - Question ("Ready to crush your goals?")

**Success Metrics:**
- Notification open rate
- Time from notification to habit completion
- Completion rate on days with notification vs without
- User retention (14-day, 30-day)

#### **Personalization Algorithm**

```python
# Pseudocode for adaptive notification timing

def calculate_optimal_time(user_id):
    """Determine best time to send notification for this user"""

    # Get historical engagement data
    engagement_by_hour = get_user_engagement_by_hour(user_id)
    habit_completion_by_hour = get_completion_patterns(user_id)
    app_session_times = get_app_usage_times(user_id)

    # Calculate "responsiveness score" for each hour
    scores = {}
    for hour in range(6, 23):  # 6 AM to 11 PM
        scores[hour] = (
            engagement_by_hour[hour] * 0.4 +  # 40% weight on engagement
            habit_completion_by_hour[hour] * 0.3 +  # 30% weight on completion
            app_session_times[hour] * 0.3  # 30% weight on app usage
        )

    # Get top 3 times
    optimal_times = sorted(scores, key=scores.get, reverse=True)[:3]

    return optimal_times
```

#### **Notification Fatigue Detection**

```python
def check_notification_fatigue(user_id, last_7_days_data):
    """Detect if user is experiencing notification fatigue"""

    indicators = {
        'rapid_dismissal': avg_time_to_dismiss < 3 seconds,
        'declining_engagement': open_rate_trend < -20%,
        'no_action_taken': action_rate < 10%,
        'frequency_complaints': user_reduced_intensity_setting,
    }

    fatigue_score = sum(indicators.values())

    if fatigue_score >= 2:
        # Reduce notification frequency by 30%
        # Increase variety in message types
        # Skip next scheduled notification
        return FATIGUED
    else:
        return HEALTHY
```

---

## 6. Technical Architecture

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    NOTIFICATION ENGINE                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌────────────────┐      ┌─────────────────┐               │
│  │  Context       │──────│  AI Message     │               │
│  │  Analyzer      │      │  Generator      │               │
│  └────────────────┘      └─────────────────┘               │
│         │                         │                          │
│         │                         │                          │
│         ▼                         ▼                          │
│  ┌────────────────┐      ┌─────────────────┐               │
│  │  Scheduling    │      │  Gemini API     │               │
│  │  Service       │      │  Integration    │               │
│  └────────────────┘      └─────────────────┘               │
│         │                         │                          │
│         └─────────┬───────────────┘                          │
│                   │                                          │
│                   ▼                                          │
│         ┌──────────────────┐                                │
│         │  Notification    │                                │
│         │  Delivery        │                                │
│         │  Service         │                                │
│         └──────────────────┘                                │
│                   │                                          │
└───────────────────┼──────────────────────────────────────────┘
                    │
                    ▼
         ┌────────────────────┐
         │  Screen Overlay     │
         │  Renderer           │
         └────────────────────┘
                    │
                    ▼
              ┌─────────┐
              │  User   │
              └─────────┘
```

### Core Components

#### **1. Context Analyzer Service**

**Responsibility:** Gather and analyze all relevant context data

```dart
class NotificationContextAnalyzer {
  final HabitRepository habitRepository;
  final GoalRepository goalRepository;
  final UserRepository userRepository;
  final AnalyticsService analyticsService;

  Future<NotificationContext> analyzeContext({
    required String userId,
    required NotificationScenario scenario,
  }) async {
    // Gather all data sources in parallel
    final results = await Future.wait([
      _getUserProfile(userId),
      _getTodayHabits(userId),
      _getPerformanceMetrics(userId),
      _getGoalData(userId),
      _getEngagementMetrics(userId),
    ]);

    return NotificationContext(
      userProfile: results[0],
      todayHabits: results[1],
      performance: results[2],
      goals: results[3],
      engagement: results[4],
      scenario: scenario,
      timestamp: DateTime.now(),
    );
  }
}
```

#### **2. AI Message Generator**

**Responsibility:** Generate personalized messages using Gemini API

```dart
class AIMessageGenerator {
  final GeminiAPIService geminiAPI;
  final MessageCache messageCache;

  Future<String> generateMessage({
    required NotificationContext context,
    required AIArchetype archetype,
    required AIIntensity intensity,
  }) async {
    // Check cache first for similar context
    final cachedMessage = await messageCache.findSimilar(context);
    if (cachedMessage != null) {
      return cachedMessage;
    }

    // Build prompt
    final prompt = _buildPrompt(context, archetype, intensity);

    try {
      // Call Gemini API
      final response = await geminiAPI.generateContent(prompt);
      final message = _parseResponse(response);

      // Cache the message
      await messageCache.store(context, message);

      return message;
    } catch (e) {
      // Fallback to pre-generated messages
      return _getFallbackMessage(context, archetype);
    }
  }

  String _buildPrompt(
    NotificationContext context,
    AIArchetype archetype,
    AIIntensity intensity,
  ) {
    final archetypeDescription = _getArchetypePrompt(archetype);
    final intensityLevel = _getIntensityDescription(intensity);

    return '''
System Role: $archetypeDescription

User Context:
- Total habits today: ${context.todayHabits.length}
- Completed: ${context.completedCount}
- Pending: ${context.pendingHabits.map((h) => h.name).join(", ")}
- Current streak: ${context.performance.currentStreak} days
- Time: ${context.timeOfDay}
- Scenario: ${context.scenario.description}

Instruction:
Generate a $intensityLevel motivation message in the archetype's voice.
${context.scenario.specificGuidance}
Keep under 60 words.
Use 1 relevant emoji.

Message:
''';
  }
}
```

#### **3. Notification Scheduler Service**

**Responsibility:** Determine when to send notifications

```dart
class NotificationScheduler {
  final WorkManager workManager;
  final AINotificationConfigRepository configRepository;

  Future<void> scheduleNotifications(String userId) async {
    final config = await configRepository.getConfig(userId);

    if (!config.isEnabled) return;

    final optimalTimes = await _calculateOptimalTimes(userId, config.intensity);

    for (final time in optimalTimes) {
      await workManager.registerPeriodicTask(
        'ai_notification_$userId',
        'sendAINotification',
        frequency: Duration(days: 1),
        initialDelay: _calculateDelay(time),
        inputData: {
          'userId': userId,
          'scenario': _determineScenario(time),
        },
      );
    }
  }

  NotificationScenario _determineScenario(TimeOfDay time) {
    if (time.hour >= 6 && time.hour < 10) {
      return NotificationScenario.morningMotivation;
    } else if (time.hour >= 12 && time.hour < 14) {
      return NotificationScenario.middayCheckIn;
    } else if (time.hour >= 19 && time.hour < 22) {
      return NotificationScenario.eveningReflection;
    } else {
      return NotificationScenario.customTiming;
    }
  }
}
```

#### **4. Screen Overlay Renderer**

**Responsibility:** Display full-screen notification overlays

```dart
class AINotificationOverlay extends StatelessWidget {
  final String message;
  final AIArchetype archetype;
  final VoidCallback onDismiss;
  final VoidCallback onViewHabits;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.95),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Archetype icon
                _buildArchetypeIcon(archetype),

                SizedBox(height: 32),

                // Message text
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 48),

                // Action buttons
                ElevatedButton(
                  onPressed: onViewHabits,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Text('View My Habits'),
                ),

                SizedBox(height: 16),

                TextButton(
                  onPressed: onDismiss,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                  ),
                  child: Text('Dismiss'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Background Processing

**WorkManager Configuration:**

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

Future<void> _handleNotificationTask(Map<String, dynamic> inputData) async {
  final userId = inputData['userId'];
  final scenario = NotificationScenario.fromString(inputData['scenario']);

  // Initialize services
  final analyzer = NotificationContextAnalyzer();
  final generator = AIMessageGenerator();
  final delivery = NotificationDeliveryService();

  // Analyze context
  final context = await analyzer.analyzeContext(
    userId: userId,
    scenario: scenario,
  );

  // Check if should send notification
  if (!_shouldSendNotification(context)) {
    return; // Skip this notification
  }

  // Generate message
  final config = await _getUserConfig(userId);
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
  );
}
```

---

## 7. Data Models

### Complete Data Structure

```dart
// Core Configuration
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
  final List<int> preferredNotificationHours; // [7, 13, 20]

  @HiveField(6)
  final List<int> quietHours; // [22, 23, 0, 1, 2, 3, 4, 5, 6]

  @HiveField(7)
  final DateTime? lastModified;

  @HiveField(8)
  final Map<String, dynamic> metadata;
}

// Archetype Enum
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

// Intensity Enum
@HiveType(typeId: 12)
enum AIIntensity {
  @HiveField(0)
  low,    // 1-2 notifications/day

  @HiveField(1)
  medium, // 2-3 notifications/day

  @HiveField(2)
  high,   // 3-5 notifications/day
}

// Notification Record (for history & analytics)
@HiveType(typeId: 13)
class AINotificationRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final AIArchetype archetype;

  @HiveField(4)
  final NotificationScenario scenario;

  @HiveField(5)
  final DateTime scheduledTime;

  @HiveField(6)
  final DateTime? sentAt;

  @HiveField(7)
  final DateTime? viewedAt;

  @HiveField(8)
  final DateTime? dismissedAt;

  @HiveField(9)
  final NotificationAction? actionTaken;

  @HiveField(10)
  final NotificationContext context; // Snapshot of context at send time

  @HiveField(11)
  final Map<String, dynamic> metadata;
}

// Notification Scenario
@HiveType(typeId: 14)
enum NotificationScenario {
  @HiveField(0)
  morningMotivation,

  @HiveField(1)
  middayCheckIn,

  @HiveField(2)
  eveningReflection,

  @HiveField(3)
  streakMilestone,

  @HiveField(4)
  streakRecovery,

  @HiveField(5)
  goalDeadlineApproaching,

  @HiveField(6)
  habitRecommendation,

  @HiveField(7)
  encouragement,

  @HiveField(8)
  urgentAccountability,

  @HiveField(9)
  celebration,

  @HiveField(10)
  customTiming,
}

// Notification Action (what user did)
@HiveType(typeId: 15)
enum NotificationAction {
  @HiveField(0)
  dismissed,

  @HiveField(1)
  viewedHabits,

  @HiveField(2)
  completedHabit,

  @HiveField(3)
  openedApp,

  @HiveField(4)
  changedSettings,

  @HiveField(5)
  ignored, // Notification expired
}

// Notification Context (snapshot)
class NotificationContext {
  final UserProfile userProfile;
  final List<Habit> todayHabits;
  final int completedCount;
  final List<Habit> pendingHabits;
  final PerformanceMetrics performance;
  final List<Goal> activeGoals;
  final EngagementMetrics engagement;
  final NotificationScenario scenario;
  final DateTime timestamp;
  final String timeOfDay; // "morning", "midday", "evening"

  double get completionPercentage =>
      completedCount / todayHabits.length;

  bool get streakAtRisk =>
      completedCount == 0 && timestamp.hour >= 20;
}

// Performance Metrics
class PerformanceMetrics {
  final int currentStreak;
  final int longestStreak;
  final double completionRate7Days;
  final double completionRate30Days;
  final Map<int, double> completionByDayOfWeek; // 1-7: percentage
  final Map<int, double> completionByHour; // 0-23: percentage
}

// Engagement Metrics
class EngagementMetrics {
  final double notificationOpenRate7Days;
  final double averageTimeToAction; // seconds
  final double actionRate; // % of notifications that led to action
  final Map<NotificationScenario, double> scenarioPerformance;
  final DateTime? lastNotificationSent;
  final int notificationCount7Days;
}

// Message Cache Entry
@HiveType(typeId: 16)
class CachedMessage {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final AIArchetype archetype;

  @HiveField(2)
  final NotificationScenario scenario;

  @HiveField(3)
  final Map<String, dynamic> contextFingerprint; // Hash of context

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final int useCount;

  bool get isExpired => DateTime.now().difference(createdAt).inDays > 30;
}
```

### Firestore Collections

```
/users/{userId}/aiNotificationConfig
  - archetype: string
  - intensity: string
  - isEnabled: boolean
  - preferredHours: array
  - quietHours: array
  - onboardingCompletedAt: timestamp
  - lastModified: timestamp

/users/{userId}/aiNotificationHistory/{notificationId}
  - message: string
  - archetype: string
  - scenario: string
  - sentAt: timestamp
  - viewedAt: timestamp (nullable)
  - dismissedAt: timestamp (nullable)
  - actionTaken: string (nullable)
  - context: map (snapshot)

/messageCache/{cacheId}
  - message: string
  - archetype: string
  - scenario: string
  - contextFingerprint: string
  - createdAt: timestamp
  - useCount: number
```

---

## 8. UI/UX Specifications

### Onboarding Flow Screens (Detailed)

*[Already covered in Section 3, with full mockups]*

### Settings Screen: AI Configuration

#### **Location:** Profile Tab → AI Companion Settings

```
┌───────────────────────────────────────────┐
│  [←]  AI Companion Settings               │
├───────────────────────────────────────────┤
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Master Control                       │ │
│  │                                       │ │
│  │  AI Notifications        [ON/OFF]    │ │
│  │  Enable personalized AI messages     │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Current AI Personality              │ │
│  │                                       │ │
│  │  💪 Drill Sergeant                   │ │
│  │  "Drop and give me 20!"              │ │
│  │                                       │ │
│  │             [Change Personality]      │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Notification Intensity              │ │
│  │                                       │ │
│  │  ◯───────◉───────◯                  │ │
│  │  Low   Medium    High                │ │
│  │                                       │ │
│  │  2-3 notifications per day           │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Notification Schedule               │ │
│  │                                       │ │
│  │  Morning       [✓]  7:30 AM          │ │
│  │  Midday        [✓]  1:00 PM          │ │
│  │  Evening       [✓]  8:00 PM          │ │
│  │                                       │ │
│  │             [Customize Times]         │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Quiet Hours                         │ │
│  │                                       │ │
│  │  No notifications during:            │ │
│  │  10:00 PM - 7:00 AM                  │ │
│  │                                       │ │
│  │             [Edit Quiet Hours]        │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Performance Stats                   │ │
│  │                                       │ │
│  │  Notifications sent (7 days): 18     │ │
│  │  Average engagement:          87%    │ │
│  │  Most effective time:   8:00 AM      │ │
│  │                                       │ │
│  │             [View Detailed Stats]     │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  [Test AI Notification]              │ │
│  └──────────────────────────────────────┘ │
│                                            │
└───────────────────────────────────────────┘
```

### Full-Screen Notification Overlay

#### **Overlay Specifications:**

```
┌───────────────────────────────────────────┐
│                                            │
│         [Black background, 95% opacity]   │
│                                            │
│                                            │
│              🤖                            │
│         [Archetype Icon]                  │
│         [Animated pulse]                  │
│         [96px × 96px]                     │
│                                            │
│                                            │
│     "Morning, soldier! You've got a       │
│      12-day streak on the line and        │
│      3 morning habits waiting for         │
│      orders. Let's MOVE! 💪"              │
│                                            │
│     [Message Text]                        │
│     [White, 28sp, Bold, Center-aligned]   │
│     [Line height: 1.3]                    │
│     [Max width: 320dp]                    │
│                                            │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │    View My Habits                    │ │
│  └──────────────────────────────────────┘ │
│  [Primary button, Full width, 56dp]      │
│                                            │
│           Dismiss                         │
│  [Text button, White70, 24sp]            │
│                                            │
│                                            │
└───────────────────────────────────────────┘
```

**Behavior:**
- Overlay appears on top of any screen (even if app is closed, launches overlay activity)
- Blocks interaction with underlying content
- Dismissible via "Dismiss" button or swipe-down gesture
- "View My Habits" navigates to Homepage
- Auto-dismisses after 60 seconds if no interaction
- Haptic feedback on appear
- Sound notification (optional, based on device settings)

**Animation:**
- Fade in: 300ms
- Scale in: 300ms (from 0.9 to 1.0)
- Icon pulse: Continuous, 2-second cycle

### Notification History Screen

#### **Location:** Profile → AI Companion Settings → View Detailed Stats

```
┌───────────────────────────────────────────┐
│  [←]  AI Notification History             │
├───────────────────────────────────────────┤
│                                            │
│  Filter: [Last 7 Days ▼]  [All Types ▼]  │
│                                            │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                            │
│  Today                                     │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  🤖  8:00 AM                         │ │
│  │                                       │ │
│  │  "Morning, soldier! You've got..."   │ │
│  │                                       │ │
│  │  ✓ Viewed • Opened app • 87% today  │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  🤖  1:15 PM                         │ │
│  │                                       │ │
│  │  "You're at 6/8! Just 2 more to..."  │ │
│  │                                       │ │
│  │  ✓ Viewed • Completed habit          │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  Yesterday                                 │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  🤖  7:30 AM                         │ │
│  │                                       │ │
│  │  "Fresh start today! Your 11-day..." │ │
│  │                                       │ │
│  │  ✗ Dismissed quickly                 │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  [Load more...]                           │
│                                            │
└───────────────────────────────────────────┘
```

---

## 9. Implementation Roadmap

### Phase 1: Foundation (Week 1)

**Deliverables:**
- Data models defined and Hive adapters created
- Basic configuration screen UI built
- Archetype selection flow implemented
- User can select archetype and intensity

**Tasks:**
1. Create `AINotificationConfig` model with Hive adapter
2. Create enums: `AIArchetype`, `AIIntensity`, `NotificationScenario`
3. Set up Firestore collections for AI config
4. Build archetype selection carousel
5. Implement intensity slider
6. Create configuration repository
7. Wire up save/load functionality

---

### Phase 2: Message Generation (Week 2)

**Deliverables:**
- Gemini API integration working
- Prompt templates for each archetype
- Fallback message system
- Message caching system

**Tasks:**
1. Set up Gemini API service class
2. Create prompt builder for each archetype
3. Implement context analyzer (gather habit/goal data)
4. Build message parser (extract text from Gemini response)
5. Create fallback message database (100 pre-written messages per archetype)
6. Implement message caching (Hive)
7. Add error handling and retry logic

---

### Phase 3: Notification Scheduling (Week 3)

**Deliverables:**
- Background notification scheduler
- WorkManager integration
- Optimal timing calculator
- Notification trigger logic for all scenarios

**Tasks:**
1. Set up WorkManager for background tasks
2. Implement notification scheduler service
3. Create optimal timing algorithm (based on user patterns)
4. Build scenario detection logic
5. Implement "should send" decision tree
6. Add quiet hours enforcement
7. Create notification fatigue detection

---

### Phase 4: Overlay UI (Week 4)

**Deliverables:**
- Full-screen notification overlay
- Smooth animations
- Action handling
- Accessibility support

**Tasks:**
1. Create overlay widget with Material design
2. Implement enter/exit animations
3. Add gesture handlers (swipe to dismiss)
4. Create "View Habits" navigation
5. Implement auto-dismiss timer
6. Add haptic feedback
7. Ensure accessibility (screen reader support)

---

### Phase 5: Onboarding Integration (Week 5)

**Deliverables:**
- Post-homepage onboarding flow
- Introduction modal sequence
- Archetype recommendation based on quiz
- Seamless integration with existing onboarding

**Tasks:**
1. Create onboarding modal flow (5 screens)
2. Build archetype recommendation algorithm
3. Integrate with existing user profile
4. Add "skip" and "remind later" functionality
5. Implement tooltip reminders for skipped users
6. Track onboarding completion analytics

---

### Phase 6: Analytics & Learning (Week 6)

**Deliverables:**
- Notification history tracking
- Engagement metrics calculation
- Adaptive learning algorithm
- Performance dashboard

**Tasks:**
1. Create notification record storage (Hive + Firestore)
2. Track all notification events (sent, viewed, dismissed, acted)
3. Calculate engagement metrics
4. Implement A/B testing framework
5. Build adaptive timing algorithm
6. Create performance dashboard UI
7. Add recommendation engine for archetype changes

---

### Phase 7: Testing & Polish (Week 7-8)

**Deliverables:**
- Comprehensive testing
- Bug fixes
- Performance optimization
- User testing feedback integration

**Tasks:**
1. Unit tests for message generation
2. Integration tests for scheduling
3. UI tests for overlay rendering
4. Performance profiling (battery usage, memory)
5. Edge case handling
6. Beta user testing
7. Iterate based on feedback
8. Final polish and optimization

---

## 10. Testing & Validation

### Testing Strategy

#### **1. Unit Tests**

**Message Generation:**
```dart
test('Drill Sergeant archetype generates commanding tone', () {
  final context = NotificationContext(...);
  final archetype = AIArchetype.drillSergeant;
  final intensity = AIIntensity.medium;

  final message = generateMessage(context, archetype, intensity);

  expect(message, contains('soldier'));
  expect(message.length, lessThan(60 * 5)); // 60 words max
});
```

**Context Analysis:**
```dart
test('Morning scenario correctly identifies pending morning habits', () {
  final analyzer = NotificationContextAnalyzer();
  final context = analyzer.analyzeContext(
    userId: 'test_user',
    scenario: NotificationScenario.morningMotivation,
  );

  expect(context.pendingHabits, isNotEmpty);
  expect(context.timeOfDay, equals('morning'));
});
```

**Scheduling Logic:**
```dart
test('Quiet hours prevent notifications', () {
  final scheduler = NotificationScheduler();
  final time = TimeOfDay(hour: 2, minute: 0); // 2 AM

  final shouldSend = scheduler.shouldSendNotification(
    time: time,
    quietHours: [22, 23, 0, 1, 2, 3, 4, 5, 6],
  );

  expect(shouldSend, isFalse);
});
```

---

#### **2. Integration Tests**

**End-to-End Notification Flow:**
```dart
testWidgets('User receives and interacts with notification', (tester) async {
  // 1. Set up user with AI config
  await setupUser(archetype: AIArchetype.friendlyCoach);

  // 2. Trigger notification
  await triggerNotification(scenario: NotificationScenario.morningMotivation);

  // 3. Verify overlay appears
  expect(find.byType(AINotificationOverlay), findsOneWidget);
  expect(find.text(containsPattern('champ|friend|you')), findsOneWidget);

  // 4. Tap "View Habits"
  await tester.tap(find.text('View My Habits'));
  await tester.pumpAndSettle();

  // 5. Verify navigation to homepage
  expect(find.byType(Homepage), findsOneWidget);

  // 6. Verify notification recorded
  final history = await getNotificationHistory();
  expect(history.last.actionTaken, equals(NotificationAction.viewedHabits));
});
```

---

#### **3. A/B Testing Framework**

**Test Variants:**

**Test 1: Message Length**
- Variant A: Short messages (< 40 words)
- Variant B: Medium messages (40-60 words)
- **Hypothesis:** Short messages have higher engagement
- **Success Metric:** Open rate > 75%

**Test 2: Time of Day**
- Variant A: 7:00 AM notification
- Variant B: 8:30 AM notification
- **Hypothesis:** Later morning has better engagement
- **Success Metric:** Action rate > 60%

**Test 3: Call-to-Action**
- Variant A: "View My Habits" button
- Variant B: "Let's Go!" button
- **Hypothesis:** Direct action language increases habit completion
- **Success Metric:** Habit completion within 30 min

---

#### **4. User Acceptance Testing**

**Beta Testing Checklist:**

- [ ] 10 users test each archetype
- [ ] Users complete 14-day testing period
- [ ] Collect feedback via in-app survey
- [ ] Track: Notification satisfaction (1-5 scale)
- [ ] Track: Perceived helpfulness (1-5 scale)
- [ ] Track: Would recommend AI notifications (Yes/No)
- [ ] Identify: Most/least favorite archetype
- [ ] Identify: Notification fatigue threshold
- [ ] Measure: Impact on habit completion rate

**Success Criteria:**
- Average satisfaction ≥ 4.0/5.0
- Perceived helpfulness ≥ 4.0/5.0
- Would recommend ≥ 80%
- Habit completion rate increase ≥ 15%

---

## Conclusion

This AI Notification System represents a **paradigm shift** from traditional habit app reminders to an **intelligent, adaptive, personalized companion**. By combining:

1. **Deep user profiling** (archetype selection + behavioral analysis)
2. **Real-time contextual intelligence** (what user needs right now)
3. **Dynamic adaptation** (learning what works for each individual)
4. **High-impact delivery** (full-screen overlays that demand attention)
5. **Personality-matched communication** (speak the user's language)

...we create a notification system that **users want to receive**, rather than one they eventually mute.

### Key Success Factors

1. **Respect User Attention:** Quality over quantity, always
2. **Learn Continuously:** What works for User A may not work for User B
3. **Adapt Dynamically:** User needs change—system must evolve
4. **Communicate Authentically:** Personality must feel genuine, not robotic
5. **Deliver Value:** Every notification must serve the user's goals

### Future Enhancements (Post-MVP)

- **Voice Messages:** AI-generated voice notifications
- **Smart Insights:** Weekly AI-generated performance reports
- **Conversational AI:** Two-way chat with AI companion
- **Community Features:** Share AI messages with friends
- **Custom Archetypes:** Users create their own AI personality
- **Emotion Detection:** Adjust tone based on user's emotional state (inferred from app usage)

---

**Document Version:** 1.0
**Status:** Ready for Implementation
**Next Step:** Begin Phase 1 development

**Approval Required From:**
- Product Lead: ___________
- Tech Lead: ___________
- UX Designer: ___________

---

*End of Specification Document*
