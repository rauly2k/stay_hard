This document outlines the strategic framework and implementation plan for the app's Phase 2 Personalized Onboarding Funnel. This flow begins immediately after a user successfully completes the initial registration (from the "First Mile" plan) and ends the moment they are delivered to the main application homepage.

The primary business goal of this flow is user investment. By guiding the user through a series of questions and choices, we transform the app from a generic utility into a personalized, goal-oriented system. This process is critical for long-term retention, as it:

Captures Declared Data: We gather the user's explicit goals, struggles, and preferences.
Demonstrates Value: The user sees how the app will be tailored to them, increasing their buy-in.
Establishes Commitment: By having the user co-create their program, they are psychologically more invested in its success.

Part 1: The Post-Registration Welcome (Step 1)
Immediately following a successful registration, the user's "state" has changed. This first screen acts as a psychological "soft landing" and a transition. Its sole purpose is to acknowledge the completion of the authentication phase and act as a simple, affirmative gateway to the next, more involved process.

Design & Implementation Blueprint
UI: A minimal, full-screen view.
Background: Black, consistent with the app's dark theme.
Content:
[App Logo] (Centered)
`` "Welcome to StayHard"
[Instruction] "Tap anywhere to continue"
Action: Any tap on the screen should trigger a simple, clean fade-out transition to the next part.
-> Here please refer for the file up_firstpage_example.dart (doc/user_profile_completion/up_firstpage_example.dart) i want that exactly UI and looks

Part 2: The Onboarding Value Proposition (Step 2)
This screen is the "why" for the entire flow. Before you ask a user to complete a 6-question survey, you must explicitly state the value they will receive in return. You are about to ask for their time and data; this screen promises them a "personalized transformation program" in exchange.

2.2. Design & Implementation Blueprint
UI: A full-screen view, visually similar to Part 1 for cohesion.
Background: Black (dark theme).
Content:
[App Logo] (Smaller, e.g., 30% of its original size, positioned higher on the screen).
[Headline] "Ready to start your life reset journey?"
`` "Answer a few quick questions to get your personalized transformation program."
`` A high-contrast, primary button with the text "Let's begin".
Action: Tapping "Let's begin" navigates the user to the first page of the questionnaire.
-> Here use same UI and design like in Part 1: The Post-Registration Welcome (Step 1)

Part 3: Analysis 1: Program Personalization (Step 3)
This is the first and most critical analysis. The 6-question survey is a data collection tool designed to map the user to one of five predefined "Program Archetypes". The goal is not to be generic, but to gather specific data points about the user's primary goal and current state.

The UI pattern for this is a multi-step form. This is crucial for reducing cognitive load; showing one question at a time is far less intimidating than a long, scrolling form.
3.2. Design & Implementation Blueprint

UI: A multi-page view (e.g., a PageView in Flutter).
Persistent Elements (Visible on all 6 pages):
`` "Question 1 of 6" (updates on each page).
`` A simple, linear progress bar at the top of the screen.
Per-Page Elements:
``
[Answer Options] (e.g., a list of large, tappable cards).
[Navigation] "Next" button (and "Back" if desired). The "Next" button on the final page (6 of 6) should trigger the navigation to the loading screen (Part 4).
-> For these pages (1 to 6) content, UI it must be exactly the same like in the example code document: 
-> Content for those 6 questions is found in doc\User_Profile_Completion\up_questionaire_content.dart
-> UI for this section is found in doc\User_Profile_Completion\up_questionaire_UI.dart

3.3. Core Content: Program Archetypes & Habits
Profile 1: "The Phoenix" (The Beginner / Rebuilder)
This user is starting from a place of difficulty. They feel lost, burnt out, or like they are starting over. Their "Accomplishment" (Q3) is a distant memory, and their "Struggle" (Q5) is "Lost in a fog" or "Running on empty." They need to build momentum from scratch.
Key Answer Mapping:
Q1: "The Great Reset," "Building from the Ashes"
Q3: "Distant echo," "Need to feel it again"
Q4: "Fear of staying stuck," "Feels like a battle"
Q5: "Lost in a fog," "Running on empty," "Adrift at sea"

Profile 2: "The Architect" (The Visionary Builder)
This user isn't starting from zero; they are starting with a vision. They are driven by "building a legacy" (Q2) or "conquering goals." Their struggle is translating that big-picture vision into a daily, disciplined reality. They need structure, focus, and productivity.
Key Answer Mapping:
Q1: "Forging the Hero," "The Ascent"
Q2: "Build a legacy," "Conquer my goals"
Q4: "The promises I've made to myself"
Q5: "Carrying a weight I can't put down" (the weight of their own vision)

Profile 3: "The Operator" (The High-Performer)
This user is already in motion. Their sense of accomplishment is "fresh" (Q3), and their mindset is about "competing and winning" (Q4). They aren't here to be fixed; they are here to be optimized. They are looking for an edge, and their program should be intense.
Key Answer Mapping:
Q1: "Declaring War on Mediocrity," "Forging the Hero"
Q2: "To become the strongest version of myself, period."
Q3: "The feeling is still fresh"
Q4: "The opportunity to compete and win the day"
Q5: (Likely selects few, or "Pressure to perform")

Profile 4: "The Stoic Path" (The Internal Warrior)
This user's primary battle is internal. Their struggle is an "invisible battle" (Q5) or "watching from the sidelines" (Q5). They are driven by a desire to "reclaim the narrative" (Q1) and live "without regrets" (Q2). They need habits focused on mental fortitude, mindfulness, and resilience.
Key Answer Mapping:
Q1: "Reclaiming the Narrative"
Q2: "To live a life without what-ifs or regrets"
Q4: "The pressure to perform," "Feels like a battle"
Q5: "Fighting an invisible, internal battle," "Watching my own life from the sidelines"

Profile 5: "The Pioneer" (The Young Founder)
This profile is defined by Age (Q6), specifically the "13-17" and "18-24" brackets. Their answers to other questions may be similar to The Phoenix or Architect, but their context is different. They are not re-building a life; they are building it for the first time. The tone should be aspirational, formative, and foundational.
Key Answer Mapping:
Q6: "13 - 17" or "18 - 24"
Q1: "Forging the Hero," "The Ascent"
Q2: "Inspire others," "Strongest version"
Q5: "Lost in a fog," "Adrift at sea"

Part 2: Predefined Habit Library 
1. The Core Habit Library (Universal)
These are 6 universal habits that will be recommended to ALL user profiles, regardless of their questionnaire answers. They form the non-negotiable "Core Program" of the StayHard app
- Habits for core habit library: Drink Water (atleast 2L / day), Read 10 pages, Plan your top 3 tasks for tommorow, Exercise (body, gym etc, walk, anything), Meditate, No Phone first 30 minutes after you wake up, Gratitude Practice
- Habits that are extra, some of them to no category and some added only to relevant categories: 
  - Deep Work Session (90 Mins) - Detail: Schedule and complete one 90-minute, uninterrupted block of high-focus work.
  - No Social Media (Focus) - Detail: No social media or "junk" websites until after your "Top 3 Tasks" are complete.
  - Learn a Skill (30 Mins) -Detail: Dedicate 30 minutes to focused practice or study of a specific skill (e.g., coding, language, an instrument).
  - Wake Up (No Snooze) - Detail: Get out of bed immediately when your first alarm rings. No snoozing.
  - Intense Exercise Sesson - Detail: Complete 30+ minutes of physical activity that significantly elevates your heart rate.
  - No Processed Sugar - Detail: Do not consume any processed sugars or sugary drinks for the entire day.
  - Journal - Detail: Journaling to process thoughts and emotions.
  - Make Your Bed - Detail: Make your bed immediately after waking up. Start the day with a completed task.
  - No Junk Food: A daily choice of long-term health over short-term pleasure.
  - No Alcohol: The "hard choice" for mental clarity and physical health.
  - No ADdictions - same 
  - "Embrace the Suck" (1x): Voluntarily do one physically uncomfortable thing.
  - Practice Self-Care (15m): The disciplined act of maintaining the "asset" (you).
  - Visualization: 5 minutes of visualizing success or a perfect day.   
  - Remember Your "Why": A 1-minute review of your core motivation.
  - Give Back / Be Kind: Practices humility and connection.

  Part 4: The Loading Screen (Step 4)
  4.1. Strategic Framework: Creating Perceived Value
This is a psychological transition. An instantaneous result after a 6-page questionnaire would feel cheap and pre-canned. By introducing a short, 3-5 second loading screen, you create a sense of perceived value. It communicates to the user that their answers are being processed and that a truly custom result is being generated for them.

4.2. Design & Implementation Blueprint
UI: A simple, full-screen view. 
Content:
[App Logo]
[Animated Indicator] (e.g., a custom loading spinner or pulsing animation).
`` "Analyzing your responses..." or "Building your custom program..."
Action: This screen should be shown for a fixed duration (e.g., 4 seconds) and then automatically transition to the Program Suggestion screen.

Part 5: The Program Recommendation (Step 5)
5.1. Strategic Framework: Delivering the "Aha Moment"
This screen delivers the payoff for the questionnaire. It presents the "answer" to the user's problem. The design must be compelling, clear, and make the user feel understood. It presents the suggested program as the "solution" and provides three clear paths forward, giving the user the ultimate control.
5.2. Design & Implementation Blueprint
-> Reffer to the design from doc\User_Profile_Completion\up_programrecommandation_UI.dart

Part 6: The Branching Logic: Other & Custom (Step 6)
This part consists of two distinct screens that are only shown if the user doesn't accept the initial recommendation.

6.1. Screen: "Choose Other Programs"
Purpose: To allow users to browse all available "pre-canned" programs.
UI: A scrollable list or grid of all 5 Program Archetypes.
Content: Each item in the list should show the Program Name  and a short tagline.
Action: Tapping any program navigates to a detail screen (which can reuse the exact same layout as the Program Recommendation screen in Part 5). This detail screen will have a "Select this program" button that navigates to Part 7 (Habit Configuration).

6.2. Screen: "Create a Custom Program"
Purpose: To give advanced or highly-specific users full control.
UI: A simple form.
Content:
`` "Program Name"
`` "Choose an icon for your program"
`` A way to add habits (e.g., from a master list or by creating a new custom habit).
Action: A "Save and Continue" button navigates to Part 7 (Habit Configuration), populated with the user's custom-selected habits.

Part 7: The Habit Configuration (Step 7)
All paths (Suggested, Other, Custom) converge on this screen. Its purpose is to have the user set their own baseline for each habit. This is crucial for two reasons:
Reduces Friction: It empowers the user to set realistic goals (e.g., 10m workout instead of 45m), which is vital for long-term adherence.
Data for Analysis 2: It provides the critical data needed for the next analysis.
7.2. Design & Implementation Blueprint
UI: A scrollable list of all habits in the user's chosen program. Each habit is presented as a card that needs configuration.
Per-Habit Configuration (Inputs):
1. Daily Time Commitment: (e.g., "How long per day?")
Options: [10 min, 20 min, 30 min, 45 min, Custom]
2. Current Practice Level: (e.g., "How familiar are you with this habit?")
Options:
Action: Once all habits are configured, a "Finish Setup" or "Next" button appears, which triggers the (invisible) Analysis 2 and navigates to Part 8.
-> Habits configuration UI must be exactly like in referenced document doc\User_Profile_Completion\up_habits_config_UI.dart

Part 8: Analysis 2 & Final Setup (Steps 8 & 9)
8.1. Strategic Framework: The Motivational Profile & Final Data
This final part of the flow collects the last pieces of information needed to fully personalize the app experience. It combines an invisible analysis with a visible 3-step setup.

8.2. Invisible Step: Analysis 2 (Motivational Profile)
Trigger: Happens in the background after the user completes Part 7.
Purpose: To define the tone of motivational notifications.
Logic: This analysis uses the data from Part 3 and Part 7 to create a "motivational profile".

Example 1: User chose  (Program) + "45m Workout" (Habit) + "Beginner" (Level).
Motivational Profile: High-Discipline Goal, Low-Discipline Skill.
Notification Tone: Encouraging ("The first step is the hardest. You took it. Keep going.").

Example 2: User chose "" + "45m Workout" + "Advanced".
Motivational Profile: High-Discipline Goal, High-Discipline Skill.
Notification Tone: Challenging ("Don't get comfortable. Someone else is working harder. Stay hard.").

8.3. Visible Step 1: Ask for Name
UI: A simple, single-field screen.
Content: "What should we call you?"
Purpose: To personalize all future communication (notifications, in-app messages).   

8.4. Visible Step 2: Notification Permission
UI: A 2-step "priming" process.   
Strategic Framework: This is the perfect moment to ask for notification permission. The user just completed two analyses to personalize their experience, including their notifications. The value is at its absolute peak.

Flow:
Priming Screen (Your UI): "To send your personalized motivation and habit reminders, 'StayHard' needs to send notifications." Include "Allow" and "Not now" buttons.
Native Prompt: If the user taps "Allow," then (and only then) show the official iOS/Android system permission dialog.
8.5. Visible Step 3: The Commitment Device
UI: A full-screen text-entry page.

Strategic Framework: This is a powerful psychological tool known as a Commitment Device. By having the user write a "word for their future self," they are making a tangible commitment, which increases follow-through. The app can later use this message to remind them of their goals (e.g., "Remember why you started? You wrote:...").

Content:
[Headline] "A word for your future self."
`` "Write a short message to the person you are becoming. We'll show this to you when you need it most."
``
Action: A "Finish" button.
Part 9: The Handoff (Step 10)
Action: After the user taps "Finish" on the Commitment Device screen, the Personalized Onboarding flow is complete.
Navigation: The app navigates the user, for the first time, to the main Homepage. All collected data (Program, Habits, Name, etc.) is saved to the user's profile.