# Habit System Redesign: Implementation Guide

## Overview

This document outlines the complete redesign of the Stay Hard habit categorization system and maps the 5 personality archetypes to specific habits from the new categories.

**Key Concept:**
- **Categories** (CORE, STRENGTH, CLARITY, RESILIENCE, MASTERY, LEGACY) = Organizational structure for browsing and discovering habits
- **Archetypes** (Phoenix, Architect, Operator, Stoic, Pioneer) = Personalized programs that curate specific habits from the categories

---

## Part 1: New Categorization System

### **6 HABIT CATEGORIES**

#### **1. CORE** (Foundation Habits)
*Non-negotiable daily essentials that power everything else*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| core_001 | Hydrate (2L+ Water) | Quantity | 8 glasses or 2L | Track daily water intake - foundational for all body systems |
| core_002 | Daily Movement (20+ Min) | Duration | 20 min | Walk, stretch, light cardio - minimum viable physical activity |
| core_003 | Read Daily (10+ Pages) | Quantity | 10 pages | Books, articles, learning - continuous mental stimulation |
| core_004 | Whole Foods Nutrition | Checkbox | - | Eat clean, limit processed foods, fuel your body right |
| core_005 | Consistent Sleep Rhythm | Time | 06:00 | Wake at same time daily to maintain sleep schedule |
| core_006 | Screen-Free Before Bed | Checkbox | - | No screens 30-60 min before sleep for better rest quality |

---

#### **2. STRENGTH** (Physical Health)
*Build a body that supports your ambitions*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| strength_001 | Intense Training | Duration | 60 min | Structured workouts, gym sessions, push limits |
| strength_002 | Cardio Endurance | Duration | 30 min | Running, cycling, swimming, HIIT - build stamina |
| strength_003 | Strength Training | Duration | 45 min | Lift weights, resistance training, build power |
| strength_004 | Mobility & Flexibility | Duration | 20 min | Yoga, stretching, foam rolling, movement quality |
| strength_005 | No Alcohol | Checkbox | - | Eliminate alcohol consumption |
| strength_006 | No Junk Food | Checkbox | - | Avoid processed/fast food |
| strength_007 | No Processed Sugar | Checkbox | - | Limit or eliminate added sugars |
| strength_008 | Active Recovery | Checkbox | - | Walk, light movement, rest day activity |
| strength_009 | Cold Exposure | Duration | 5 min | Cold showers, ice baths, build physical resilience |

---

#### **3. CLARITY** (Mental Performance)
*Sharpen your mind and eliminate distractions*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| clarity_001 | Deep Work Session | Duration | 90 min | Dedicated focus time on important work |
| clarity_002 | Learn a New Skill | Duration | 30 min | Practice skill, take course, deliberate learning |
| clarity_003 | No Social Media | Checkbox | - | Eliminate or drastically reduce social media use |
| clarity_004 | No Phone Morning | Checkbox | - | First 30-60 minutes phone-free after waking |
| clarity_005 | Digital Detox Hour | Duration | 60 min | 1+ hour daily completely screen-free |
| clarity_006 | Single-Task Focus | Checkbox | - | Work on one thing at a time, no multitasking |
| clarity_007 | Brain Training | Duration | 15 min | Puzzles, chess, language learning, cognitive challenges |
| clarity_008 | Creative Output | Duration | 30 min | Write, create, build, make something |

---

#### **4. RESILIENCE** (Emotional Mastery)
*Develop inner strength and emotional intelligence*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| resilience_001 | Meditate | Duration | 20 min | Mindfulness, breathwork, stillness practice |
| resilience_002 | Gratitude Practice | Quantity | 3 items | Write 3+ things you're grateful for |
| resilience_003 | Journal | Duration | 15 min | Reflect, process emotions, self-awareness |
| resilience_004 | Remember Your Why | Checkbox | - | Review your purpose, vision, core motivations |
| resilience_005 | Visualization | Duration | 10 min | Mental rehearsal of goals, success visualization |
| resilience_006 | Embrace the Suck | Checkbox | - | Do the hardest/most uncomfortable task first |
| resilience_007 | Emotional Check-In | Checkbox | - | Track mood, energy, stress levels |
| resilience_008 | Breathwork Practice | Duration | 10 min | Wim Hof, box breathing, stress management breathing |

---

#### **5. MASTERY** (Discipline & Systems)
*Own your day through structure and consistency*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| mastery_001 | Wake Up (No Snooze) | Time | 06:00 | Get up immediately when alarm sounds |
| mastery_002 | Make Your Bed | Checkbox | - | Start day with immediate win |
| mastery_003 | Plan Top 3 Tasks | Checkbox | - | Identify and prioritize day's most important work |
| mastery_004 | Time Blocking | Checkbox | - | Schedule day in advance, allocate time to priorities |
| mastery_005 | Weekly Review | Checkbox | - | Reflect on week, plan ahead, adjust systems (weekly repeat) |
| mastery_006 | Daily Check-In | Checkbox | - | Morning or evening reflection on progress |
| mastery_007 | Track Progress | Checkbox | - | Log metrics, journal wins, measure what matters |
| mastery_008 | Prep Tomorrow Tonight | Checkbox | - | Evening routine to set up next day |
| mastery_009 | Morning Routine | Duration | 30 min | Structured morning sequence |
| mastery_010 | Evening Routine | Duration | 30 min | Wind-down ritual before bed |

---

#### **6. LEGACY** (Growth & Purpose)
*Think bigger, build longer, leave your mark*

| Habit ID | Habit Name | Type | Target | Description |
|----------|------------|------|--------|-------------|
| legacy_001 | Work on Passion Project | Duration | 60 min | Side hustle, creative project, future-building work |
| legacy_002 | Goal Review | Checkbox | - | Review quarterly/annual goals, align daily actions (weekly) |
| legacy_003 | Vision Work | Duration | 30 min | Long-term planning, 5/10-year thinking, life design |
| legacy_004 | Skill Mastery | Duration | 60 min | Dedicate time to mastering specific skill for long-term impact |
| legacy_005 | Give Back / Contribute | Duration | 30 min | Mentor, volunteer, help others, create value |
| legacy_006 | Build in Public | Checkbox | - | Share progress, document journey, create content |
| legacy_007 | Learn from Mentors | Duration | 30 min | Study leaders, consume high-value content, seek wisdom |
| legacy_008 | Financial Growth | Checkbox | - | Work on finances, invest, build wealth |

---

## Part 2: Archetype-to-Habit Mapping

### **Understanding the Relationship**

**Categories** are organizational buckets that help users:
- Browse and discover new habits
- Understand what area of life each habit impacts
- Add habits to their custom program

**Archetypes** are personality-driven programs that:
- Pre-select specific habits from categories based on user psychology
- Create a cohesive, curated starting point
- Provide personalized recommendations

**Users experience:**
1. Take questionnaire → Get matched to archetype (e.g., Phoenix)
2. See recommended program with specific habits from various categories
3. Can browse all categories to add/remove habits as needed
4. Categories visible in "Add Habit" flow for discovering additional habits

---

## Part 3: Archetype Programs (Redesigned)

### **ARCHETYPE 1: THE PHOENIX** 🔥
**Profile:** The Beginner/Rebuilder
**Color:** Orange (#FF6B35)
**Icon:** Fire/Phoenix

**User Characteristics:**
- Starting from difficulty or hitting restart
- Feeling lost, burnt out, or overwhelmed
- Past accomplishments feel distant
- Morning feels like a battle
- Struggling with multiple life challenges

**Program Philosophy:**
"Rise from the ashes" - Build momentum from ground zero with fundamental, achievable habits. Focus on consistency over intensity. Small wins compound into transformation.

**Core Habits (7-9 habits):**

| Habit ID | Habit Name | Category | Time of Day | Why This Habit |
|----------|------------|----------|-------------|----------------|
| core_001 | Hydrate (2L+ Water) | CORE | Morning/All Day | Simple, immediate win; builds awareness of body needs |
| core_002 | Daily Movement (20+ Min) | CORE | Morning | Low barrier to entry; builds physical momentum |
| core_003 | Read Daily (10+ Pages) | CORE | Evening | Mental stimulation without overwhelm; achievable daily |
| mastery_002 | Make Your Bed | MASTERY | Morning | Immediate morning win; environmental control |
| clarity_004 | No Phone Morning | CLARITY | Morning | Reclaim morning focus; reduce overwhelm |
| resilience_002 | Gratitude Practice | RESILIENCE | Evening | Shift mindset from difficulty to appreciation |
| mastery_003 | Plan Top 3 Tasks | MASTERY | Morning | Create direction; reduce feeling of being lost |
| strength_006 | No Junk Food | STRENGTH | All Day | Remove obstacle to physical recovery |
| core_005 | Consistent Sleep Rhythm | CORE | Morning | Build foundational rhythm for stability |

**Program Summary:**
9 habits focused on **foundations, small wins, and rebuilding momentum**. Emphasis on morning structure, basic self-care, and achievable daily tasks.

---

### **ARCHETYPE 2: THE ARCHITECT** 🏛️
**Profile:** The Visionary Builder
**Color:** Blue (#277DA1)
**Icon:** Architecture/Blueprint

**User Characteristics:**
- Has clear vision for future legacy
- Wants to build something that outlasts them
- Sees mornings as opportunities with pressure to perform
- Goal-oriented and systematic
- May struggle with fog or lack of map despite vision

**Program Philosophy:**
"Design and build your legacy" - Structure and systems-focused approach. Productivity and planning habits prioritized. Long-term thinking with sustainable daily execution.

**Core Habits (8-10 habits):**

| Habit ID | Habit Name | Category | Time of Day | Why This Habit |
|----------|------------|----------|-------------|----------------|
| core_001 | Hydrate (2L+ Water) | CORE | All Day | Foundational for sustained energy and focus |
| core_003 | Read Daily (10+ Pages) | CORE | Evening | Continuous learning to inform vision |
| mastery_001 | Wake Up (No Snooze) | MASTERY | Morning | Start day with discipline and intention |
| mastery_003 | Plan Top 3 Tasks | MASTERY | Morning | Align daily actions with long-term goals |
| clarity_001 | Deep Work Session | CLARITY | Morning | Execute on vision with focused productivity |
| strength_002 | Cardio Endurance | STRENGTH | Morning/Afternoon | Physical health supports mental performance |
| resilience_005 | Visualization | RESILIENCE | Morning | Mental rehearsal of legacy being built |
| legacy_001 | Work on Passion Project | LEGACY | Afternoon/Evening | Direct action toward building future |
| mastery_004 | Time Blocking | MASTERY | Morning | Strategic time management for big goals |
| legacy_002 | Goal Review | LEGACY | Weekly | Ensure daily work aligns with quarterly/annual vision |

**Program Summary:**
10 habits focused on **strategic planning, focused execution, and long-term building**. Emphasis on productivity systems, vision alignment, and sustained effort toward legacy.

---

### **ARCHETYPE 3: THE OPERATOR** 🚀
**Profile:** The High-Performer
**Color:** Red (#F94144)
**Icon:** Rocket/Target

**User Characteristics:**
- Already in motion, seeking optimization
- Sees life as competition to win
- Accomplishments are fresh or recent
- Thrives on challenge and intensity
- May fear staying stuck or not maximizing potential

**Program Philosophy:**
"Optimize for peak performance" - Intense, high-commitment habit stack. Push beyond comfort zone. Embrace difficulty as growth mechanism. Continuous improvement mindset.

**Core Habits (10-12 habits):**

| Habit ID | Habit Name | Category | Time of Day | Why This Habit |
|----------|------------|----------|-------------|----------------|
| mastery_001 | Wake Up (No Snooze) | MASTERY | Morning | Non-negotiable discipline from first moment |
| core_001 | Hydrate (2L+ Water) | CORE | All Day | Optimize physical performance baseline |
| strength_001 | Intense Training | STRENGTH | Morning | Push physical limits; build mental toughness |
| clarity_001 | Deep Work Session | CLARITY | Morning/Afternoon | Maximum productivity and focus |
| clarity_003 | No Social Media | CLARITY | All Day | Eliminate distraction; reclaim attention |
| core_003 | Read Daily (10+ Pages) | CORE | Evening | Continuous learning for competitive edge |
| mastery_003 | Plan Top 3 Tasks | MASTERY | Morning | Strategic prioritization for maximum impact |
| resilience_006 | Embrace the Suck | RESILIENCE | Morning | Do hardest task first; build resilience |
| strength_009 | Cold Exposure | STRENGTH | Morning | Voluntary discomfort; mental fortitude |
| clarity_002 | Learn a New Skill | CLARITY | Afternoon/Evening | Continuous improvement and growth |
| legacy_004 | Skill Mastery | LEGACY | Evening | Deep mastery for long-term dominance |
| mastery_007 | Track Progress | MASTERY | Evening | Measure performance; optimize relentlessly |

**Program Summary:**
12 habits focused on **intensity, optimization, and peak performance**. Emphasis on discipline, elimination of weakness, voluntary discomfort, and relentless improvement.

---

### **ARCHETYPE 4: THE STOIC PATH** 🌿
**Profile:** The Internal Warrior
**Color:** Green (#90BE6D)
**Icon:** Psychology/Balance

**User Characteristics:**
- Fighting invisible internal battles
- Seeking to reclaim personal narrative
- Carrying emotional/mental weight
- Mornings feel heavy with promises made to self
- Focus on inner strength over external achievement

**Program Philosophy:**
"Build mental fortitude from within" - Mindfulness and introspection prioritized. Resilience through self-awareness. Internal metrics over external validation. Process over outcomes.

**Core Habits (8-10 habits):**

| Habit ID | Habit Name | Category | Time of Day | Why This Habit |
|----------|------------|----------|-------------|----------------|
| core_001 | Hydrate (2L+ Water) | CORE | All Day | Care for physical vessel as foundation |
| core_003 | Read Daily (10+ Pages) | CORE | Evening | Wisdom and perspective from others |
| resilience_001 | Meditate | RESILIENCE | Morning | Build inner stillness and awareness |
| resilience_003 | Journal | RESILIENCE | Evening | Process emotions; self-understanding |
| resilience_002 | Gratitude Practice | RESILIENCE | Evening | Shift focus to what's working |
| resilience_004 | Remember Your Why | RESILIENCE | Morning | Ground in purpose despite struggles |
| strength_004 | Mobility & Flexibility | STRENGTH | Morning/Evening | Mindful movement; body awareness |
| clarity_004 | No Phone Morning | CLARITY | Morning | Protect sacred morning space |
| core_002 | Daily Movement (20+ Min) | CORE | Afternoon | Gentle physical practice; walk in nature |
| resilience_008 | Breathwork Practice | RESILIENCE | Morning/Afternoon | Active stress management; calm nervous system |

**Program Summary:**
10 habits focused on **inner work, emotional processing, and mindful awareness**. Emphasis on meditation, journaling, gratitude, and gentle physical practices. Internal strength building.

---

### **ARCHETYPE 5: THE PIONEER** 🧭
**Profile:** The Young Founder
**Color:** Amber (#FFB703)
**Icon:** Compass/Explore

**User Characteristics:**
- Younger users (13-24 age range typically)
- Building life foundation for first time
- Fresh start with minimal bad habits to break
- Open to guidance and structure
- Long-term trajectory focus

**Program Philosophy:**
"Build the right foundation early" - Formative, foundational habits. Set up patterns for lifetime success. Education and growth oriented. Balance discipline with exploration.

**Core Habits (8-10 habits):**

| Habit ID | Habit Name | Category | Time of Day | Why This Habit |
|----------|------------|----------|-------------|----------------|
| core_001 | Hydrate (2L+ Water) | CORE | All Day | Establish basic health awareness early |
| core_002 | Daily Movement (20+ Min) | CORE | Morning/Afternoon | Build physical activity as lifelong habit |
| core_003 | Read Daily (10+ Pages) | CORE | Evening | Cultivate reading habit for continuous learning |
| mastery_001 | Wake Up (No Snooze) | MASTERY | Morning | Build discipline foundation from day one |
| mastery_002 | Make Your Bed | MASTERY | Morning | Start day with immediate accomplishment |
| strength_002 | Cardio Endurance | STRENGTH | Afternoon | Build physical fitness early |
| clarity_002 | Learn a New Skill | CLARITY | Afternoon/Evening | Exploration and skill acquisition |
| mastery_003 | Plan Top 3 Tasks | MASTERY | Morning | Learn prioritization and focus young |
| resilience_002 | Gratitude Practice | RESILIENCE | Evening | Develop positive mindset early |
| legacy_007 | Learn from Mentors | LEGACY | Evening | Study those ahead on the path |

**Program Summary:**
10 habits focused on **building strong foundations early in life**. Emphasis on establishing core disciplines, physical health, learning habits, and positive mindset before bad habits form.

---

## Part 4: Implementation Changes Required

### **1. Data Model Updates**

#### **Habit Template Structure (Constants/Models)**

```dart
class HabitTemplate {
  final String id;              // e.g., "core_001"
  final String name;            // e.g., "Hydrate (2L+ Water)"
  final HabitCategory category; // NEW: enum for 6 categories
  final String description;
  final HabitType type;         // duration, quantity, time, checkbox
  final dynamic defaultTarget;  // e.g., 8 (glasses), 20 (minutes), "06:00"
  final String icon;
  final TimeOfDay? defaultTimeOfDay;
  final List<String> tags;      // Optional: for filtering/search
}

enum HabitCategory {
  core,        // CORE - Foundation
  strength,    // STRENGTH - Physical Health
  clarity,     // CLARITY - Mental Performance
  resilience,  // RESILIENCE - Emotional Mastery
  mastery,     // MASTERY - Discipline & Systems
  legacy,      // LEGACY - Growth & Purpose
}
```

#### **Program/Archetype Structure**

```dart
class ProgramArchetype {
  final String id;              // e.g., "phoenix"
  final String name;            // e.g., "The Phoenix"
  final String tagline;         // e.g., "Rise from the ashes"
  final String description;
  final Color color;
  final IconData icon;
  final List<String> coreHabitIds; // NEW: List of habit IDs from templates
  final String philosophy;
  final List<String> userCharacteristics;
}
```

---

### **2. Template Definitions File Structure**

**File:** `lib/core/constants/habit_templates.dart`

```dart
// CATEGORY 1: CORE HABITS
final List<HabitTemplate> coreHabits = [
  HabitTemplate(
    id: 'core_001',
    name: 'Hydrate (2L+ Water)',
    category: HabitCategory.core,
    description: 'Track daily water intake - foundational for all body systems',
    type: HabitType.quantity,
    defaultTarget: 8, // glasses
    icon: 'water_drop',
    defaultTimeOfDay: TimeOfDay.allDay,
    tags: ['hydration', 'health', 'foundation'],
  ),
  HabitTemplate(
    id: 'core_002',
    name: 'Daily Movement (20+ Min)',
    category: HabitCategory.core,
    description: 'Walk, stretch, light cardio - minimum viable physical activity',
    type: HabitType.duration,
    defaultTarget: 20, // minutes
    icon: 'directions_walk',
    defaultTimeOfDay: TimeOfDay.morning,
    tags: ['movement', 'exercise', 'foundation'],
  ),
  // ... continue for all CORE habits
];

// CATEGORY 2: STRENGTH HABITS
final List<HabitTemplate> strengthHabits = [
  HabitTemplate(
    id: 'strength_001',
    name: 'Intense Training',
    category: HabitCategory.strength,
    description: 'Structured workouts, gym sessions, push limits',
    type: HabitType.duration,
    defaultTarget: 60, // minutes
    icon: 'fitness_center',
    defaultTimeOfDay: TimeOfDay.morning,
    tags: ['workout', 'intense', 'fitness'],
  ),
  // ... continue for all STRENGTH habits
];

// ... Repeat for all 6 categories

// COMBINED LIST (for searching across all habits)
final List<HabitTemplate> allHabitTemplates = [
  ...coreHabits,
  ...strengthHabits,
  ...clarityHabits,
  ...resilienceHabits,
  ...masteryHabits,
  ...legacyHabits,
];
```

---

### **3. Program Archetype Definitions**

**File:** `lib/core/constants/program_archetypes.dart`

```dart
final ProgramArchetype phoenixArchetype = ProgramArchetype(
  id: 'phoenix',
  name: 'The Phoenix',
  tagline: 'Rise from the ashes',
  description: 'Build momentum from ground zero with fundamental, achievable habits. Focus on consistency over intensity.',
  color: Color(0xFFFF6B35), // Orange
  icon: Icons.local_fire_department,
  philosophy: 'Small wins compound into transformation',
  userCharacteristics: [
    'Starting from difficulty or hitting restart',
    'Feeling lost, burnt out, or overwhelmed',
    'Past accomplishments feel distant',
    'Morning feels like a battle',
  ],
  coreHabitIds: [
    'core_001',      // Hydrate
    'core_002',      // Daily Movement
    'core_003',      // Read Daily
    'mastery_002',   // Make Your Bed
    'clarity_004',   // No Phone Morning
    'resilience_002',// Gratitude Practice
    'mastery_003',   // Plan Top 3 Tasks
    'strength_006',  // No Junk Food
    'core_005',      // Consistent Sleep Rhythm
  ],
);

final ProgramArchetype architectArchetype = ProgramArchetype(
  id: 'architect',
  name: 'The Architect',
  tagline: 'Design and build your legacy',
  description: 'Structure and systems-focused approach. Productivity and planning habits prioritized.',
  color: Color(0xFF277DA1), // Blue
  icon: Icons.architecture,
  philosophy: 'Long-term thinking with sustainable daily execution',
  userCharacteristics: [
    'Has clear vision for future legacy',
    'Wants to build something that outlasts them',
    'Goal-oriented and systematic',
  ],
  coreHabitIds: [
    'core_001',      // Hydrate
    'core_003',      // Read Daily
    'mastery_001',   // Wake Up (No Snooze)
    'mastery_003',   // Plan Top 3 Tasks
    'clarity_001',   // Deep Work Session
    'strength_002',  // Cardio Endurance
    'resilience_005',// Visualization
    'legacy_001',    // Work on Passion Project
    'mastery_004',   // Time Blocking
    'legacy_002',    // Goal Review
  ],
);

// ... Continue for Operator, Stoic, Pioneer

final List<ProgramArchetype> allProgramArchetypes = [
  phoenixArchetype,
  architectArchetype,
  operatorArchetype,
  stoicArchetype,
  pioneerArchetype,
];
```

---

### **4. UI Updates Required**

#### **A. Onboarding: Program Recommendation Screen**

**Changes:**
- Display archetype name, icon, color (same as before)
- Show list of habit names grouped by category (NEW)
- Example display:

```
🔥 THE PHOENIX
"Rise from the ashes"

Your personalized program includes 9 habits:

CORE (Foundation)
✓ Hydrate (2L+ Water)
✓ Daily Movement (20+ Min)
✓ Read Daily (10+ Pages)
✓ Consistent Sleep Rhythm

MASTERY (Discipline & Systems)
✓ Make Your Bed
✓ Plan Top 3 Tasks

CLARITY (Mental Performance)
✓ No Phone Morning

RESILIENCE (Emotional Mastery)
✓ Gratitude Practice

STRENGTH (Physical Health)
✓ No Junk Food
```

#### **B. Add Habit Flow: Template Selection**

**OLD:** Categories were Foundation, Physical, Mental, Discipline, Lifestyle
**NEW:** Categories are CORE, STRENGTH, CLARITY, RESILIENCE, MASTERY, LEGACY

**Changes:**
- Update category tabs to show 6 new categories
- Each tab displays habits from that category
- Visual: Category icon + name + count (e.g., "CORE (6 habits)")
- Habits within category show icon, name, brief description, type indicator

**Example UI:**

```
[Add Habit Screen]

Categories:
[CORE] [STRENGTH] [CLARITY] [RESILIENCE] [MASTERY] [LEGACY]

--- CORE Selected ---

Foundation Habits - The non-negotiables

[Card: Hydrate (2L+ Water)]
Icon: 💧 | Type: Quantity (8 glasses)
"Track daily water intake - foundational for all body systems"
[+ Add]

[Card: Daily Movement (20+ Min)]
Icon: 🚶 | Type: Duration (20 min)
"Walk, stretch, light cardio - minimum viable physical activity"
[+ Add]

...
```

#### **C. Habit Cards: Category Badge**

**Changes:**
- Each habit card in Home tab shows small category badge
- Example: Habit "Hydrate" shows badge "CORE" in category color
- Helps users understand which area of life each habit addresses

---

### **5. Migration Strategy**

#### **For Existing Users (If App Already Launched)**

**Step 1: Map Old Categories to New**
```
OLD → NEW
Foundation → CORE
Physical → STRENGTH
Mental → CLARITY
Discipline → MASTERY
Lifestyle → (distribute to CORE, LEGACY, or RESILIENCE based on habit)
```

**Step 2: Update Existing Habit Templates**
- Assign new category to each existing habit template
- Preserve habit data for users who already have habits

**Step 3: Update User Habits**
- Backend migration: Update category field on all user habits
- No user action required

**Step 4: UI Update**
- Deploy new category structure
- Existing users see updated categories in Add Habit flow
- Their existing habits continue to work normally

#### **For New Users (Clean Implementation)**

**Step 1:** Implement new template structure with 6 categories and 49 habits

**Step 2:** Update all 5 archetype programs with new habit ID lists

**Step 3:** Update onboarding UI to display habits grouped by category

**Step 4:** Update Add Habit flow with 6 new category tabs

**Step 5:** Deploy and test end-to-end onboarding → habit selection → daily use

---

## Part 5: Visual Design Guidelines

### **Category Color Coding (Optional Enhancement)**

To make categories visually distinct:

| Category | Color | Icon |
|----------|-------|------|
| CORE | Gray/Neutral (#757575) | ⚡ Foundation |
| STRENGTH | Red (#F44336) | 💪 Physical |
| CLARITY | Blue (#2196F3) | 🧠 Mental |
| RESILIENCE | Green (#4CAF50) | 🌿 Emotional |
| MASTERY | Purple (#9C27B0) | 👑 Discipline |
| LEGACY | Amber (#FFC107) | 🎯 Purpose |

**Usage:**
- Category tabs use category color as accent
- Habit cards show small colored badge with category name
- Category headers in onboarding use category color

---

### **Archetype-Category Visual Relationship**

When showing a program (e.g., Phoenix):
- Use archetype color (Orange) as primary theme
- Show category badges for each habit in category colors
- Example: Phoenix program card has orange background, but each habit shows its category badge (CORE gray, STRENGTH red, etc.)

---

## Part 6: Testing & Validation

### **Test Cases**

1. **Onboarding Flow**
   - Take questionnaire → Get matched to each archetype
   - Verify correct habits appear for each archetype
   - Verify habits grouped by category
   - Verify habit counts match (Phoenix: 9, Architect: 10, etc.)

2. **Add Habit Flow**
   - Browse each category tab
   - Verify all 49 habits appear in correct categories
   - Search for habit by name
   - Add habit from template

3. **Habit Configuration**
   - Create habit from each type (duration, quantity, time, checkbox)
   - Verify default values load correctly
   - Configure and save

4. **Daily Use**
   - Complete habits from different categories
   - Verify category badges display correctly
   - Check analytics group by category (optional feature)

5. **Browse Other Programs**
   - From recommendation screen, browse all 5 archetypes
   - Verify each shows correct habit list
   - Switch between archetypes
   - Select different archetype than recommended

---

## Part 7: Future Enhancements

### **1. Category-Based Analytics**
- Track completion rates by category (e.g., "You're strongest in MASTERY, struggling in STRENGTH")
- Suggest habits from underutilized categories
- Visual breakdown of habit distribution across categories

### **2. Archetype Evolution**
- After 90 days, suggest users "level up" to more advanced archetype
- Example: Phoenix → Architect after building consistency
- Offer to add more intense habits from STRENGTH or CLARITY

### **3. Custom Program Creation**
- Allow users to create fully custom program by selecting habits from categories
- Suggest minimum 1-2 habits from each category for balance
- Name custom program and save

### **4. Habit Recommendations Engine**
- "Based on your current habits, consider adding [Habit] from [Category]"
- Balance recommendations across categories
- Suggest complementary habits (e.g., if doing Intense Training, suggest Active Recovery)

### **5. Category Challenges**
- Weekly challenges: "STRENGTH Week - complete all physical habits 7 days straight"
- Rotate through categories monthly
- Leaderboards per category (if adding social features)

---

## Part 8: Quick Reference

### **Archetype Summary Table**

| Archetype | Color | Habit Count | Top Categories | Philosophy |
|-----------|-------|-------------|----------------|------------|
| **Phoenix** | Orange | 9 | CORE, MASTERY, RESILIENCE | Rebuild momentum, small wins |
| **Architect** | Blue | 10 | MASTERY, CLARITY, LEGACY | Strategic planning, long-term building |
| **Operator** | Red | 12 | STRENGTH, CLARITY, MASTERY | Peak performance, intensity |
| **Stoic** | Green | 10 | RESILIENCE, CORE, CLARITY | Inner work, mindful awareness |
| **Pioneer** | Amber | 10 | CORE, MASTERY, CLARITY | Early foundation, lifelong patterns |

### **Category Summary Table**

| Category | Habit Count | Focus Area | Key Habits |
|----------|-------------|------------|------------|
| **CORE** | 6 | Foundation | Hydrate, Movement, Read, Sleep |
| **STRENGTH** | 9 | Physical Health | Training, Cardio, Nutrition, Recovery |
| **CLARITY** | 8 | Mental Performance | Deep Work, Learning, Digital Minimalism |
| **RESILIENCE** | 8 | Emotional Mastery | Meditation, Journaling, Gratitude |
| **MASTERY** | 10 | Discipline & Systems | Wake Early, Plan, Track, Routines |
| **LEGACY** | 8 | Growth & Purpose | Projects, Goals, Skills, Contribution |

**Total Habits:** 49 habits across 6 categories
**Total Archetypes:** 5 personality-driven programs

---

## Implementation Checklist

- [ ] Create new `HabitCategory` enum with 6 categories
- [ ] Update `HabitTemplate` model to include category field
- [ ] Define all 49 habit templates in constants file
- [ ] Create habit template lists by category (coreHabits, strengthHabits, etc.)
- [ ] Update `ProgramArchetype` model to use habit ID lists
- [ ] Define all 5 archetype programs with new habit mappings
- [ ] Update onboarding UI to display habits grouped by category
- [ ] Update Add Habit screen with 6 category tabs
- [ ] Add category badges to habit cards in Home tab
- [ ] Update habit configuration flow to preserve category metadata
- [ ] Test end-to-end onboarding for all 5 archetypes
- [ ] Test browsing and adding habits from all 6 categories
- [ ] Test habit completion and tracking
- [ ] Update analytics to optionally show category breakdowns
- [ ] Write migration script for existing users (if needed)
- [ ] Update user documentation/help screens with new categories
- [ ] Deploy and monitor for issues

---

**Document Version:** 1.0
**Created:** 2025-11-19
**Purpose:** Complete implementation guide for habit system redesign
**Status:** Ready for development

---

*End of Implementation Guide*
