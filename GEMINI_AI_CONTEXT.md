# Stay Hard: Comprehensive App Context Document for AI Analysis

> **Purpose:** This document provides complete non-technical context about the Stay Hard app for AI analysis and recommendations regarding UI/UX improvements, user profiling, behavioral insights, and personalization framework.

---

## 1. VISION & PURPOSE

### App Mission
Stay Hard is a **habit-building and life transformation platform** designed to help users develop discipline, build positive habits, and achieve meaningful personal growth through a structured, psychology-driven approach.

### Core Philosophy
The app embodies a "mental toughness" philosophy - helping users develop resilience, discipline, and consistency through:
- Personalized habit programs matched to psychological profiles
- Focus and distraction management tools
- Comprehensive progress tracking and analytics
- Goal alignment with daily actions

### Target Audience
1. **Students** - High school, college, and graduate students needing focus and study management
2. **Young Professionals** (20s-30s) - Optimizing productivity and building career-supporting habits
3. **Self-Improvement Enthusiasts** - Actively seeking personal growth and life optimization
4. **People Struggling with Discipline** - Overcoming procrastination and building better routines

### Unique Value Proposition
What sets Stay Hard apart from other productivity/habit apps:

1. **Deep User Profiling** - Sophisticated personality and behavior analysis through questionnaire
2. **AI-Powered Program Matching** - 5 distinct personality archetypes with tailored habit programs
3. **Holistic Integration** - Combines habits, goals, focus management, and analytics in one ecosystem
4. **Mental Toughness Framework** - Built around discipline and "embrace the suck" philosophy
5. **Time Management Enforcement** - Active app blocking and time limits, not just passive tracking

---

## 2. USER PERSONALITY ARCHETYPES & PROGRAMS

The app uses a 6-question onboarding questionnaire to identify users' psychological state, motivations, and needs. Based on responses, users are matched to one of five personality-driven programs:

### THE PHOENIX (The Beginner/Rebuilder)
**Profile Characteristics:**
- Starting from difficulty or hitting restart
- Feeling lost, burnt out, or overwhelmed
- Past accomplishments feel distant or forgotten
- Morning feels like a battle
- May be struggling with multiple life challenges simultaneously

**Color Identity:** Orange (#FF6B35)
**Icon:** Fire/Phoenix

**Program Philosophy:** "Rise from the ashes"
- Focus on building momentum from ground zero
- Fundamental, achievable habits to rebuild confidence
- Emphasis on consistency over intensity
- Small wins compound into transformation

**Core Habits Assigned:**
1. Make Your Bed
2. Drink Water
3. No Phone in Morning
4. Exercise (basic)
5. Gratitude Practice
6. Read Pages
7. Plan Top 3 Tasks

**User Journey:** Rebuilding → Consistency → Confidence → Growth

---

### THE ARCHITECT (The Visionary Builder)
**Profile Characteristics:**
- Has clear vision for future legacy
- Wants to build something that outlasts them
- Sees mornings as opportunities with pressure to perform
- Goal-oriented and systematic
- May struggle with fog or lack of map despite having vision

**Color Identity:** Blue (#277DA1)
**Icon:** Architecture/Blueprint

**Program Philosophy:** "Design and build your legacy"
- Structure and systems-focused approach
- Productivity and planning habits prioritized
- Long-term thinking and strategic execution
- Balance ambition with sustainable habits

**Core Habits Assigned:**
1. Wake Up (No Snooze)
2. Plan Top 3 Tasks
3. Deep Work Session
4. Exercise
5. Read Pages
6. Visualization Practice
7. Drink Water

**User Journey:** Vision → Structure → Execution → Legacy

---

### THE OPERATOR (The High-Performer)
**Profile Characteristics:**
- Already in motion, seeking optimization
- Sees life as competition to win
- Accomplishments are fresh or recent
- Thrives on challenge and intensity
- May fear staying stuck or not maximizing potential

**Color Identity:** Red (#F94144)
**Icon:** Rocket/Target

**Program Philosophy:** "Optimize for peak performance"
- Intense, high-commitment habit stack
- Push beyond comfort zone
- Embrace difficulty as growth mechanism
- Continuous improvement mindset

**Core Habits Assigned:**
1. Wake Up (No Snooze)
2. Intense Exercise
3. Deep Work Session
4. No Social Media
5. Read Pages
6. Plan Top 3 Tasks
7. Embrace the Suck (hardest task first)

**User Journey:** Performing → Optimizing → Dominating → Mastery

---

### THE STOIC PATH (The Internal Warrior)
**Profile Characteristics:**
- Fighting invisible internal battles
- Seeking to reclaim personal narrative
- Carrying emotional/mental weight
- Mornings feel heavy with promises made to self
- Focus on inner strength over external achievement

**Color Identity:** Green (#90BE6D)
**Icon:** Psychology/Balance

**Program Philosophy:** "Build mental fortitude from within"
- Mindfulness and introspection prioritized
- Resilience through self-awareness
- Internal metrics over external validation
- Process over outcomes

**Core Habits Assigned:**
1. Meditate
2. Journal
3. Gratitude Practice
4. Read Pages
5. Exercise (mindful movement)
6. Remember Your Why
7. No Phone in Morning

**User Journey:** Awareness → Acceptance → Strength → Peace

---

### THE PIONEER (The Young Founder)
**Profile Characteristics:**
- Younger users (13-24 age range typically)
- Building life foundation for first time
- Fresh start with minimal bad habits to break
- Open to guidance and structure
- Long-term trajectory focus

**Color Identity:** Amber (#FFB703)
**Icon:** Compass/Explore

**Program Philosophy:** "Build the right foundation early"
- Formative, foundational habits
- Set up patterns for lifetime success
- Education and growth oriented
- Balance discipline with exploration

**Core Habits Assigned:**
1. Wake Up (No Snooze)
2. Make Your Bed
3. Exercise
4. Read Pages
5. Learn a New Skill
6. Plan Top 3 Tasks
7. Drink Water

**User Journey:** Foundation → Learning → Growth → Leadership

---

### Personality Assessment Questions

**Question 1: Life Chapter Title**
"If your life right now was a chapter in a book, what would it be called?"

Options:
- Forging the Hero
- The Great Reset
- Reclaiming the Narrative
- Building from the Ashes
- The Ascent
- Declaring War on Mediocrity

**Question 2: Future Vision**
"When you imagine who you want to become, what drives that vision?"

Options:
- Become the strongest version of myself
- Build a legacy that outlasts me
- Conquer goals and build my vision
- Live without what-ifs or regrets
- Inspire others through transformation

**Question 3: Accomplishment Feeling**
"When was the last time you felt truly proud of what you accomplished?"

Options:
- The feeling is still fresh
- Recent but fading memory
- Distant echo from the past
- Hard to remember
- Here because I need to feel it again

**Question 4: Morning Mindset**
"What does the morning represent to you?"

Options:
- Opportunity to compete and win
- Pressure to perform
- Promises I've made to myself
- Fear of staying stuck
- Feels like a battle

**Question 5: Current Struggles** (Select up to 3)
"What are you battling right now?"

Options:
- Running on empty (burnout, exhaustion)
- Fighting an invisible battle (mental health, internal struggles)
- Carrying weight I can't put down (stress, responsibility, trauma)
- Lost in fog without a map (confusion, lack of direction)
- Adrift at sea without anchor (lack of purpose, instability)
- Watching my life from the sidelines (disconnection, passivity)

**Question 6: Age Group**
"How old are you?"

Options: 13-17, 18-24, 25-34, 35-44, 45-54, 55+

---

## 3. APP STRUCTURE & USER FLOWS

### Authentication & Onboarding Journey

**New User Flow:**

1. **Splash Screen** → App loads with Stay Hard branding
2. **Auth Gate** → Checks if user is logged in
3. **Login/Register** → Email/password or Google sign-in
4. **Intro Slides** (2 screens) → Welcome and mission introduction
5. **Questionnaire** (6 questions) → Personality assessment with page-based navigation
6. **Program Recommendation** → AI shows matched program with description and habit list
   - Option A: Accept and continue
   - Option B: Browse all 5 programs
   - Option C: Create custom program
7. **Habit Configuration** → Set specific parameters (durations, quantities, times) for selected habits
8. **Commitment Message** → Motivational prompt reinforcing commitment
9. **Notification Permission** → Request OS notification access
10. **Loading & Initialization** → Account setup with selected program
11. **Main App** → 5-tab navigation interface

**Returning User Flow:**
1. **Splash Screen** → Auto-login check
2. **Main App** → Direct access to 5-tab interface

---

### Main Navigation Structure

The app uses a **bottom tab bar** with 5 primary sections:

#### TAB 1: HOME (HABITS DASHBOARD)

**Purpose:** Daily habit tracking and completion

**Layout Elements:**
- **Top Section:**
  - Horizontal scrolling calendar date picker
  - Selected date prominently displayed
  - Today indicator

- **Hero Section:**
  - Daily progress overview graphic/animation
  - Motivational message or daily quote

- **Filter Tabs:**
  - "All Day" (default view)
  - "Morning" (habits scheduled for morning)
  - "Afternoon" (habits scheduled for afternoon)
  - "Evening" (habits scheduled for evening)

- **Habit List:**
  - Card-based layout
  - Each habit card shows:
    - Habit name and icon
    - Time of day indicator
    - Completion checkbox or button
    - Quick actions menu (edit, archive, delete)
    - Linked goals indicator (if applicable)
    - Current streak mini-display

- **Add Habit Button (FAB):**
  - Floating action button at bottom-right
  - Opens habit template selection or custom creation

**User Interactions:**
1. Swipe calendar to change date
2. Tap filter tabs to view time-specific habits
3. Check/uncheck habits to mark completion
4. Long-press or swipe habit card for quick actions
5. Tap habit card to view details/edit
6. Tap FAB to add new habit

**Empty State:**
- When no habits exist: Encouraging message to add first habit
- When date has no habits: Different message encouraging to plan ahead

---

#### TAB 2: GOALS

**Purpose:** Long-term goal setting and tracking with habit linkage

**Layout Elements:**
- **Header:**
  - Section title "Goals"
  - Add goal button (+ icon)

- **Goal List:**
  - Card-based vertical scroll
  - Each goal card shows:
    - Goal name (headline)
    - Category icon and label (fitness, career, learning, etc.)
    - Target date or "No deadline"
    - Status indicator (Active, Completed, Paused)
    - Linked habits count ("3 habits linked")
    - Progress indicator if applicable

- **Goal Detail View (on tap):**
  - Full goal description
  - Category and target date
  - List of linked habits with completion status
  - Edit/delete actions
  - Complete goal button
  - Link/unlink habits interface

**User Interactions:**
1. Browse goal list
2. Tap goal card to view details
3. Create new goal:
   - Enter name and description
   - Select category (8 options)
   - Set target date (optional)
   - Select habits to link (from existing habits)
4. Edit goal details
5. Mark goal as completed
6. Pause or delete goals

**Goal Categories:**
- Fitness
- Career
- Learning
- Health
- Finance
- Relationships
- Creativity
- Personal

---

#### TAB 3: ALARMS

**Purpose:** Wake-up alarms with dismissal challenges

**Layout Elements:**
- **Header:**
  - Section title "Alarms"
  - Add alarm button (+ icon)

- **Alarm List:**
  - Card-based vertical scroll
  - Each alarm card shows:
    - Time (large, prominent display)
    - Label (e.g., "Morning Routine")
    - Repeat pattern (Daily, Weekdays, Custom)
    - Toggle switch (on/off)
    - Dismissal method icon
    - Edit button

- **Alarm Configuration Screen:**
  - Time picker (hour:minute)
  - Label text field
  - Repeat pattern selector:
    - Daily
    - Weekdays (Mon-Fri)
    - Weekends (Sat-Sun)
    - Custom (select specific days)
    - Once (single occurrence)
  - Dismissal method selector:
    - Classic (simple dismiss button)
    - Math Challenge (solve equation)
    - Text Typing (type specific phrase)
    - Custom Text (enter custom phrase to type)
  - Difficulty selector (for math challenge): Easy, Medium, Hard
  - Sound selection dropdown
  - Vibration toggle
  - Save/cancel buttons

**Alarm Ring Screen:**
- Full-screen takeover when alarm triggers
- Displays:
  - Current time
  - Alarm label
  - Challenge interface (based on dismissal method)
  - Countdown timer (for classic method)
  - Math problem or text to type (for challenges)
  - Submit/dismiss button (active after challenge completion)

**User Interactions:**
1. Browse alarm list
2. Toggle alarms on/off with switch
3. Create new alarm with all parameters
4. Edit existing alarm
5. Delete alarms
6. When alarm rings:
   - Complete dismissal challenge
   - Alarm dismisses and returns to app

---

#### TAB 4: FOCUS

**Purpose:** Distraction blocking and app time management

**Layout Elements:**

**Main View (No Active Session):**
- **Header:**
  - Section title "Focus"
  - Active session indicator (if running)

- **Quick Actions:**
  - "Start Focus Session" primary button
  - "Focus History" secondary link
  - "App Time Limits" secondary link

- **Recent Sessions Preview:**
  - Last 3 focus sessions
  - Each shows: name, duration, completion status

**Focus Session Creation:**
- **Step 1: Mode Selection**
  - Pre-set focus modes (cards):
    - **Deep Work** (25-60 min) - Blocks social media, messaging, games
    - **Study Session** (30-120 min) - Blocks entertainment apps
    - **Bedtime** (8 hours) - Blocks all except emergency
    - **Minimal Distraction** (30 min) - User-selected blocks
    - **Custom** - Fully customizable

- **Step 2: Configuration**
  - Session name (text field)
  - Duration picker (minutes or hours)
  - App selection (multi-select list of installed apps)
  - Block notifications toggle
  - Link to habit (optional dropdown)

- **Step 3: Confirmation & Start**
  - Summary of what will be blocked
  - Start session button

**Active Session View:**
- **Prominent Display:**
  - Session name
  - Large countdown timer (remaining time)
  - Pause/Resume button
  - End session button (with confirmation)
  - Block attempt counter ("5 attempts to access blocked apps")

- **Background Behavior:**
  - Actively blocks selected apps (shows block screen when user tries to open)
  - Tracks usage attempts
  - Sends notifications when session ends

**Focus History:**
- **Statistics Dashboard:**
  - Total sessions completed
  - Total focus time (hours)
  - Current streak (consecutive days with focus session)
  - Longest streak
  - Average session duration

- **Session History List:**
  - Date-grouped sessions
  - Each shows: name, duration, status (completed/cancelled), block attempts
  - Tap to view details

**App Time Limits:**
- **List of Apps with Limits:**
  - Each app shows:
    - App icon and name
    - Daily limit (e.g., "30 min/day")
    - Usage today (progress bar)
    - Remaining time
    - Toggle (enable/disable limit)

- **Add Time Limit:**
  - Select app from installed apps
  - Set daily limit (minutes)
  - Save

**User Interactions:**
1. Start focus session (guided flow)
2. Manage active session (pause, resume, end)
3. View focus statistics and history
4. Configure app time limits
5. Edit or delete time limits
6. When blocked app is accessed:
   - See block screen with message
   - Option to view remaining time
   - Attempt is logged

---

#### TAB 5: ANALYTICS

**Purpose:** Progress tracking, insights, and performance analysis

**Layout Elements:**

**Overview Dashboard:**
- **Key Metrics Cards (4 primary):**
  1. **Completion Rate** - Last 30 days percentage
  2. **Current Streak** - Consecutive days with activity
  3. **Best Streak** - All-time longest streak
  4. **Total Completed** - All-time habit completions

- **Consistency Heatmap:**
  - Year-view calendar grid
  - Each day colored by completion rate:
    - Dark green: 100% completion
    - Medium green: 50-99%
    - Light green: 1-49%
    - Gray: 0% or no data
  - Interactive (tap day to see details)
  - Scroll horizontally for past years

- **Best Time Analysis:**
  - Visual breakdown by time of day
  - Bar chart or circular display showing:
    - Morning success rate
    - Afternoon success rate
    - Evening success rate
  - "You're most productive in the [TIME]" insight

- **Per-Habit Analysis:**
  - Scrollable list of habit mini-cards
  - Each shows:
    - Habit name and icon
    - Current streak
    - Completion rate (last 30 days)
    - Mini trend graph
  - Tap habit for detailed analysis

**Detailed Habit Analysis (tap on habit):**
- Habit name and configuration
- Extended statistics:
  - All-time completion count
  - Average completions per week
  - Longest streak with dates
  - Current streak
  - Completion rate by month (chart)
  - Completion rate by day of week (chart)
- Recent completion history (list)
- Trend analysis ("Improving!", "Declining", "Stable")

**User Interactions:**
1. View high-level metrics at a glance
2. Explore consistency heatmap by month/year
3. Tap heatmap days to see that day's habits
4. Analyze time-of-day productivity patterns
5. Tap individual habits for deep dive
6. Share statistics (potential feature)

---

## 4. FEATURE SET & CAPABILITIES

### A. HABITS MANAGEMENT

**Core Functionality:**
- Create habits from 25+ pre-built templates OR fully custom habits
- Daily completion tracking with visual feedback
- Habit configuration based on type:
  - **Duration-based:** Track time spent (e.g., "Meditate for 20 minutes")
  - **Quantity-based:** Track number of units (e.g., "Drink 8 glasses of water")
  - **Time-based:** Complete at specific time (e.g., "Wake up at 6 AM")
  - **None:** Simple checkbox completion
- Notifications/reminders per habit
- Archive/restore habits (soft delete)
- Permanent deletion
- AI Coach integration (planned feature)

**Habit Templates by Category:**

**Foundation Habits:**
- Drink Water (quantity: glasses)
- Make Your Bed (checkbox)

**Physical Habits:**
- Exercise (duration: minutes)
- Intense Exercise (duration: minutes, higher intensity)
- No Junk Food (checkbox)
- No Alcohol (checkbox)
- No Processed Sugar (checkbox)

**Mental Habits:**
- Read Pages (quantity: pages)
- Meditate (duration: minutes)
- Gratitude Practice (checkbox or journal)
- Journal (duration: minutes or checkbox)
- Learn a New Skill (duration: minutes)

**Discipline Habits:**
- Plan Top 3 Tasks (checkbox)
- No Phone in Morning (checkbox)
- Wake Up / No Snooze (time-based)
- No Social Media (checkbox)
- Deep Work (duration: minutes or hours)
- Embrace the Suck (checkbox, do hardest task first)
- Remember Your Why (checkbox or journal)
- Visualization (duration: minutes)

**Lifestyle Habits:**
- Custom habits created by users

**Habit Configuration Options:**
- Name and description
- Icon selection
- Category assignment
- Type (duration, quantity, time, none)
- Time of day assignment (morning, afternoon, evening, anytime)
- Specific reminder times (multiple allowed)
- Repeat pattern:
  - Every day
  - Specific days of week
  - Interval (every N days)
- Sound selection for notifications
- Sort order (manual reordering)

**Completion Tracking:**
- Mark complete/incomplete for any date
- Historical completion data stored indefinitely
- Streak calculation (consecutive days completed)
- Completion rate calculation (percentage over time period)
- Visual indicators (checkmarks, progress rings, etc.)

---

### B. GOALS MANAGEMENT

**Core Functionality:**
- Create named goals with descriptions
- Assign category from 8 predefined options
- Set optional target dates (supports up to 30 years in future)
- Link multiple habits to each goal
- Track goal status: Active, Completed, Paused
- Mark goals as completed with completion date tracking
- Edit and delete goals

**Goal-Habit Linkage:**
- When viewing a goal, see all linked habits
- When viewing a habit, see all linked goals
- Completion of linked habits contributes to goal progress
- Visual indicators on habit cards when linked to goals

**Goal Categories:**
1. Fitness - Physical health and athletic goals
2. Career - Professional advancement and work goals
3. Learning - Education and skill acquisition
4. Health - Overall wellness and medical goals
5. Finance - Money management and wealth building
6. Relationships - Social and interpersonal goals
7. Creativity - Artistic and creative pursuits
8. Personal - Self-improvement and personal development

**Use Cases:**
- Long-term aspirations (e.g., "Run a marathon in 6 months")
- Project-based goals (e.g., "Complete certification course")
- Habit stacking for complex outcomes (e.g., "Transform my health" linked to exercise, no junk food, meditation)
- Milestone tracking (e.g., "Read 52 books this year")

---

### C. FOCUS & DISTRACTION BLOCKING

**Focus Sessions:**

**Pre-Set Focus Modes:**

1. **Deep Work**
   - Duration range: 25-60 minutes (Pomodoro-inspired)
   - Default blocks: Social media apps, messaging apps, games, video streaming
   - Use case: Focused work on important tasks
   - Notifications: Blocked except critical

2. **Study Session**
   - Duration range: 30-120 minutes
   - Default blocks: Entertainment apps, social media, games, shopping
   - Use case: Academic study and learning
   - Notifications: Silenced

3. **Bedtime**
   - Duration: 8 hours (typically 22:00-06:00)
   - Default blocks: All apps except phone, messages (emergency only), alarm
   - Use case: Sleep hygiene and wind-down
   - Notifications: Do Not Disturb enabled

4. **Minimal Distraction**
   - Duration: 30 minutes (short sprints)
   - Default blocks: User selects 1-3 specific distraction apps
   - Use case: Quick focused bursts
   - Notifications: Partial blocking

5. **Custom**
   - Duration: User-defined
   - Blocks: Fully customizable
   - Use case: Specific workflows or unique needs
   - Notifications: User choice

**Session Features:**
- Name each session for easy identification
- Select specific apps to block from installed apps list
- Toggle notification blocking on/off
- Link session to a habit (e.g., "Deep Work" habit triggers focus session)
- Schedule sessions in advance (potential feature)
- Recurring sessions (potential feature)

**Active Session Behavior:**
- Countdown timer display
- Persistent notification showing remaining time
- When user tries to open blocked app:
  - Intercept and show block screen
  - Display motivational message
  - Show remaining time
  - Log as "block attempt"
  - Option to end session (with friction/confirmation)
- Pause/resume functionality
- End session early (with confirmation dialog)

**Focus Statistics & History:**
- Total sessions completed
- Total focus time (cumulative hours)
- Current streak (consecutive days with at least one session)
- Longest streak (all-time)
- Average session duration
- Most productive time of day for focus
- Most frequently blocked apps
- Block attempts trend (decreasing = improving)
- Session completion rate (completed vs cancelled)

**App Time Limits:**

**Functionality:**
- Set daily time limits per app (e.g., Instagram: 30 min/day)
- Track actual usage time per app per day
- Warning notification at 80% of limit (e.g., "5 minutes left of Instagram")
- Blocking notification at 100% ("Daily limit reached")
- Real-time progress tracking
- Enable/disable limits individually
- Reset time (midnight local time)

**Usage Tracking:**
- Daily usage per app (minutes)
- Weekly trends
- Most used apps ranking
- Time saved vs previous week
- Historical usage data

**Use Cases:**
- Reduce social media overuse
- Enforce work-life balance (limit work apps in evening)
- Protect sleep (limit all apps after bedtime)
- Break addiction patterns (gradual reduction)

---

### D. ALARMS WITH DISMISSAL CHALLENGES

**Alarm Configuration:**
- Set time (hour and minute, 24-hour or 12-hour format)
- Custom label (e.g., "Morning Routine", "Workout Time")
- Repeat pattern options:
  - Daily (every day)
  - Weekdays (Monday-Friday)
  - Weekends (Saturday-Sunday)
  - Custom days (select specific days of week)
  - Once (single occurrence, then auto-disable)
- Sound selection from preset alarm tones:
  - Radar (default)
  - Apex
  - Ascend
  - (Additional sounds as needed)
- Vibration toggle (on/off)
- Dismissal method (see below)

**Dismissal Methods:**

1. **Classic**
   - Simple dismiss button
   - Optional countdown (must wait N seconds)
   - Use case: Users who wake easily

2. **Math Challenge**
   - Solve math equation to dismiss
   - Difficulty levels:
     - **Easy:** Single-digit addition/subtraction (e.g., 7 + 5 = ?)
     - **Medium:** Two-digit addition, single-digit multiplication (e.g., 23 + 17 = ?, 6 × 8 = ?)
     - **Hard:** Multi-step equations, division (e.g., (15 + 9) ÷ 3 = ?)
   - Must enter correct answer to dismiss
   - Incorrect answers: Alarm continues, new problem generated
   - Use case: Force brain activation to ensure wakefulness

3. **Text Typing**
   - Type a specific phrase to dismiss
   - Default phrases:
     - "I am awake and ready"
     - "Today is my day"
     - "I will not hit snooze"
   - Case-insensitive matching
   - Must match exactly to dismiss
   - Use case: Mindful waking with intention-setting

4. **Custom Text**
   - User defines custom phrase to type
   - Examples: Personal mantras, goals, affirmations
   - Use case: Reinforcement of specific mindset or goal

**Alarm Ring Experience:**
- Full-screen alarm interface (cannot dismiss without challenge)
- Displays:
  - Current time (large)
  - Alarm label
  - Challenge interface (math problem, text entry, etc.)
  - Vibration (if enabled)
  - Gradually increasing volume (optional)
  - No snooze button (forcing intentional dismissal)
- Challenge completion unlocks dismiss button
- After dismissal, returns to app or closes

---

### E. ANALYTICS & INSIGHTS

**Key Metrics Tracked:**

1. **Completion Rate**
   - Percentage of habits completed over time period
   - Default: Last 30 days
   - Calculation: (Completed habits / Total scheduled habits) × 100
   - Displayed on dashboard as primary metric

2. **Streak Tracking**
   - **Current Streak:** Consecutive days with at least one habit completed
   - **Best Streak:** Longest consecutive streak ever achieved
   - **Per-Habit Streaks:** Individual habit consecutive days
   - Streak broken by: Missing all habits in a single day
   - Visual streak indicators (fire icon, number badge)

3. **Total Habits Completed**
   - All-time cumulative habit completions
   - Milestone celebrations (e.g., 100th, 500th completion)

4. **Consistency Heatmap**
   - Year-view calendar grid
   - Color-coded by daily completion rate:
     - Dark green: 100% of habits completed
     - Medium green: 75-99%
     - Light green: 50-74%
     - Pale green: 25-49%
     - Very light green: 1-24%
     - Gray: 0% or no habits scheduled
   - GitHub-style contribution graph aesthetic
   - Interactive: Tap to see day details
   - Visual pattern recognition for consistency

5. **Time-of-Day Performance**
   - Morning completion rate (habits scheduled 5am-12pm)
   - Afternoon completion rate (habits scheduled 12pm-6pm)
   - Evening completion rate (habits scheduled 6pm-11pm)
   - Identifies "best time" based on highest completion rate
   - Suggests habit scheduling optimizations
   - Visual breakdown (pie chart, bar graph, or circular display)

6. **Per-Habit Analytics**
   - Individual habit performance metrics
   - Habit-specific streak (consecutive days for that habit)
   - Habit completion rate (percentage over 30 days)
   - Trend analysis (improving, declining, stable)
   - Completion count by day of week (e.g., "You complete this 90% on weekdays, 40% on weekends")
   - Historical performance charts

**Advanced Insights (Potential):**
- Habit correlation analysis (e.g., "When you complete Exercise, you're 80% more likely to complete Meditation")
- Goal progress tracking (percentage toward goal based on linked habits)
- Weekly/monthly reports
- Personalized recommendations (e.g., "Add a morning habit - you're most consistent in mornings")
- Predictive insights (e.g., "You're at risk of breaking your streak - schedule a check-in")

---

## 5. DATA COLLECTED & USER INFORMATION

### User Account Data
- Firebase Authentication UID (unique identifier)
- Email address
- Display name (if provided)
- Profile photo URL (if using Google sign-in)
- Account creation date
- Last login timestamp

### Personality & Profile Data
- **Questionnaire Responses:**
  - Life chapter selection
  - Future vision selection
  - Last accomplishment feeling
  - Morning mindset
  - Current struggles (up to 3 selected)
  - Age group

- **Matched Program:**
  - Program archetype (Phoenix, Architect, Operator, Stoic, Pioneer)
  - Program acceptance status (accepted recommendation vs browsed vs custom)

- **Profile Metadata:**
  - Onboarding completion date
  - Program start date

### Habit Data (Per Habit)
- Habit unique ID
- Template ID (if created from template, null if custom)
- Habit name
- Description
- Icon identifier
- Configuration:
  - Type (duration, quantity, time, none)
  - Target value (e.g., 20 minutes, 8 glasses, 06:00)
  - Time of day (morning, afternoon, evening, anytime)
  - Reminder times (array of time strings, e.g., ["06:00", "14:30"])
  - Sound preference
  - Notifications enabled (boolean)
- Repeat configuration:
  - Pattern (daily, specific days, interval)
  - Days of week (if specific days)
  - Interval days (if interval pattern)
- Status:
  - Active vs archived
  - Sort order (for display ordering)
- AI Coach enabled (boolean, planned feature)
- Created date
- Last modified date

**Completion Log:**
- Date (key)
- Completed status (boolean)
- Timestamp of completion
- Historical log (stored as map: date → boolean)

**Calculated Metrics (Per Habit):**
- Current streak (consecutive days completed)
- Best streak (all-time longest)
- Completion rate (percentage over 30 days)
- Total completions (all-time count)
- Last completion date

### Goal Data (Per Goal)
- Goal unique ID
- User ID
- Name
- Description
- Category (fitness, career, learning, health, finance, relationships, creativity, personal)
- Target date (optional)
- Status (active, completed, paused)
- Linked habit IDs (array)
- Created date
- Completion date (if status = completed)
- Last modified date

### Focus Session Data (Per Session)
- Session unique ID
- User ID
- Session name
- Duration (minutes)
- Focus mode (deepWork, study, bedtime, minimalDistraction, custom)
- Blocked apps (array of package names)
- Notification blocking enabled (boolean)
- Linked habit ID (optional)
- Status (scheduled, active, paused, completed, cancelled)
- Start timestamp
- End timestamp (actual)
- Expected end timestamp
- Block attempts count (number of times user tried to access blocked apps)
- Created date

**Focus Statistics (Aggregated):**
- Total sessions completed
- Total sessions cancelled
- Total focus time (cumulative minutes)
- Average session duration
- Current focus streak (consecutive days)
- Longest focus streak (all-time)
- Last session date
- Most blocked apps (frequency count)

### App Usage Data
**Per App Time Limit Configuration:**
- App unique ID
- Package name (e.g., "com.instagram.android")
- App name (e.g., "Instagram")
- Daily limit (minutes)
- Limit enabled (boolean)
- Created date
- Last modified date

**Daily Usage Records:**
- Usage record ID
- User ID
- Package name
- Date (normalized to start of day)
- Total usage duration (minutes)
- Last updated timestamp
- Session count (number of times app was opened)

**Usage Statistics (Aggregated):**
- Weekly usage totals per app
- Most used apps ranking
- Usage trends (increasing/decreasing)
- Time saved (comparison to previous period)

### Alarm Data (Per Alarm)
- Alarm unique ID
- User ID
- Time (hour and minute)
- Label
- Repeat pattern (daily, weekdays, weekends, custom, once)
- Custom repeat days (if pattern = custom, array of 1-7 for Mon-Sun)
- Enabled status (boolean)
- Dismissal method (classic, math, textTyping, customText)
- Challenge difficulty (easy, medium, hard - if math challenge)
- Custom text (if customText method)
- Sound selection (identifier)
- Vibration enabled (boolean)
- Created date
- Last modified date
- Last triggered timestamp
- Snooze count (if applicable, future feature)

### Analytics Data (Computed/Tracked)
- **Daily Aggregates:**
  - Date
  - Total habits scheduled
  - Total habits completed
  - Completion rate
  - Morning/afternoon/evening completion rates

- **Streak Data:**
  - Current overall streak
  - Best overall streak
  - Per-habit streaks

- **Heatmap Data:**
  - Past 365 days (or more) of daily completion rates
  - Color-coded for visualization

- **Time-of-Day Performance:**
  - Historical completion rates by time period
  - Best time identification

### Emotional & Wellness Data (Potential Future)
- Mood tracking (daily mood entry)
- Energy levels
- Stress ratings
- Sleep quality (integration with sleep apps)
- Notes or journal entries

---

## 6. CURRENT UI DESIGN & VISUAL STRUCTURE

### Design System & Visual Language

**Color Palette:**
- **Primary Colors:**
  - Program-specific colors (Orange, Blue, Red, Green, Amber for archetypes)
  - Accent color for CTAs and highlights

- **Semantic Colors:**
  - Success: Green (#4CAF50 or similar)
  - Warning: Amber (#FFC107)
  - Error: Red (#F44336)
  - Info: Blue (#2196F3)

- **Neutral Colors:**
  - Background: Light gray or white (#FAFAFA, #FFFFFF)
  - Surface: Card backgrounds (elevated white or light gray)
  - Text primary: Dark gray or black (#212121, #000000)
  - Text secondary: Medium gray (#757575)
  - Dividers: Light gray (#E0E0E0)

**Typography:**
- Material 3 typography scale
- Headlines: Bold, larger sizes for emphasis
- Body: Regular weight, readable sizes (14-16px)
- Captions: Smaller, secondary information (12px)
- Monospace: For time displays, numerical data

**Iconography:**
- Material Icons or custom icon set
- Consistent sizing (24dp standard, 18dp small, 32dp large)
- Outlined style for unselected states, filled for selected
- Color-coded by category or status

**Spacing & Layout:**
- 8dp grid system
- Standard padding: 16dp (cards, containers)
- Compact padding: 8dp (list items)
- Generous padding: 24-32dp (headers, sections)
- Card elevation: 1-4dp for subtle depth

**Components:**
- **Cards:** Primary content container, rounded corners (8-12dp radius), subtle shadow
- **Buttons:** Filled (primary actions), outlined (secondary), text (tertiary)
- **Bottom Sheets:** For selections, configuration flows
- **Dialogs:** For confirmations, critical alerts
- **App Bar:** Top navigation with title, actions, back button
- **Bottom Navigation Bar:** 5 tabs with icons and labels
- **FAB (Floating Action Button):** For primary "add" actions
- **Lists:** Vertical scrolling with dividers or card-based
- **Chips:** For tags, filters, selections
- **Progress Indicators:** Linear and circular for loading/progress
- **Snackbars:** For feedback messages (success, error, info)

---

### Screen-by-Screen UI Breakdown

#### 1. ONBOARDING: INTRO SLIDES
**Layout:**
- Full-screen animated slides (2 total)
- Large illustration or graphic (top 60% of screen)
- Headline text
- Subtext description
- Dot indicator (showing slide 1 of 2)
- "Next" button (bottom)
- "Skip" button (top-right, optional)

**Slide 1:**
- Headline: "Welcome to StayHard"
- Subtext: "Transform your life through consistent habits and mental discipline"
- Graphic: App icon or hero illustration

**Slide 2:**
- Headline: "Your Journey Starts Now"
- Subtext: "We'll help you build the right habits for your unique situation"
- Graphic: Onboarding illustration
- Button changes to "Get Started"

---

#### 2. ONBOARDING: QUESTIONNAIRE
**Layout:**
- Page-based navigation (6 pages total)
- Progress indicator at top (e.g., "Question 2 of 6" or progress bar)
- Question text (headline, centered or left-aligned)
- Answer options (card-based selection)
- "Back" and "Next" buttons (bottom)

**Question Pages:**

**Page 1: Life Chapter**
- Question: "If your life right now was a chapter in a book, what would it be called?"
- 6 option cards (single-select)
- Each card: Title text, subtle background color
- Selected state: Border highlight, checkmark icon

**Page 2: Future Vision**
- Question: "When you imagine who you want to become, what drives that vision?"
- 5 option cards (single-select)
- Similar visual treatment

**Page 3: Accomplishment Feeling**
- Question: "When was the last time you felt truly proud of what you accomplished?"
- 5 option cards (single-select)

**Page 4: Morning Mindset**
- Question: "What does the morning represent to you?"
- 5 option cards (single-select)

**Page 5: Current Struggles**
- Question: "What are you battling right now?" (Select up to 3)
- 6 option cards (multi-select)
- Selected state: Multiple cards can be highlighted
- Counter: "2 of 3 selected"

**Page 6: Age Group**
- Question: "How old are you?"
- 6 option cards (single-select)
- Age ranges displayed

**Interaction:**
- Tap card to select
- "Next" button disabled until selection made
- "Back" button returns to previous question
- Auto-advance on single-select (optional)

---

#### 3. ONBOARDING: PROGRAM RECOMMENDATION
**Layout:**
- Program card (large, centered)
  - Program icon (large, colorful)
  - Program name (headline)
  - Tagline (subtext)
  - Description (2-3 sentences)
  - "Why this matches you:" section
  - Core habits preview (list or chips)

- Action buttons (bottom):
  - Primary: "Start with [Program Name]"
  - Secondary: "Browse Other Programs"
  - Tertiary: "Create Custom Program"

**Visual Design:**
- Program color used as accent throughout card
- Icon prominently displayed
- Habit list shows 5-7 core habits with icons
- Encouraging, personalized language

---

#### 4. ONBOARDING: BROWSE PROGRAMS
**Layout:**
- 5 program cards (vertical scroll)
- Each card shows:
  - Program icon and color
  - Program name
  - Tagline (1 sentence)
  - "View Details" button

- Tapping card expands to full details (similar to recommendation screen)
- "Select this program" button on expanded card

**Interaction:**
- Scroll through all 5 archetypes
- Tap to expand details
- Select preferred program
- Proceed to habit configuration

---

#### 5. ONBOARDING: HABIT CONFIGURATION
**Layout:**
- List of selected habits (from chosen program)
- Each habit card shows:
  - Habit name and icon
  - Configuration fields (if applicable):
    - Duration habits: Time picker (minutes/hours)
    - Quantity habits: Number picker
    - Time habits: Time picker (hour:minute)
    - None: No configuration needed
  - "Remove" option (optional, if allowing customization)

- "Add More Habits" button (optional)
- "Continue" button (bottom)

**Interaction:**
- Set specific values for configurable habits
- Optionally add or remove habits
- Proceed to commitment message

---

#### 6. ONBOARDING: COMMITMENT MESSAGE
**Layout:**
- Full-screen message
- Motivational graphic or illustration
- Headline: "You're About to Start Something Great"
- Subtext: Encouraging message about commitment and consistency
- Checkbox: "I commit to giving my best effort every day"
- "Continue" button (disabled until checkbox checked)

**Purpose:**
- Psychological commitment device
- Moment of reflection before starting
- Increases likelihood of follow-through

---

#### 7. ONBOARDING: NOTIFICATION PERMISSION
**Layout:**
- Notification bell icon (large, centered)
- Headline: "Stay on Track with Reminders"
- Subtext: "We'll send helpful reminders for your habits. You can customize this later."
- "Enable Notifications" button (primary)
- "Skip for Now" button (secondary)

**Interaction:**
- Tap "Enable" → Triggers OS notification permission prompt
- Tap "Skip" → Proceeds without enabling
- Proceeds to loading screen regardless of choice

---

#### 8. ONBOARDING: LOADING & INITIALIZATION
**Layout:**
- Loading spinner or progress animation
- Status text: "Setting up your program..."
- Subtext: "This will only take a moment"

**Background Process:**
- Create Firebase user document
- Initialize selected habits in database
- Set program archetype metadata
- Prepare analytics baseline

**Completion:**
- Auto-navigates to main app (Home tab) when done

---

#### 9. HOME TAB - HABITS DASHBOARD

**Top Section: Date Selector**
- Horizontal scrolling calendar
- Each date shows:
  - Day of month (number)
  - Day of week (abbreviated, e.g., "Mon")
  - Indicator dot if habits exist
  - Completion ring or badge
- Selected date: Highlighted, larger size, accent color border
- "Today" button (quick jump to current date)

**Hero Section: Daily Progress**
- Large circular progress ring or radial chart
- Center shows: "X of Y habits completed"
- Percentage display
- Motivational text based on progress:
  - 0%: "Your day awaits - let's start!"
  - 1-49%: "Good start - keep going!"
  - 50-99%: "You're crushing it today!"
  - 100%: "Perfect day - amazing work!"

**Filter Tabs:**
- Horizontal tab bar
- 4 tabs: "All Day", "Morning", "Afternoon", "Evening"
- Selected tab: Underline or filled background
- Badge count on each tab (e.g., "Morning (3)")

**Habit List:**
- Vertical scrolling list
- Card-based layout with spacing

**Habit Card (Uncompleted State):**
- Left section:
  - Habit icon (color-coded by category)
  - Habit name
  - Time of day indicator (small icon or text)
  - Target info (e.g., "20 minutes", "8 glasses")
- Center section:
  - Current streak mini-display (fire icon + number)
  - Linked goals indicator (small goal icon + count)
- Right section:
  - Large circular checkbox or completion button
  - Visual: Outlined circle (empty)
- Interaction:
  - Tap card body → View habit details / Edit
  - Tap checkbox → Mark complete (animation)
  - Long-press or swipe → Quick actions menu

**Habit Card (Completed State):**
- Visual change:
  - Checkmark in circle (filled, accent color)
  - Subtle background color change (very light green)
  - Optional strikethrough on habit name
  - Confetti animation on completion (optional)
- Tap checkbox again → Mark incomplete (undo)

**Quick Actions Menu (Swipe or Long-Press):**
- Edit (pencil icon)
- Archive (box icon)
- Delete (trash icon)
- View linked goals
- Cancel

**Empty State (No Habits):**
- Illustration (e.g., empty box, starting line)
- Headline: "No habits yet"
- Subtext: "Tap the + button to add your first habit and start building your routine"
- Large "Add Habit" button

**Empty State (No Habits for Selected Date):**
- Illustration (e.g., calendar)
- Headline: "No habits scheduled for this day"
- Subtext: "Your habits will appear here when they're due"

**FAB (Floating Action Button):**
- Bottom-right corner
- "+" icon
- Accent color background
- Tap → Opens habit creation flow

---

#### 10. ADD/EDIT HABIT FLOW

**Screen 1: Habit Source Selection**
- Modal or bottom sheet
- Two large option cards:
  - "Choose from Templates" (with icon, e.g., clipboard)
  - "Create Custom Habit" (with icon, e.g., pencil)
- Tap to proceed to next step

**Screen 2A: Template Selection (If Templates Chosen)**
- Category tabs: Foundation, Physical, Mental, Discipline, Lifestyle
- Template cards (vertical scroll)
- Each template card shows:
  - Habit icon
  - Habit name
  - Brief description
  - "Select" button
- Tap "Select" → Proceeds to configuration

**Screen 2B: Custom Habit Creation**
- Form with fields:
  - Habit name (text input)
  - Description (optional, text area)
  - Icon selection (icon picker)
  - Category (dropdown or chips)
- "Next" button → Proceeds to configuration

**Screen 3: Habit Configuration**
- Habit name (editable)
- **Type Selection:**
  - Radio buttons or cards: Duration, Quantity, Time, None

- **Configuration Fields (conditional on type):**
  - Duration: Time picker (minutes or hours)
  - Quantity: Number picker (units, custom label)
  - Time: Time picker (hour:minute, AM/PM)
  - None: No additional fields

- **Time of Day Assignment:**
  - Radio buttons or chips: Morning, Afternoon, Evening, Anytime

- **Reminder Times:**
  - Add reminder button
  - Time picker for each reminder
  - List of added reminders (removable)

- **Repeat Pattern:**
  - Radio buttons: Daily, Specific Days, Interval
  - If Specific Days: Checkbox for each day of week (Mon-Sun)
  - If Interval: Number picker (every N days)

- **Additional Options:**
  - Notifications enabled (toggle)
  - Sound selection (dropdown)

- **Action Buttons:**
  - "Save" (primary)
  - "Cancel" (secondary)

**Interaction:**
- Form validation before save
- Save → Returns to habit list with new habit added
- Success snackbar: "Habit created!"

**Edit Habit:**
- Same form, pre-filled with existing values
- "Save Changes" button
- "Delete Habit" button (at bottom, in red)
- Delete confirmation dialog

---

#### 11. GOALS TAB

**Main View:**
- Top bar: "Goals" title, "+" button (add goal)
- Filter chips (optional): All, Active, Completed, Paused
- Goal cards (vertical scroll)

**Goal Card:**
- Top section:
  - Goal name (headline)
  - Category icon and label
- Middle section:
  - Target date (if set) or "No deadline"
  - Status badge (Active, Completed, Paused)
  - Linked habits count: "3 habits linked" with icons preview
- Bottom section (optional):
  - Progress bar (if calculable from linked habits)
- Card background: Subtle color tint based on category
- Tap card → Opens goal details

**Goal Detail Screen:**
- Top bar: Goal name, "Edit" button
- Section 1: Goal Info
  - Full description
  - Category
  - Target date
  - Status
- Section 2: Linked Habits
  - List of linked habits with icons and names
  - Each shows recent completion status (mini streak)
  - "Link More Habits" button
- Section 3: Actions
  - "Mark as Completed" button (if active)
  - "Pause Goal" button
  - "Delete Goal" button (red, at bottom)

**Add/Edit Goal Screen:**
- Form with fields:
  - Goal name (text input)
  - Description (text area)
  - Category (dropdown or card selection, 8 options)
  - Target date (date picker, optional)
  - Link habits (multi-select from existing habits)
- "Save Goal" button
- "Cancel" button

---

#### 12. ALARMS TAB

**Main View:**
- Top bar: "Alarms" title, "+" button
- Alarm cards (vertical scroll)

**Alarm Card:**
- Left section:
  - Time (large, bold, e.g., "6:00 AM")
  - Label (below time, e.g., "Morning Routine")
  - Repeat pattern (small text, e.g., "Daily", "Mon, Wed, Fri")
- Center section:
  - Dismissal method icon (math symbol, keyboard, etc.)
  - Sound name (small text)
- Right section:
  - Toggle switch (on/off)
  - "Edit" button (icon)
- Card background: Dimmed if alarm is off
- Tap card → Opens edit screen
- Toggle switch → Enables/disables alarm immediately

**Add/Edit Alarm Screen:**
- Form layout (vertical scroll)
- **Time Section:**
  - Large time picker (rolling wheels or input)
  - AM/PM toggle (if 12-hour format)

- **Label Section:**
  - Text input: "Alarm label"

- **Repeat Pattern Section:**
  - Radio buttons or chips:
    - Daily
    - Weekdays
    - Weekends
    - Custom (shows day checkboxes if selected)
    - Once

- **Dismissal Method Section:**
  - Radio cards:
    - Classic (simple dismiss)
    - Math Challenge → Shows difficulty picker (Easy, Medium, Hard)
    - Text Typing → Shows preset phrase selector
    - Custom Text → Shows text input for custom phrase

- **Sound Section:**
  - Dropdown: Radar, Apex, Ascend
  - "Preview" button (plays sound)

- **Vibration Section:**
  - Toggle switch

- **Action Buttons:**
  - "Save Alarm" (primary)
  - "Cancel" (secondary)
  - "Delete Alarm" (if editing, red, at bottom)

---

#### 13. ALARM RING SCREEN

**Layout:**
- Full-screen takeover (cannot dismiss without completing challenge)
- Top section:
  - Current time (very large)
  - Alarm label
  - Icon indicating dismissal method

- Middle section (Challenge Area):
  - **Classic:**
    - Countdown timer
    - "Dismiss" button (disabled until countdown ends)

  - **Math Challenge:**
    - Math problem displayed (large text)
    - Number pad or keyboard input
    - "Submit" button
    - Feedback: "Incorrect - try again" (if wrong)

  - **Text Typing:**
    - Phrase to type displayed (in box, non-editable)
    - Text input field
    - "Submit" button
    - Character count or progress indicator

  - **Custom Text:**
    - Same as text typing, with user's custom phrase

- Bottom section:
  - Snooze button (optional, if enabled)
  - "I'm Awake" button (only enabled after challenge completed)

**Behavior:**
- Alarm sound plays continuously
- Vibration (if enabled)
- Screen stays on (prevents accidental sleep)
- Volume gradually increases (optional)
- Cannot dismiss or minimize until challenge completed
- After dismissal: Returns to app or locks screen

---

#### 14. FOCUS TAB

**Main View (No Active Session):**
- Top section: "Focus" title
- Quick start cards (horizontal scroll or grid):
  - Deep Work card (25-60 min, icon, description)
  - Study Session card
  - Bedtime card
  - Minimal Distraction card
  - Custom card
- Tap card → Opens session configuration

- Secondary links:
  - "Focus History" (with icon)
  - "App Time Limits" (with icon)

**Main View (Active Session Running):**
- Top section: "Focus Session Active" banner (accent color background)
- Active session card (large, prominent):
  - Session name
  - Focus mode icon
  - Countdown timer (large, animated)
  - Remaining time (e.g., "23:45 remaining")
  - Pause/Resume button
  - End session button
  - Block attempts count: "5 attempts blocked"

- Below: Focus history preview (collapsed, expandable)

---

#### 15. FOCUS SESSION CONFIGURATION

**Screen:**
- Modal or full-screen form
- **Section 1: Session Name**
  - Text input: "e.g., Work on project proposal"

- **Section 2: Focus Mode** (if not pre-selected)
  - Cards for each mode (Deep Work, Study, Bedtime, etc.)
  - Selected mode highlighted

- **Section 3: Duration**
  - Time picker or slider (minutes or hours)
  - Preset options (25, 45, 60, 90 min) as chips

- **Section 4: Apps to Block**
  - Search bar (filter installed apps)
  - List of installed apps with checkboxes
  - If mode pre-selected: Default blocked apps pre-checked (editable)
  - Icons and app names displayed
  - "Select All" / "Deselect All" buttons

- **Section 5: Block Notifications**
  - Toggle switch
  - Explanation text: "Silence notifications from blocked apps"

- **Section 6: Link to Habit** (Optional)
  - Dropdown: Select habit from list (e.g., "Deep Work" habit)

- **Action Buttons:**
  - "Start Focus Session" (primary, large button)
  - "Cancel" (secondary)

**Interaction:**
- After "Start", navigates to active session view
- Session begins immediately
- Notification sent: "Focus session started"

---

#### 16. FOCUS HISTORY & STATISTICS

**Layout:**

**Top Section: Statistics Dashboard**
- 4 metric cards (2x2 grid or horizontal scroll):
  - Total Sessions Completed (number)
  - Total Focus Time (hours)
  - Current Streak (days)
  - Longest Streak (days)

**Middle Section: Session History**
- List of past sessions (newest first)
- Each session card shows:
  - Date (grouped by day)
  - Session name
  - Duration (actual vs planned)
  - Status icon (completed, cancelled)
  - Block attempts count
- Tap card → View session details

**Session Detail Screen:**
- Session name
- Start and end time
- Duration
- Focus mode
- Apps blocked (list with icons)
- Block attempts: Detailed log (which apps, when)
- Linked habit (if applicable)

---

#### 17. APP TIME LIMITS

**Layout:**

**Top Section: "App Time Limits" title, "Add Limit" button**

**App List:**
- Each app card shows:
  - App icon
  - App name
  - Daily limit (e.g., "30 min/day")
  - Usage today:
    - Progress bar (filled based on usage vs limit)
    - Time used / Time limit (e.g., "12 / 30 min")
    - Remaining time (e.g., "18 min left")
  - Toggle switch (enable/disable limit)
  - "Edit" button (icon)

- Cards with exceeded limits: Progress bar red, "Limit reached" text

**Add/Edit App Time Limit Screen:**
- **Section 1: Select App**
  - Dropdown or search: Installed apps list
  - Selected app shows icon and name

- **Section 2: Set Daily Limit**
  - Time picker (hours and minutes)
  - Or slider (0-180 minutes)

- **Action Buttons:**
  - "Save Limit" (primary)
  - "Cancel" (secondary)
  - "Remove Limit" (if editing, red)

**Behavior:**
- When limit reached: Notification sent
- Attempting to open app: Block screen shown
- Block screen shows:
  - App icon
  - "Daily limit reached"
  - Time limit and usage
  - "Try again tomorrow" message
  - "Override" button (optional, with friction)

---

#### 18. ANALYTICS TAB

**Top Section: Key Metrics**
- 4 metric cards (2x2 grid):
  - **Completion Rate:** Large percentage (e.g., "87%"), subtext "Last 30 days"
  - **Current Streak:** Large number (e.g., "12 days"), fire icon
  - **Best Streak:** Large number (e.g., "28 days"), trophy icon
  - **Total Completed:** Large number (e.g., "347"), checkmark icon

**Section 2: Consistency Heatmap**
- Section title: "Your Consistency"
- Year-view calendar grid (GitHub-style)
- Months labeled across top (Jan, Feb, Mar, ...)
- Days of week labeled on left (M, T, W, T, F, S, S)
- Each day cell:
  - Small square
  - Color-coded by completion rate (dark green to light gray)
  - Tap to see details
- Legend: Color scale explanation (0%, 25%, 50%, 75%, 100%)
- Navigation arrows: Previous year / Next year (if data exists)

**Heatmap Interaction:**
- Tap day cell → Bottom sheet with day details:
  - Date
  - Habits scheduled
  - Habits completed
  - Completion rate
  - List of habits with completion status

**Section 3: Best Time Analysis**
- Section title: "When You're Most Productive"
- Visual breakdown:
  - Option A: Circular/radial chart divided into 3 sections (Morning, Afternoon, Evening)
  - Option B: Horizontal bar chart
  - Each section shows completion percentage
- Insight text: "You're most productive in the Morning (92% completion rate)"
- Recommendation: "Try scheduling challenging habits in the morning"

**Section 4: Per-Habit Analysis**
- Section title: "Habit Performance"
- Filter/sort options (dropdown):
  - Sort by: Streak, Completion Rate, Alphabetical
- List of habit mini-cards (vertical scroll)
- Each habit mini-card shows:
  - Habit icon and name
  - Current streak (fire icon + number)
  - Completion rate (percentage + mini bar)
  - Mini trend graph (sparkline showing last 30 days)
- Tap habit → Opens detailed habit analysis

**Detailed Habit Analysis Screen:**
- Top section: Habit name, icon, description
- Statistics cards:
  - Current streak
  - Best streak
  - Completion rate (30 days)
  - Total completions (all-time)
- Charts:
  - **Completion Rate by Month** (line chart, last 6-12 months)
  - **Completion Rate by Day of Week** (bar chart)
- Trend indicator: "Improving!" (green up arrow), "Stable" (gray dash), "Declining" (red down arrow)
- Recent history: List of last 10 completions with dates
- Back button to return to analytics tab

---

#### 19. VISUAL STATES & FEEDBACK

**Loading States:**
- Skeleton screens (placeholder UI while data loads)
- Spinner for long operations
- Progress bars for multi-step processes

**Empty States:**
- Relevant illustrations
- Encouraging headline
- Helpful subtext
- Call-to-action button (if applicable)
- AI-generated empty state messages (personalized)

**Success States:**
- Success snackbar (green, checkmark icon)
- Completion animations (confetti, checkmark expansion)
- Streak milestone celebrations (modal with animation at 7, 30, 100 days)

**Error States:**
- Error snackbar (red, X icon)
- Inline error messages (form validation)
- Retry buttons
- Helpful error descriptions

**Accessibility:**
- High contrast mode support
- Screen reader labels
- Touch target sizes (minimum 48dp)
- Focus indicators for keyboard navigation

---

## 7. USER JOURNEYS & KEY FLOWS

### Journey 1: New User Complete Onboarding → First Habit Completion

**Steps:**
1. Download app, open for first time
2. See splash screen, proceed to auth
3. Create account (email or Google)
4. View intro slides (swipe or tap through)
5. Answer 6 questionnaire questions (page by page)
6. View matched program recommendation (e.g., "The Phoenix")
7. Choose to accept recommendation or browse other programs
8. Configure selected habits (set durations, quantities, times)
9. View commitment message, check commitment box
10. Grant notification permission (or skip)
11. Wait for account initialization
12. Land on Home tab (Habits dashboard)
13. See today's habits with incomplete status
14. Tap checkbox on first habit to mark complete
15. See completion animation and updated progress ring
16. Receive encouraging notification (optional)
17. View updated streak count (1 day)
18. Repeat for other habits throughout day
19. Achieve 100% completion, see celebratory message
20. Check Analytics tab to see first day in heatmap

**Emotional Arc:**
- Initial curiosity → Personalized understanding → Motivation → Commitment → Empowerment → Pride

---

### Journey 2: Returning User Daily Habit Routine

**Steps:**
1. Wake up, dismiss alarm (with math challenge)
2. Open app (auto-logged in)
3. Land on Home tab, see today's date selected
4. View daily progress: "0 of 7 habits completed"
5. Check "Make Your Bed" habit (morning routine starts)
6. Open Focus tab
7. Start "Morning Focus" session (blocks social media for 30 min)
8. Return to Home tab
9. Complete "No Phone Morning" habit during focus session
10. Complete "Exercise" habit after workout
11. Throughout day, check and complete habits as done
12. Evening: Complete "Read Pages" and "Journal" habits
13. End of day: Home tab shows "7 of 7 habits completed" with celebration
14. Check Analytics tab, see:
    - Current streak increased to 15 days
    - Heatmap now shows dark green for today
    - Completion rate remains high
15. Feel accomplished, close app
16. Receive notification next morning: "Ready for day 16 of your streak?"

**Emotional Arc:**
- Routine → Focus → Productivity → Consistency → Satisfaction → Motivation for tomorrow

---

### Journey 3: User Struggling, Then Recovering

**Steps:**
1. User has 30-day streak, very motivated
2. Day 31: Busy at work, forgets to check app
3. Day 32: Opens app, sees "Streak broken" message
4. Feels disappointed, sees streak reset to 0
5. Considers giving up
6. Receives notification: "You had an amazing 30-day streak! Ready to start a new one?"
7. Opens app, sees "Best Streak: 30 days" still visible in Analytics
8. Reads motivational message: "Setbacks are part of growth. Your 30-day streak proves you can do this."
9. Re-commits to habits
10. Completes all habits for day 32
11. New streak: 1 day (but best streak still 30)
12. Over next week, completes habits consistently
13. New streak reaches 7 days
14. Receives "7-Day Streak!" celebration
15. Motivated to beat previous 30-day record
16. Sets goal: "Achieve 60-day streak"
17. Links all habits to this goal
18. Continues building momentum

**Emotional Arc:**
- Pride → Distraction → Realization → Disappointment → Hope → Recommitment → Progress → Determination

---

### Journey 4: User Customizing Experience

**Steps:**
1. User has been using app for 2 weeks with Phoenix program
2. Realizes needs more focus on productivity, less on wellness
3. Opens Home tab → Taps "Add Habit" FAB
4. Chooses "Choose from Templates"
5. Selects "Deep Work" from Discipline category
6. Configures: 90 minutes, morning, reminder at 8 AM
7. Saves habit
8. Opens Goals tab
9. Creates new goal: "Launch Side Project"
10. Links "Deep Work", "Plan Top 3 Tasks", and "Learn a Skill" habits
11. Sets target date: 3 months from now
12. Opens Focus tab
13. Creates custom focus mode: "Project Work"
14. Sets 90-minute duration
15. Blocks: Email, social media, news apps
16. Enables notification blocking
17. Links to "Deep Work" habit
18. Saves focus mode
19. Next morning: Alarm wakes user (with math challenge)
20. Opens app, sees "Deep Work" habit due
21. Starts "Project Work" focus session
22. Works for 90 minutes without distraction
23. Session ends, marks "Deep Work" habit complete
24. Sees progress toward "Launch Side Project" goal
25. Over weeks, completes goal
26. Marks goal complete, feels deep satisfaction
27. Creates new, more ambitious goal

**Emotional Arc:**
- Adaptation → Initiative → Creativity → Focus → Progress → Achievement → Ambition

---

## 8. DESIRED OUTCOMES FROM GEMINI AI ANALYSIS

### Primary Analysis Goals

**1. Strategic UI/UX Improvements**
I want Gemini to analyze the current UI structure and provide specific, actionable recommendations for:
- **Screen hierarchy optimization** - Which screens/features should be more prominent? Which could be combined or simplified?
- **User flow improvements** - Where are there friction points in common user journeys? How can navigation be more intuitive?
- **Visual design refinement** - How can the visual language better communicate the app's philosophy and enhance user motivation?
- **Onboarding optimization** - Is the questionnaire effective? Should questions be reordered, reworded, or changed entirely?
- **Information architecture** - Is the 5-tab structure optimal? Should any features be relocated?
- **Accessibility enhancements** - What specific improvements would make the app more inclusive and usable?

**2. Behavioral Insights & User Psychology**
I want Gemini to provide deep insights into:
- **Habit formation psychology** - How can the app better leverage behavioral science principles (implementation intentions, habit stacking, environmental design, etc.)?
- **Motivation sustainability** - What features or messaging would help users stay motivated beyond initial enthusiasm?
- **User resistance points** - Where might users feel overwhelmed, frustrated, or tempted to quit? How can these be mitigated?
- **Gamification vs authenticity** - How to balance motivational techniques without feeling gimmicky or manipulative?
- **Social dynamics** - Should the app incorporate social features (accountability partners, communities)? If so, how?
- **Failure recovery** - How to design for streak breaks and setbacks in a way that encourages continuation rather than abandonment?

**3. Personalization Framework**
I want Gemini to help refine how the app personalizes to individual users:
- **Archetype refinement** - Are the 5 personality archetypes well-defined and distinct? Should there be more, fewer, or different profiles?
- **Questionnaire effectiveness** - Do the 6 questions effectively differentiate users and predict their needs?
- **Dynamic adaptation** - How can the app evolve its recommendations as users progress and change over time?
- **Habit recommendations** - What logic should determine when to suggest new habits, modify existing ones, or retire habits?
- **Personalized insights** - What specific analytics and insights would be most valuable to each archetype?
- **Adaptive difficulty** - Should the app adjust challenge levels (dismissal difficulty, focus session duration) based on user performance?

**4. Feature Prioritization & Strategic Direction**
I want Gemini to help prioritize what to build next:
- **Missing features** - What critical features are missing that would significantly improve user outcomes?
- **Feature depth vs breadth** - Should I focus on deepening existing features or adding new capabilities?
- **Habit program evolution** - How should programs adapt over time? Should there be "phases" (e.g., Phoenix → Architect as users progress)?
- **AI integration opportunities** - Where would AI-powered features (coaching, insights, recommendations) add most value without feeling intrusive?
- **Social features** - Friends, leaderboards, shared goals - yes or no? If yes, how to implement thoughtfully?
- **Monetization alignment** - What premium features would users genuinely value and align with the app's mission?

---

### Specific Questions for Gemini

**ON USER PROFILES & ARCHETYPES:**
- Are there user types or psychological states not captured by the current 5 archetypes?
- Should archetypes be allowed to evolve (e.g., Phoenix graduates to Architect after 90 days)?
- What additional data points would make personalization more effective?
- How should the app handle users who don't fit neatly into one archetype?

**ON HABIT DESIGN:**
- Which habits from the templates are most likely to drive long-term transformation?
- Are there essential habit categories or templates missing?
- How should habit difficulty be balanced in program recommendations?
- Should habits have "levels" that increase in difficulty over time?
- How many habits is optimal for users at different stages (beginner vs advanced)?

**ON MOTIVATION & ENGAGEMENT:**
- What psychological triggers should be used at which moments in the user journey?
- How should the app communicate during streak breaks without inducing guilt or shame?
- What types of celebrations and milestones would be most meaningful?
- Should the app use "tough love" messaging aligned with "Stay Hard" philosophy, or gentler encouragement?
- How to balance discipline/intensity with compassion/self-care?

**ON UI/UX SPECIFIC IMPROVEMENTS:**
- Should the heatmap be on the Home tab instead of Analytics?
- Would a "Daily Summary" screen at end of day increase reflection and commitment?
- Should focus sessions have a "why" prompt before starting (intention-setting)?
- Would a widget for quick habit checking increase completion rates?
- Should there be a "Check-In" feature for morning intention-setting or evening reflection?

**ON ANALYTICS & INSIGHTS:**
- What insights are missing that would help users understand their patterns?
- Should the app predict when users are at risk of breaking streaks?
- Would showing "peer comparisons" (anonymized) be motivating or demotivating?
- Should there be a "Weekly Review" feature that guides users through their performance?

**ON FOCUS & TIME MANAGEMENT:**
- Should focus sessions be schedulable in advance (time-blocking feature)?
- Would integration with calendar apps (Google Calendar, etc.) improve focus session effectiveness?
- Should the app suggest optimal times for focus based on historical performance?
- Should there be "focus goals" (e.g., 10 hours of deep work per week)?

**ON GOALS:**
- Should goals have more structure (milestones, sub-goals, progress tracking)?
- Would visualizing goal progress (percentage, timeline) increase motivation?
- Should the app suggest goals based on user's archetype and habits?
- How should the relationship between habits and goals be more explicitly shown?

---

## 9. GEMINI AI PROMPT

---

# COMPREHENSIVE APP ANALYSIS REQUEST

You are a product strategist and behavioral psychologist specializing in habit formation, user experience design, and digital wellness applications. I've provided you with comprehensive documentation about the "Stay Hard" app - a habit-building and life transformation platform.

## YOUR TASK

Analyze this app holistically from a **non-technical, user-centric perspective** and provide strategic recommendations in the following areas:

### 1. UI/UX STRATEGIC IMPROVEMENTS

Analyze the current screen structure, user flows, and visual design. Provide specific, prioritized recommendations for:

- **Screen hierarchy & navigation** - Which features should be more/less prominent? Should the 5-tab structure change?
- **Onboarding optimization** - Is the questionnaire effective? Should questions or flow be modified?
- **User journey refinement** - Where are friction points? How can common flows be smoother?
- **Visual communication** - How can design better reinforce the "mental toughness" philosophy while remaining approachable?
- **Accessibility & inclusivity** - Specific improvements to make the app more usable for all users
- **Information density** - Where is there too much or too little information shown?

**For each recommendation:**
- Explain the user psychology or UX principle behind it
- Describe the expected impact on user behavior and outcomes
- Prioritize (High, Medium, Low impact)

---

### 2. BEHAVIORAL INSIGHTS & HABIT PSYCHOLOGY

Analyze the app through the lens of behavioral science and habit formation research. Address:

- **Habit formation effectiveness** - How well does the app leverage proven behavioral science principles? What's missing?
- **Motivation architecture** - How can the app better sustain long-term motivation beyond initial enthusiasm?
- **Failure resilience** - How should the app handle streak breaks, setbacks, and demotivation to encourage continuation?
- **User resistance points** - Where might users feel overwhelmed, frustrated, or tempted to abandon the app?
- **Psychological triggers** - What specific triggers (prompts, rewards, social proof, commitment devices) should be used at which moments?
- **Discipline vs compassion balance** - How to embody "Stay Hard" philosophy without inducing shame or burnout?

**For each insight:**
- Reference relevant behavioral science research or principles (if applicable)
- Explain how it applies to the Stay Hard app specifically
- Suggest concrete implementation approaches

---

### 3. PERSONALIZATION FRAMEWORK REFINEMENT

Evaluate and improve the personality archetype system and personalization strategy:

- **Archetype effectiveness** - Are the 5 archetypes (Phoenix, Architect, Operator, Stoic, Pioneer) well-differentiated and comprehensive? Should there be changes?
- **Questionnaire quality** - Do the 6 questions effectively identify user needs and psychological states? Suggest improvements.
- **Dynamic adaptation** - How should the app personalize over time as users evolve and make progress?
- **Habit matching logic** - What should determine which habits are recommended to which users at which stages?
- **Archetype evolution** - Should users "graduate" between archetypes (e.g., Phoenix → Architect)? How?
- **Missing user types** - Are there psychological profiles or user needs not captured by current archetypes?

**For each recommendation:**
- Explain the psychological basis for the archetype or question
- Describe how it would improve user outcomes
- Suggest specific changes to questionnaire or program design

---

### 4. FEATURE PRIORITIZATION & STRATEGIC DIRECTION

Help prioritize what to build, improve, or remove:

- **Critical missing features** - What significant capabilities are absent that would dramatically improve user outcomes?
- **Feature depth vs breadth** - Should focus be on deepening existing features or expanding to new areas?
- **AI integration opportunities** - Where would AI-powered coaching, insights, or recommendations add most value?
- **Social features consideration** - Should the app incorporate social accountability, communities, or sharing? If yes, how to do it thoughtfully without toxic comparison?
- **Habit program evolution** - Should programs have "phases" or progression systems? How should users advance over time?
- **Premium feature candidates** - What features would users genuinely value enough to pay for, aligned with app mission?

**For each feature or direction:**
- Explain the strategic rationale and user value
- Estimate impact on user outcomes (habit adherence, transformation, retention)
- Suggest implementation approach (what would this look like in practice?)
- Prioritize (Must-have, Should-have, Nice-to-have)

---

## ANALYSIS APPROACH

Please structure your response as a **comprehensive strategic analysis document** with:

1. **Executive Summary** - Key findings and top 5 strategic recommendations
2. **Detailed Analysis by Category** (UI/UX, Behavioral, Personalization, Features)
3. **Prioritized Action Plan** - What to tackle first, second, third
4. **Long-term Vision** - Where this app could evolve over 1-3 years

## IMPORTANT CONTEXT

- **Target users:** Primarily 18-35 year olds struggling with consistency, seeking personal transformation
- **Core philosophy:** "Mental toughness" and discipline, but with psychological intelligence
- **Competitive landscape:** Competing with Habitica, Streaks, Way of Life, Fabulous, but differentiated by personality-driven programs and focus enforcement
- **Business model:** Freemium (exact premium features TBD - your input needed here)
- **Platform:** Mobile app (iOS and Android via Flutter)

## WHAT NOT TO FOCUS ON

- Technical implementation details or code architecture
- Specific visual design mockups (concepts and principles are fine)
- Marketing or growth strategies
- Backend infrastructure or data management

## DESIRED OUTPUT STYLE

- **Strategic and thoughtful**, not superficial
- **Specific and actionable**, not generic UX platitudes
- **Grounded in behavioral science and user psychology**
- **Prioritized by impact**, recognizing resource constraints
- **Holistic**, considering how recommendations interact with each other

---

Please provide your comprehensive analysis now.

---

## 10. DOCUMENT METADATA

**Document Version:** 1.0
**Created:** [Current Date]
**Purpose:** AI analysis input for product strategy and UX optimization
**Target AI Model:** Gemini AI (Google)
**App Name:** Stay Hard
**Platform:** iOS and Android (Flutter)
**Stage:** MVP complete, pre-launch optimization phase
**Primary Use Case:** Habit formation and personal transformation

---

*End of Context Document*
