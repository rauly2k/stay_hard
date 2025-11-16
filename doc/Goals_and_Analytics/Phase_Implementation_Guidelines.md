Introduction: The "Golden Thread" of Motivation
This document outlines the strategic framework and implementation plan for the Goals and Analytics tabs of the application. These two sections are the most critical for long-term user retention.

If the Homepage (Phase 3) is about the present (What am I doing today?), this phase is about the future and the past:

The Goals Tab (The Future): This is the user's "why." It answers the question, "Why am I doing these daily habits?" It provides the long-term, outcome-driven motivation necessary to "StayHard" when daily enthusiasm fades.
The Analytics Tab (The Past): This is the user's "how." It answers, "How have I really been doing?" It provides the honest, data-driven feedback required for true accountability and self-awareness.
Together, these sections create a "golden thread". The user defines a Goal (e.g., "Read 25 Books"), which is achieved by consistently performing linked Habits (e.g., "Read 10 Pages Daily"). The Analytics page then visualizes the consistency of that habit, showing the user exactly how their daily actions are building toward their long-term goals.

Part 1: The Goals Tab (The "Why")
1.1. Strategic Framework: Connecting Daily Action to Future Outcomes

The Goals tab is the app's motivational engine. A user will not stick to a habit like "60s Cold Shower" for months on end without a larger purpose. This screen's function is to explicitly create that purpose.

The core concept is to separate the process (the habit) from the outcome (the goal).
Habit (Process): "Go to the gym." (Tracked on the Homepage).
Goal (Outcome): "Lose 10kg." (Tracked on the Goals page).

Entry Point: The user taps the Goals tab. Initially, this screen is empty, with a prominent "Create Your First Goal" button.

Screen 1: Define the Goal: The user is prompted to define the outcome.
[Input Field] "What is your goal?" (e.g., "Run a Marathon," "Master Stoicism").
[Input Field] "How will you measure success?" (e.g., "Run 42km," "Read 5 key texts"). This is the quantitative target.

`` "What is your target date?"
Screen 2: Link the Habits: This is the most critical step.
The app asks: "Which habits will help you achieve this goal?"
It displays a list of the user's existing habits (from their personalized onboarding).

[Checkbox List]
[ ] 45m Workout
[ ] Read 10 Pages
[ ] 5m Guided Meditation

`` "Add a new habit for this goal" (This takes them to the habit creation screen).
The user selects "45m Workout" to link to their "Run a Marathon" goal.
Completion: The user taps "Save Goal." They are returned to the main Goals page, which now shows their new goal as a "Goal Card."

1.3. Design & Implementation Blueprint
1.3.1. Main Goals Screen
UI: A clean, scrollable list of "Goal Cards."

Goal Card UI: Each card should be a high-level summary:

[Goal Name] (e.g., "Run a Marathon").

`` Showing progress toward the outcome (e.g., "Logged 120km / 500km total training").

`` (e.g., "78 days left").

Action: Tapping a Goal Card navigates to the Goal Detail Screen.

1.3.2. Goal Detail Screen
This screen provides a focused dashboard for a single goal.

Header: [Goal Name] and the main ``.

Module 1: Linked Habits:

A list of all habits the user linked to this goal (e.g., "45m Workout," "Daily Stretching").
This list shows the streak and completion % for only these specific habits, giving the user a direct view of the actions powering their goal.
Module 2: Milestones (Gamification):
For long-term goals, allow users to set "levels" or "milestones".
Example for "Run a Marathon":
Milestone 1: Run 10km.
Milestone 2: Run a half-marathon (21km).
Milestone 3: Run 42km. (Goal Complete).
The app can send a celebratory notification when a milestone is hit.
Module 3: The "Why" (Commitment):
Display the "Word for your future self" that the user wrote during onboarding, reminding them why they set this goal.

Part 2: The Analytics Tab (The "How")
2.1. Strategic Framework: The Data-Driven Mirror
This screen is the user's "Quantified Self" dashboard. Its purpose is to provide a powerful, visual, and honest reflection of their consistency. This is not about judgment; it's about awareness. Research shows that 71% of users in wellness apps desire detailed information about their progress. This screen delivers that insight.

The UI should be a clean, scannable dashboard, prioritizing visual data over raw numbers.

2.2. Design & Implementation Blueprint
This screen will be built as a modular dashboard.

2.2.1. Module 1: The "At-a-Glance" Dashboard
UI: A row of 3-4 key "hero" metrics at the top of the screen.

Metrics:
Overall Completion % (Last 30 Days): The user's main "discipline score."
Current Streak: The user's total streak for completing all habits.
Best Streak: The user's all-time best streak, serving as a "high score" to beat.

2.2.2. Module 2: The "Consistency" Heatmap
This is the single most important component of this screen.
UI: A full-year calendar, similar to a GitHub contribution graph.
Logic: Each day of the year is a small square.
Color: The square's color is shaded based on completion percentage for that day.
(e.g., No habits done = Dark Gray, 1-30% = Light Brand Color, 80-100% = Bright Brand Color).
Psychology: This visualization is the ultimate "Don't Break the Chain" motivator. The user's primary goal becomes "paint the calendar" with bright colors, which drives daily consistency.

2.2.3. Module 3: Habit-Specific Analysis
This module breaks down performance by individual habit.
UI: A vertical list of habits, each with a mini-chart.
Metrics per Habit:
[Habit Name]
Streak: "🔥 14 days"
Completion Rate: A LinearPercentIndicator (e.g., "78%").
Best Streak: "Best: 32 days"
Action: Tapping a habit in this list could open a "Habit Detail" page with a monthly calendar view showing only that habit's completion.

2.2.4. Module 4: "AI" & Time-of-Day Insights
This module leverages the data we're already collecting to provide personalized, actionable insights—this is the "smart" part of the app.
UI: A simple card with a text-based insight.
Example Insights:
Time-of-Day: "You complete your habits with 92% success in the Morning, but only 45% in the Evening. Try scheduling 'Read 10 Pages' before 10 AM."
Habit Stacking: "We've noticed you never miss '45m Workout' on days you complete 'Make Your Bed.' This is a powerful stack. Keep it up."
Correlation: "Your 'Mood' (from Analytics V2) is 25% higher on days you complete '15m Morning Walk.'"