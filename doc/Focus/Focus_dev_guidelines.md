Introduction: Winning the War on Distraction
This document outlines the strategic framework and implementation plan for the Focus tab. This feature is the "shield" of the "StayHard" ecosystem.

The Homepage is the daily plan.
The Goals tab is the long-term "why."
The Alarms tab is the tool to win the morning.
The Focus tab is the active-defense system that protects the user's most valuable asset: their time.

This feature is designed to solve the central problem of modern self-discipline: digital distraction. It does this by providing two distinct tools:

The Focus Timer: A tool for proactive focus (e.g., "I will now work for 25 minutes"). This is often based on the Pomodoro Technique.
The Distraction Blocker: A tool for reactive defense (e.g., "Block Instagram"). This is the "Commitment Shield" you described.
The true innovation of this plan lies in the Personalized Intervention System, which uses the user's own goals and profile data to create a high-friction, personalized barrier against their worst impulses.

Part 1: Strategic Framework - The Commitment Shield
The "Focus" tab operates on the principle of a Commitment Device. It acknowledges that the user exists in two states:

The "Cold" State: The rational, disciplined user who navigates to the Focus tab and sets a rule (e.g., "Block social media").

The "Hot" State: The impulsive, distracted user who, hours later, unconsciously taps the "Instagram" icon.

The app's job is to be the "shield" created by the "cold" state user to protect them from the "hot" state user. The user's request for personalized messaging is the key to this, as it weaponizes their own declared intentions at the precise moment of failure.
The system will have two main modes:
Total Block: For apps the user deems "toxic" (e.g., endless-scroll social media).
Time Limit: For apps the user wants to manage but not eliminate (e.g., "Allow 60 minutes of YouTube per day").

Part 2: The User Flow: Setting the "Shield"
This flow details how a user establishes a new blocking or limiting rule.

Screen 1: FocusDashboardScreen (Main Tab)
Purpose: The main dashboard for the Focus tab.
UI (Top Half): The "Focus Timer" (see Part 5).
UI (Bottom Half): The "Distraction Blocker" rules.
A list of "Active Time Limits" (e.g., "Instagram: 42 of 60 minutes used").
A list of "Blocked Apps" (e.g., "TikTok," "Reddit").
Action: A FloatingActionButton with an "Add Rule" icon.

Screen 2: SelectRuleTypeScreen
Purpose: Ask the user what kind of rule to create.
UI: Two large, clear buttons:
"Block Apps": (Block apps completely).
"Limit App Usage": (Set a daily time limit).

Screen 3: SelectAppsScreen
Purpose: Choose which apps the rule applies to.
UI: A list of all applications installed on the user's device.
Action: User selects one or more apps (e.g., [X] Instagram, [X] TikTok).
Technical Note: This requires native permissions to query the list of installed applications.

Screen 4: SetTimeLimitScreen (Only for "Limit App Usage" flow)
Purpose: Define the daily time allowance.
UI: A time picker.
Action: User selects a duration (e.g., "60 minutes per day").
Screen 5: SetReasonScreen (The Critical Step)
Purpose: To capture the user's "why," which will power the intervention.
UI: A simple screen with a TextField.
Prompt (Headline): "Why are you blocking this app?"
Prompt (Sub-text): "Be honest. We will use this to hold you accountable."
Example User Input: "I'm wasting hours scrolling when I should be working on my business."
Action: User taps "Save Rule." The rule is now active, and the "Reason" is saved to their profile.

Part 3: The Intervention System (The "Shield" in Action)
This is the core flow that activates when a user attempts to violate their own rule.

3.1. Technical Trigger
Detection: A background service must be running, monitoring the user's device activity.

On Android: This is highly feasible using the UsageStatsManager to detect the current foreground app.

On iOS: This is extremely difficult. It cannot be done by a normal app. It requires the FamilyControls entitlement and the Screen Time API. This entitlement must be requested and approved by Apple, as it's intended for parental control apps. This is a major technical hurdle that must be acknowledged.

Action: When the service detects the launch of a blocked app (or the usage limit is exceeded), it brings the "StayHard" app to the foreground and displays the InterventionOverlayScreen.

3.2. Screen 6: InterventionOverlayScreen (Gate 1)
Purpose: The first "shield." A full-screen overlay that interrupts the user's action.

UI:
Headline: You are trying to open [Instagram].
Personalized Message (The "AI" Coach): This is a dynamic message constructed from the user's own profile data.

Template:
"You told us you set this block because:"
``
"Is this action helping you achieve your goal of [User's Program Name]?"
"Remember what you told your future self:"
[User's 'Commitment Message' from Onboarding]

Example Message:
"You told us you set this block because:"
"I'm wasting hours scrolling when I should be working on my business."
"Is this action helping you achieve your goal of The Deep Work Craftsman?"
"Remember what you told your future self:"
"I will not let small distractions kill my big dreams."

Buttons:
"You're right. Back to work." (Primary CTA. Dismisses the overlay and returns the user to the Homepage).
"Open the app anyway." (Secondary CTA. Acknowledges the failure and navigates to Gate 2).

3.3. Screen 7: FinalFrictionScreen (Gate 2)
Purpose: To add one final layer of high friction, forcing the user to consciously confirm their failure.
UI: A simple, stark screen.
Message: "This is a conscious choice. Opening this app will be logged in your Analytics as a broken commitment. Are you sure you want to proceed?"

Buttons:
"Yes, open the app." (Dismisses the overlay, and allows the blocked app to open. Logs the failure).
"No, I'll stay focused." (Returns the user to the Homepage).

Part 4: The Focus Timer (Pomodoro)
The Focus tab will also house a "Focus Timer". This is a common and expected feature in productivity apps. This is much easier to implement (especially on iOS) and provides immediate value.

4.1. Strategic Framework
The Forest app is the most successful example of this. It's not a technical blocker, but a psychological one. The user "plants a tree" for a set time (e.g., 25 minutes). If they leave the app, the tree "dies." This is a brilliant, low-tech way to enforce focus.

4.2. Design & Implementation Blueprint
UI: The top half of the FocusDashboardScreen.

Components:

A large timer (e.g., "25:00").

A "Start Focus Session" button.
(Optional) A dropdown to link the session to a specific habit (e.g., "Read 10 Pages," "90m Deep Work").

Gamification (The "StayHard" version of Forest):
When the user starts, the message reads: "Focus session active. Don't be weak. Leaving the app will break your commitment."
If the user backgrounds the app, a "focus lost" event is logged. When they return, a message is shown: "You broke your focus. Start again."

4.3. Recommendation
Implement the Focus Timer (Part 4) first. It fully delivers on the "Focus" promise, is 100% compliant with all app stores, and is technically straightforward.
Implement the Distraction Blocker (Parts 2 & 3) as a "V2" or "Pro" feature, starting with Android-only, while you pursue the complex FamilyControls entitlement from Apple for the iOS version.

Here is the developer-focused implementation plan for Claude, formatted as a markdown file.

App "Focus System" Implementation Plan (Phase 6)
1. Overview
This plan details the implementation of the Focus tab. This is a two-part feature:

Focus Timer (Pomodoro): A timer (like Forest) to encourage focus on a single task. This is the V1.

Distraction Blocker: A system to block or limit other apps. This is the V2, as it requires extensive native integration.

2. Module 1: FocusDashboardScreen (Main Tab UI)
Widget: FocusDashboardScreen.dart (StatefulWidget).

UI: Scaffold with AppBar (Title: "Focus").

Body: A Column containing two main sections.

Section 1: Focus Timer (Module 2).

Section 2: Distraction Blocker (Module 3).

3. Module 2: Focus Timer (V1 Implementation)
This module provides the core "Pomodoro" functionality.

UI: A Card at the top of the FocusDashboardScreen.

Large Text widget to display the timer (e.g., "25:00").

A DropdownButton to select a linked habit (e.g., "Deep Work").

"Start Focus Session" ElevatedButton.

Logic (State):

Use a Timer to manage the countdown.

Store isTimerRunning (bool).

Gamification (The "Forest" Model):

Make the FocusDashboardScreen a WidgetsBindingObserver.

@override void didChangeAppLifecycleState(AppLifecycleState state)

Logic:

if (state == AppLifecycleState.paused && isTimerRunning)

{ // User left the app! Log failure. }

When the user returns, show a dialog: "You broke your focus. A true "StayHard" disciple sees it through. Start again."

4. Module 3: Distraction Blocker (V2 Setup Flow)
This is the flow for creating a new blocking rule.

FocusDashboardScreen (Bottom Half):

FloatingActionButton with Icons.add.

onPressed: Navigator.push to SelectRuleTypeScreen.

SelectRuleTypeScreen.dart:

Two buttons: "Block Apps" and "Limit App Usage."

onPressed: Navigate to SelectAppsScreen, passing the RuleType.

SelectAppsScreen.dart:

Native Code Required: Use a MethodChannel to call native code (Android/iOS) to get a list of all installed, non-system applications.

UI: Display the list of apps with CheckboxListTile.

onPressed("Next"): Navigate to SetReasonScreen (or SetTimeLimitScreen if RuleType == Limit).

SetTimeLimitScreen.dart:

A duration picker. Save the duration.

SetReasonScreen.dart:

A TextField for the user's "Reason."

On "Save":

Save the rule (e.g., appName, limitInMinutes, reason) to the local database / Firebase.

This data will be used by the background service.

5. Module 4: Distraction Blocker (V2 Intervention System)
This is the most complex part of the app. It requires running a persistent background service to monitor app usage.

5.1. Android Implementation (Kotlin/Java)
Permission: Request PACKAGE_USAGE_STATS (takes user to settings) and AccessibilityService.

Service: Create a foreground AccessibilityService. This is more reliable than UsageStatsManager for instant event detection.

Logic:

onAccessibilityEvent(AccessibilityEvent event):

Listen for event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED.

Get the packageName of the new window.

Check this packageName against the user's saved blocking rules.

If match found:

Launch the "StayHard" app and show the InterventionOverlayScreen.

Pass the app name and the saved "Reason" as arguments.

5.2. iOS Implementation (Swift)
Entitlement: This entire feature is blocked by Apple unless you get the com.apple.developer.family-controls entitlement.

Process:

Apply for the entitlement from Apple. This is a manual review.

If approved, implement using the native Screen Time API.

Use DeviceActivityMonitor and ManagedSettings to block apps.

This is a 100% native implementation and cannot be done with Dart alone.

V1 Alternative (Website Blocker): A simpler V1 for iOS is to use the NetworkExtension framework to set up a local VPN profile that blocks domains (e.g., "instagram.com") but not apps.

6. Module 5: Intervention UI (Flutter)
These screens are shown by the background service.

InterventionOverlayScreen.dart (Gate 1)

Input: String appName, String reason, String userProgram, String commitmentMessage.

UI: Full-screen, dark, modal-like page.

PopScope(canPop: false,...) to prevent user from backing out.

Display the dynamic message as specified in the main document.

Button: "You're right. Back to work." -> Navigator.pop(context);

Button: "Open the app anyway." -> Navigator.push to FinalFrictionScreen.

FinalFrictionScreen.dart (Gate 2)

PopScope(canPop: false,...)

Display the "Are you sure?" message.

Button: "Yes, open the app." -> Navigator.of(context).popUntil((route) => route.isFirst); (Dismisses all overlays, returning user to the OS. The background service must then "allow" the app for this session).

Button: "No, I'll stay focused." -> Navigator.pop(context); (Goes back to Gate 1).