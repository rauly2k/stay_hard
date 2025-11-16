This document outlines the strategic framework and implementation plan for the Alarms tab. In the "StayHard" ecosystem, this is not a passive utility for reminders; it is an active tool for building discipline. Its primary purpose is to serve as a "conscious" alarm clock, ensuring the user is mentally and physically engaged from the moment they wake up.

Most apps in this space fail to distinguish between reminders (passive, easily-dismissed notifications) and alarms (active, high-priority, "must-action" events). Our Alarms tab will be the latter. It is designed to solve a core problem: the "snooze" button.

By forcing the user to complete a cognitive or physical challenge to silence the alarm, we are building a "Proof-of-Wakefulness" system. This transforms the first act of the day from a moment of weakness (hitting snooze) into a moment of discipline (winning a challenge).

Part 1: Strategic Framework & Information Architecture (IA)
1.1. Alarms vs. Reminders
A clear distinction must be made for the user:

Alarms (This Tab): These are for starting a major block of time, primarily waking up. They are high-friction, full-screen events that run as a background service, play a continuous sound, and require a challenge to be solved.

Reminders (Future Feature): These are simple, low-friction, one-time notifications. They will be attached directly to habits (e.g., "Remind me to 'Read 10 Pages' at 9 PM"). These are not handled in the Alarms tab.
This separation is critical for a clean user experience. The Alarms tab is the "heavy-duty" tool for the most important battle: waking up.

1.2. The "Proof-of-Wakefulness" (PoW) Concept
The core of this feature is the set of dismissal challenges. These are non-negotiable gates that prove the user is cognitively "online" and not just sleep-swiping.

Classic: A simple "Slide to Dismiss" for low-friction days.

Math Challenge: Forces the brain's logical centers to activate.

Text Typing Challenge: Engages motor skills and reading comprehension.

Custom Text Challenge: Acts as a powerful commitment device. Forcing the user to type their own goal (e.g., "I WILL WIN THE DAY") at 5 AM reinforces their "why" from the moment their eyes open.

1.3. Technical Architecture: The Background Service
To be a reliable alarm, this service must work even if the app is terminated. This requires a robust background execution and notification system.

The system must schedule a task that can wake the device.

It needs to trigger a full-screen overlay, even on the lock screen. This is known as a "full-screen intent" on Android.

It must be able to play a looping audio file and trigger vibration from a background service.

The alarm package for Flutter is designed for this exact use case, handling the foreground service, full-screen intent, audio, and vibration natively.

Part 2: The User Flow: Setting & Editing an Alarm
2.1. Screen 1: AlarmsListScreen (Main Tab)
Purpose: The main dashboard for viewing and managing all created alarms.

UI:

An AppBar with the title "Alarms."

A FloatingActionButton with an Icons.add icon to navigate to the AlarmEditScreen.

A ListView of all alarms. Each item in the list is a "Alarm Card" that displays:

The time (e.g., "06:00").

The label (e.g., "Wake Up").

The repeat days (e.g., "Weekdays").

A Switch to toggle the alarm isEnabled (on/off).

Tapping the card itself navigates to the AlarmEditScreen to edit it.

2.2. Screen 2: AlarmEditScreen (Add/Edit)
Purpose: To create or modify a single alarm's settings.

UI: A form with the following options:

Time: A time picker (e.g., a standard dial time picker).

Repeat: A ToggleButtons row for days (M, T, W, T, F, S, S) and options for "Once," "Weekdays," etc.

Label: A TextField for the alarm name (e.g., "Workout," "Wake Up").

Sound: A selection list (e.g., "Radar," "Apex," "Ascend").

Vibration: A Switch (default: on).

Dismissal Method: A selection list or dropdown.

Dismissal Method Logic: When the user selects a dismissal method, the UI updates to show its specific options:

If "Classic": No further options.

If "Math Challenge": Show 3 choices (e.g., "Easy," "Medium," "Hard").

If "Text Typing Challenge": Show 3 choices (e.g., "Easy," "Medium," "Hard").

If "Custom Text Challenge": Show a TextField prompting "Enter your dismissal text" (e.g., "I WILL WIN THE DAY").

Action: A "Save" button. Tapping this validates the form, creates an AlarmSettings object, and saves it to the device using the alarm package's Alarm.set() method.

Part 3: The "Alarm Firing" Experience (Full-Screen UI)
This is the most critical UI of the feature. When the background service fires, the app will be brought to the foreground (even from a locked state) to display this screen.

3.1. Screen 3: AlarmChallengeScreen
Purpose: The full-screen overlay that is the alarm. The user cannot leave this screen until the challenge is complete.

Audio/Haptics: As soon as this screen loads, the selected alarm sound begins playing on loop, and the vibration starts.

UI: A full-screen, dark-themed (black) view.

Top: Large digital clock showing the current time.

Middle: The alarm label (e.g., "WAKE UP").

Quote: A motivational quote displayed clearly.

Strategy: The app will have a pre-loaded list of quotes (fetched from an API like ZenQuotes or a Stoic API and cached locally). A random quote is shown with each alarm.

Bottom (The Challenge): This is the main interactive area. The UI here changes based on the DismissalMethod set for this alarm:

Classic: A simple "Slide to Dismiss" button.

Math Challenge:

Text("Solve to dismiss: 14 + 8 =?")

A simple number pad for input.

An "Enter" button. (If wrong, it shows an error and generates a new problem).

Text Typing Challenge:

Text("Type to dismiss: 'Discipline is freedom'")

A TextField that shows the system keyboard.

The alarm stops only when the string is a perfect match (case-insensitive).

Custom Text Challenge:

Text("Type your commitment: 'I WILL WIN THE DAY'")

A TextField for the user to type their custom phrase.

Action (On Success):

The challenge is successfully completed.

The audio and vibration immediately stop.

The app navigates the user away from the AlarmChallengeScreen and back to the Homepage.

(V2 Feature): A prompt appears: "You're up. Ready to start your first habit: 'Make Your Bed'?"