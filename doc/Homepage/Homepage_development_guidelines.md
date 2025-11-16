Introduction: The "Daily Command Center"
The Homepage is the most critical screen for long-term retention. After the user completes the "First Mile" (Authentication) and the "Personalized Onboarding" (Program Setup), the Homepage becomes their daily "command center."

Its strategic purpose is to provide immediate, scannable answers to three core questions every time the user opens the app:

"What's my plan today?" (The Habit List)
"How am I doing so far?" (The Progress Dashboard)
"Where do I go from here?" (Global Navigation)

Part 1: Header & Global Navigation (Top Bar)
1.1. Strategic Framework: Identity and Access
The top application bar serves two simple but constant purposes: it provides brand identity and a single, persistent-access point for user-level settings. It must be clean, unobtrusive, and consistent.
UI -> please reference the UI example doc\Homepage\hp_homepage_UI.dart i want the same UI exactly adapted to my needs

Part 2: The "At-a-Glance" Dashboard (Calendar & Progress)
2.1. Strategic Framework: Context and Motivation
This section, placed directly below the header, is the primary "at-a-glance" dashboard. It provides immediate context (what day it is) and immediate motivation (how they are doing).

2.1.1. The Calendar Strip
The one-row calendar is a critical UI pattern for a daily habit app. It allows the user to quickly navigate between recent days to either log missed habits (e.g., for yesterday) or review their plan for tomorrow. It anchors the user in the present while providing flexibility. The "Today" tab must be the default and visually distinct.

2.1.2. The Progress Card
This is the user's primary motivational driver. The circular graphic provides an instant, "gamified" visual of their completion percentage, which is highly motivating. The text "X of X habits completed" serves as a clear, quantitative measure of their success. This card also acts as the primary Call to Action (CTA) to view more in-depth data, funneling the user toward the Analytics section.

Part 3: The Daily Action List (Habit Filtering & List)
3.1. Strategic Framework: The Actionable "To-Do" List
This is the "work" section of the Homepage. It must be easy to filter and easy to interact with.

3.1.1. Habit Filters
The "All, Morning, Afternoon, Evening" filter is essential for reducing cognitive load. A user with 8 habits for the day can feel overwhelmed. By allowing them to filter for "Morning," you present them with a manageable list of 2-3 items, making it much more likely they will start.

3.1.2. Habit Cards
Each habit in the list must be an interactive component. The user needs to be able to complete, view, and edit a habit directly from this list. A "swipe-to-complete" gesture is a fast, intuitive, and satisfying mobile-native pattern that should be implemented. The "edit" button provides a clear path to the habit's configuration (which was set during onboarding).

3.2. Design & Implementation Blueprint
-> please reference the UI example doc\Homepage\hp_homepage_UI.dart
3.2.1. Habit Filters
UI: A ToggleButtons widget.

Content: Four buttons: "All Day", "Morning", "Afternoon", "Evening".

Logic:

"All Day" is the default selection.

The state of this ToggleButtons (which filter is selected) will be used to filter the ListView of habits shown below it.

3.2.2. Habit List
UI: A ListView.builder that displays the list of habits.
Logic: The list of habits shown will be doubly filtered based on:
The selectedDate from the Calendar Strip (Part 2).
The selectedFilter from the Habit Filters (e.g., "Morning").

Habit Card (List Item):
Interaction (Swipe): Each list item will be wrapped in a flutter_slidable widget.
A "swipe right-to-left" or "swipe left-to-right" gesture will reveal a "Complete" action. Tapping this action marks the habit as done.

Content (Visible Card):
[Habit Icon]
[Habit Name]
`` (e.g., a checkmark, or dimmed/strikethrough text if complete).
`` (e.g., "15 min").
`` (Icon button).
Action (Edit Button): Tapping this button navigates the user to the HabitConfigurationScreen (from the onboarding flow), allowing them to edit the habit's details.
Action (Complete): The user can also mark the habit complete by tapping on the card itself (e.g., on the status icon).

Part 4: Main Application Navigation (Bottom Bar)
4.1. Strategic Framework: The Global Hub
This is the app's primary, global navigation. It clearly defines the 5 main sections of the app and must be persistent, clear, and easy to use. For 5 items, a persistent navigation bar that retains the state of each tab is the ideal solution.

4.2. Design & Implementation Blueprint
UI: A BottomNavigationBar or, for a more robust experience, a PersistentBottomNavBar. The persistent bar is recommended as it holds each tab's navigation stack, which will be critical for the "Goals" and "Analytics" sections later.

Tabs (5 total):
Home: The screen this document describes.
Goals: (Placeholder page with text "Goals Page").
Alarms: (Placeholder page with text "Alarms Page").
Focus: (Placeholder page with text "Focus Page").
Analytics: (Links to the same AnalyticsDemoScreen placeholder).

The Homepage will be the first screen in our main PersistentBottomNavBar.

Create Placeholder Screens:
Create GoalsScreen.dart (StatelessWidget with "Goals Page" text).
Create AlarmsScreen.dart (StatelessWidget with "Alarms Page" text).
Create FocusScreen.dart (StatelessWidget with "Focus Page" text).
Create AnalyticsDemoScreen.dart (StatelessWidget with "Analytics Demo" text).
Create UserProfileScreen.dart (StatelessWidget with "User Profile" text).

Create the Main Navigation:
This widget will hold the PersistentBottomNavBar.
It will define the 5 tabs and link them to their respective screens:
Homepage.dart (This is the main screen we are building).
GoalsScreen.dart
AlarmsScreen.dart
FocusScreen.dart
AnalyticsDemoScreen.dart