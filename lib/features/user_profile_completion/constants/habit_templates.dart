import 'package:flutter/material.dart';
import '../data/models/habit_template.dart';

/// Comprehensive library of 49 habit templates organized into 6 categories
class HabitTemplates {
  // ============================================================================
  // CATEGORY 1: CORE (Foundation Habits) - 6 habits
  // ============================================================================

  static const core001 = HabitTemplate(
    id: 'core_001',
    name: 'Hydrate (2L+ Water)',
    detail: 'Track daily water intake - foundational for all body systems',
    icon: Icons.water_drop,
    color: Color(0xFF2196F3), // Blue
    category: HabitCategory.core,
    configType: HabitConfigType.quantity,
    defaultUnit: 'glasses',
    defaultValue: 8,
    tags: ['hydration', 'health', 'foundation'],
  );

  static const core002 = HabitTemplate(
    id: 'core_002',
    name: 'Daily Movement (20+ Min)',
    detail: 'Walk, stretch, light cardio - minimum viable physical activity',
    icon: Icons.directions_walk,
    color: Color(0xFF757575), // Gray
    category: HabitCategory.core,
    configType: HabitConfigType.duration,
    defaultValue: 20,
    tags: ['movement', 'exercise', 'foundation'],
  );

  static const core003 = HabitTemplate(
    id: 'core_003',
    name: 'Read Daily (10+ Pages)',
    detail: 'Books, articles, learning - continuous mental stimulation',
    icon: Icons.menu_book,
    color: Color(0xFF9C27B0), // Purple
    category: HabitCategory.core,
    configType: HabitConfigType.quantity,
    defaultUnit: 'pages',
    defaultValue: 10,
    tags: ['reading', 'learning', 'foundation'],
  );

  static const core004 = HabitTemplate(
    id: 'core_004',
    name: 'Whole Foods Nutrition',
    detail: 'Eat clean, limit processed foods, fuel your body right',
    icon: Icons.restaurant,
    color: Color(0xFF4CAF50), // Green
    category: HabitCategory.core,
    configType: HabitConfigType.none,
    tags: ['nutrition', 'health', 'foundation'],
  );

  static const core005 = HabitTemplate(
    id: 'core_005',
    name: 'Consistent Sleep Rhythm',
    detail: 'Wake at same time daily to maintain sleep schedule',
    icon: Icons.bedtime,
    color: Color(0xFF5C6BC0), // Indigo
    category: HabitCategory.core,
    configType: HabitConfigType.time,
    tags: ['sleep', 'rhythm', 'foundation'],
  );

  static const core006 = HabitTemplate(
    id: 'core_006',
    name: 'Screen-Free Before Bed',
    detail: 'No screens 30-60 min before sleep for better rest quality',
    icon: Icons.phone_disabled,
    color: Color(0xFF795548), // Brown
    category: HabitCategory.core,
    configType: HabitConfigType.none,
    tags: ['sleep', 'screen', 'foundation'],
  );

  // ============================================================================
  // CATEGORY 2: STRENGTH (Physical Health) - 9 habits
  // ============================================================================

  static const strength001 = HabitTemplate(
    id: 'strength_001',
    name: 'Intense Training',
    detail: 'Structured workouts, gym sessions, push limits',
    icon: Icons.fitness_center,
    color: Color(0xFFF44336), // Red
    category: HabitCategory.strength,
    configType: HabitConfigType.duration,
    defaultValue: 60,
    tags: ['workout', 'intense', 'fitness'],
  );

  static const strength002 = HabitTemplate(
    id: 'strength_002',
    name: 'Cardio Endurance',
    detail: 'Running, cycling, swimming, HIIT - build stamina',
    icon: Icons.directions_run,
    color: Color(0xFFE53935), // Red
    category: HabitCategory.strength,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['cardio', 'endurance', 'fitness'],
  );

  static const strength003 = HabitTemplate(
    id: 'strength_003',
    name: 'Strength Training',
    detail: 'Lift weights, resistance training, build power',
    icon: Icons.fitness_center,
    color: Color(0xFFD32F2F), // Red
    category: HabitCategory.strength,
    configType: HabitConfigType.duration,
    defaultValue: 45,
    tags: ['strength', 'weights', 'fitness'],
  );

  static const strength004 = HabitTemplate(
    id: 'strength_004',
    name: 'Mobility & Flexibility',
    detail: 'Yoga, stretching, foam rolling, movement quality',
    icon: Icons.self_improvement,
    color: Color(0xFF8BC34A), // Light Green
    category: HabitCategory.strength,
    configType: HabitConfigType.duration,
    defaultValue: 20,
    tags: ['mobility', 'flexibility', 'yoga'],
  );

  static const strength005 = HabitTemplate(
    id: 'strength_005',
    name: 'No Alcohol',
    detail: 'Eliminate alcohol consumption',
    icon: Icons.local_bar_outlined,
    color: Color(0xFFCDDC39), // Lime
    category: HabitCategory.strength,
    configType: HabitConfigType.none,
    tags: ['alcohol', 'health', 'discipline'],
  );

  static const strength006 = HabitTemplate(
    id: 'strength_006',
    name: 'No Junk Food',
    detail: 'Avoid processed/fast food',
    icon: Icons.no_meals,
    color: Color(0xFF4CAF50), // Green
    category: HabitCategory.strength,
    configType: HabitConfigType.none,
    tags: ['nutrition', 'health', 'discipline'],
  );

  static const strength007 = HabitTemplate(
    id: 'strength_007',
    name: 'No Processed Sugar',
    detail: 'Limit or eliminate added sugars',
    icon: Icons.block,
    color: Color(0xFFFF9800), // Orange
    category: HabitCategory.strength,
    configType: HabitConfigType.none,
    tags: ['sugar', 'health', 'discipline'],
  );

  static const strength008 = HabitTemplate(
    id: 'strength_008',
    name: 'Active Recovery',
    detail: 'Walk, light movement, rest day activity',
    icon: Icons.directions_walk,
    color: Color(0xFF66BB6A), // Green
    category: HabitCategory.strength,
    configType: HabitConfigType.none,
    tags: ['recovery', 'movement', 'health'],
  );

  static const strength009 = HabitTemplate(
    id: 'strength_009',
    name: 'Cold Exposure',
    detail: 'Cold showers, ice baths, build physical resilience',
    icon: Icons.ac_unit,
    color: Color(0xFF03A9F4), // Light Blue
    category: HabitCategory.strength,
    configType: HabitConfigType.duration,
    defaultValue: 5,
    tags: ['cold', 'resilience', 'discomfort'],
  );

  // ============================================================================
  // CATEGORY 3: CLARITY (Mental Performance) - 8 habits
  // ============================================================================

  static const clarity001 = HabitTemplate(
    id: 'clarity_001',
    name: 'Deep Work Session',
    detail: 'Dedicated focus time on important work',
    icon: Icons.work,
    color: Color(0xFF3F51B5), // Indigo
    category: HabitCategory.clarity,
    configType: HabitConfigType.duration,
    defaultValue: 90,
    tags: ['focus', 'productivity', 'work'],
  );

  static const clarity002 = HabitTemplate(
    id: 'clarity_002',
    name: 'Learn a New Skill',
    detail: 'Practice skill, take course, deliberate learning',
    icon: Icons.school,
    color: Color(0xFF00BCD4), // Cyan
    category: HabitCategory.clarity,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['learning', 'skill', 'growth'],
  );

  static const clarity003 = HabitTemplate(
    id: 'clarity_003',
    name: 'No Social Media',
    detail: 'Eliminate or drastically reduce social media use',
    icon: Icons.block,
    color: Color(0xFF9E9E9E), // Grey
    category: HabitCategory.clarity,
    configType: HabitConfigType.none,
    tags: ['social-media', 'focus', 'discipline'],
  );

  static const clarity004 = HabitTemplate(
    id: 'clarity_004',
    name: 'No Phone Morning',
    detail: 'First 30-60 minutes phone-free after waking',
    icon: Icons.phone_disabled,
    color: Color(0xFF795548), // Brown
    category: HabitCategory.clarity,
    configType: HabitConfigType.none,
    tags: ['phone', 'morning', 'focus'],
  );

  static const clarity005 = HabitTemplate(
    id: 'clarity_005',
    name: 'Digital Detox Hour',
    detail: '1+ hour daily completely screen-free',
    icon: Icons.devices_off,
    color: Color(0xFF607D8B), // Blue Grey
    category: HabitCategory.clarity,
    configType: HabitConfigType.duration,
    defaultValue: 60,
    tags: ['digital', 'detox', 'screen-free'],
  );

  static const clarity006 = HabitTemplate(
    id: 'clarity_006',
    name: 'Single-Task Focus',
    detail: 'Work on one thing at a time, no multitasking',
    icon: Icons.filter_1,
    color: Color(0xFF2196F3), // Blue
    category: HabitCategory.clarity,
    configType: HabitConfigType.none,
    tags: ['focus', 'productivity', 'single-task'],
  );

  static const clarity007 = HabitTemplate(
    id: 'clarity_007',
    name: 'Brain Training',
    detail: 'Puzzles, chess, language learning, cognitive challenges',
    icon: Icons.psychology,
    color: Color(0xFF9C27B0), // Purple
    category: HabitCategory.clarity,
    configType: HabitConfigType.duration,
    defaultValue: 15,
    tags: ['brain', 'cognitive', 'learning'],
  );

  static const clarity008 = HabitTemplate(
    id: 'clarity_008',
    name: 'Creative Output',
    detail: 'Write, create, build, make something',
    icon: Icons.create,
    color: Color(0xFFFF5722), // Deep Orange
    category: HabitCategory.clarity,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['creative', 'output', 'creation'],
  );

  // ============================================================================
  // CATEGORY 4: RESILIENCE (Emotional Mastery) - 8 habits
  // ============================================================================

  static const resilience001 = HabitTemplate(
    id: 'resilience_001',
    name: 'Meditate',
    detail: 'Mindfulness, breathwork, stillness practice',
    icon: Icons.self_improvement,
    color: Color(0xFF673AB7), // Deep Purple
    category: HabitCategory.resilience,
    configType: HabitConfigType.duration,
    defaultValue: 20,
    tags: ['meditation', 'mindfulness', 'stillness'],
  );

  static const resilience002 = HabitTemplate(
    id: 'resilience_002',
    name: 'Gratitude Practice',
    detail: 'Write 3+ things you\'re grateful for',
    icon: Icons.favorite,
    color: Color(0xFFE91E63), // Pink
    category: HabitCategory.resilience,
    configType: HabitConfigType.quantity,
    defaultUnit: 'items',
    defaultValue: 3,
    tags: ['gratitude', 'mindset', 'appreciation'],
  );

  static const resilience003 = HabitTemplate(
    id: 'resilience_003',
    name: 'Journal',
    detail: 'Reflect, process emotions, self-awareness',
    icon: Icons.edit_note,
    color: Color(0xFF8BC34A), // Light Green
    category: HabitCategory.resilience,
    configType: HabitConfigType.duration,
    defaultValue: 15,
    tags: ['journal', 'reflection', 'emotion'],
  );

  static const resilience004 = HabitTemplate(
    id: 'resilience_004',
    name: 'Remember Your Why',
    detail: 'Review your purpose, vision, core motivations',
    icon: Icons.favorite_border,
    color: Color(0xFFEC407A), // Pink 400
    category: HabitCategory.resilience,
    configType: HabitConfigType.none,
    tags: ['purpose', 'why', 'motivation'],
  );

  static const resilience005 = HabitTemplate(
    id: 'resilience_005',
    name: 'Visualization',
    detail: 'Mental rehearsal of goals, success visualization',
    icon: Icons.visibility,
    color: Color(0xFF7E57C2), // Deep Purple 400
    category: HabitCategory.resilience,
    configType: HabitConfigType.duration,
    defaultValue: 10,
    tags: ['visualization', 'goals', 'mental'],
  );

  static const resilience006 = HabitTemplate(
    id: 'resilience_006',
    name: 'Embrace the Suck',
    detail: 'Do the hardest/most uncomfortable task first',
    icon: Icons.whatshot,
    color: Color(0xFFFF6B35), // Orange
    category: HabitCategory.resilience,
    configType: HabitConfigType.none,
    tags: ['discomfort', 'challenge', 'hard'],
  );

  static const resilience007 = HabitTemplate(
    id: 'resilience_007',
    name: 'Emotional Check-In',
    detail: 'Track mood, energy, stress levels',
    icon: Icons.mood,
    color: Color(0xFF42A5F5), // Blue 400
    category: HabitCategory.resilience,
    configType: HabitConfigType.none,
    tags: ['emotion', 'mood', 'awareness'],
  );

  static const resilience008 = HabitTemplate(
    id: 'resilience_008',
    name: 'Breathwork Practice',
    detail: 'Wim Hof, box breathing, stress management breathing',
    icon: Icons.air,
    color: Color(0xFF26C6DA), // Cyan 400
    category: HabitCategory.resilience,
    configType: HabitConfigType.duration,
    defaultValue: 10,
    tags: ['breathwork', 'breathing', 'stress'],
  );

  // ============================================================================
  // CATEGORY 5: MASTERY (Discipline & Systems) - 10 habits
  // ============================================================================

  static const mastery001 = HabitTemplate(
    id: 'mastery_001',
    name: 'Wake Up (No Snooze)',
    detail: 'Get up immediately when alarm sounds',
    icon: Icons.alarm,
    color: Color(0xFFFFC107), // Amber
    category: HabitCategory.mastery,
    configType: HabitConfigType.time,
    tags: ['wake', 'discipline', 'morning'],
  );

  static const mastery002 = HabitTemplate(
    id: 'mastery_002',
    name: 'Make Your Bed',
    detail: 'Start day with immediate win',
    icon: Icons.bed,
    color: Color(0xFF009688), // Teal
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['bed', 'morning', 'win'],
  );

  static const mastery003 = HabitTemplate(
    id: 'mastery_003',
    name: 'Plan Top 3 Tasks',
    detail: 'Identify and prioritize day\'s most important work',
    icon: Icons.assignment,
    color: Color(0xFF607D8B), // Blue Grey
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['planning', 'tasks', 'priority'],
  );

  static const mastery004 = HabitTemplate(
    id: 'mastery_004',
    name: 'Time Blocking',
    detail: 'Schedule day in advance, allocate time to priorities',
    icon: Icons.calendar_today,
    color: Color(0xFF5C6BC0), // Indigo
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['time', 'schedule', 'planning'],
  );

  static const mastery005 = HabitTemplate(
    id: 'mastery_005',
    name: 'Weekly Review',
    detail: 'Reflect on week, plan ahead, adjust systems',
    icon: Icons.event_note,
    color: Color(0xFF7E57C2), // Purple
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['review', 'weekly', 'reflection'],
  );

  static const mastery006 = HabitTemplate(
    id: 'mastery_006',
    name: 'Daily Check-In',
    detail: 'Morning or evening reflection on progress',
    icon: Icons.checklist,
    color: Color(0xFF26A69A), // Teal
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['check-in', 'reflection', 'progress'],
  );

  static const mastery007 = HabitTemplate(
    id: 'mastery_007',
    name: 'Track Progress',
    detail: 'Log metrics, journal wins, measure what matters',
    icon: Icons.track_changes,
    color: Color(0xFF42A5F5), // Blue
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['tracking', 'metrics', 'progress'],
  );

  static const mastery008 = HabitTemplate(
    id: 'mastery_008',
    name: 'Prep Tomorrow Tonight',
    detail: 'Evening routine to set up next day',
    icon: Icons.nightlight,
    color: Color(0xFF5E35B1), // Deep Purple
    category: HabitCategory.mastery,
    configType: HabitConfigType.none,
    tags: ['evening', 'preparation', 'routine'],
  );

  static const mastery009 = HabitTemplate(
    id: 'mastery_009',
    name: 'Morning Routine',
    detail: 'Structured morning sequence',
    icon: Icons.wb_sunny,
    color: Color(0xFFFFA726), // Orange
    category: HabitCategory.mastery,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['morning', 'routine', 'structure'],
  );

  static const mastery010 = HabitTemplate(
    id: 'mastery_010',
    name: 'Evening Routine',
    detail: 'Wind-down ritual before bed',
    icon: Icons.nights_stay,
    color: Color(0xFF7E57C2), // Purple
    category: HabitCategory.mastery,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['evening', 'routine', 'wind-down'],
  );

  // ============================================================================
  // CATEGORY 6: LEGACY (Growth & Purpose) - 8 habits
  // ============================================================================

  static const legacy001 = HabitTemplate(
    id: 'legacy_001',
    name: 'Work on Passion Project',
    detail: 'Side hustle, creative project, future-building work',
    icon: Icons.lightbulb,
    color: Color(0xFFFFC107), // Amber
    category: HabitCategory.legacy,
    configType: HabitConfigType.duration,
    defaultValue: 60,
    tags: ['project', 'passion', 'building'],
  );

  static const legacy002 = HabitTemplate(
    id: 'legacy_002',
    name: 'Goal Review',
    detail: 'Review quarterly/annual goals, align daily actions',
    icon: Icons.flag,
    color: Color(0xFFE53935), // Red
    category: HabitCategory.legacy,
    configType: HabitConfigType.none,
    tags: ['goals', 'review', 'planning'],
  );

  static const legacy003 = HabitTemplate(
    id: 'legacy_003',
    name: 'Vision Work',
    detail: 'Long-term planning, 5/10-year thinking, life design',
    icon: Icons.explore,
    color: Color(0xFF5E35B1), // Deep Purple
    category: HabitCategory.legacy,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['vision', 'planning', 'long-term'],
  );

  static const legacy004 = HabitTemplate(
    id: 'legacy_004',
    name: 'Skill Mastery',
    detail: 'Dedicate time to mastering specific skill for long-term impact',
    icon: Icons.military_tech,
    color: Color(0xFFFF6F00), // Orange
    category: HabitCategory.legacy,
    configType: HabitConfigType.duration,
    defaultValue: 60,
    tags: ['mastery', 'skill', 'expertise'],
  );

  static const legacy005 = HabitTemplate(
    id: 'legacy_005',
    name: 'Give Back / Contribute',
    detail: 'Mentor, volunteer, help others, create value',
    icon: Icons.volunteer_activism,
    color: Color(0xFFFF7043), // Deep Orange 400
    category: HabitCategory.legacy,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['giving', 'contribution', 'help'],
  );

  static const legacy006 = HabitTemplate(
    id: 'legacy_006',
    name: 'Build in Public',
    detail: 'Share progress, document journey, create content',
    icon: Icons.public,
    color: Color(0xFF29B6F6), // Light Blue
    category: HabitCategory.legacy,
    configType: HabitConfigType.none,
    tags: ['public', 'sharing', 'content'],
  );

  static const legacy007 = HabitTemplate(
    id: 'legacy_007',
    name: 'Learn from Mentors',
    detail: 'Study leaders, consume high-value content, seek wisdom',
    icon: Icons.school,
    color: Color(0xFF8E24AA), // Purple
    category: HabitCategory.legacy,
    configType: HabitConfigType.duration,
    defaultValue: 30,
    tags: ['mentors', 'learning', 'wisdom'],
  );

  static const legacy008 = HabitTemplate(
    id: 'legacy_008',
    name: 'Financial Growth',
    detail: 'Work on finances, invest, build wealth',
    icon: Icons.attach_money,
    color: Color(0xFF43A047), // Green
    category: HabitCategory.legacy,
    configType: HabitConfigType.none,
    tags: ['finance', 'wealth', 'money'],
  );

  // ============================================================================
  // ORGANIZED LISTS BY CATEGORY
  // ============================================================================

  /// CORE habits (6 habits)
  static const List<HabitTemplate> coreHabits = [
    core001,
    core002,
    core003,
    core004,
    core005,
    core006,
  ];

  /// STRENGTH habits (9 habits)
  static const List<HabitTemplate> strengthHabits = [
    strength001,
    strength002,
    strength003,
    strength004,
    strength005,
    strength006,
    strength007,
    strength008,
    strength009,
  ];

  /// CLARITY habits (8 habits)
  static const List<HabitTemplate> clarityHabits = [
    clarity001,
    clarity002,
    clarity003,
    clarity004,
    clarity005,
    clarity006,
    clarity007,
    clarity008,
  ];

  /// RESILIENCE habits (8 habits)
  static const List<HabitTemplate> resilienceHabits = [
    resilience001,
    resilience002,
    resilience003,
    resilience004,
    resilience005,
    resilience006,
    resilience007,
    resilience008,
  ];

  /// MASTERY habits (10 habits)
  static const List<HabitTemplate> masteryHabits = [
    mastery001,
    mastery002,
    mastery003,
    mastery004,
    mastery005,
    mastery006,
    mastery007,
    mastery008,
    mastery009,
    mastery010,
  ];

  /// LEGACY habits (8 habits)
  static const List<HabitTemplate> legacyHabits = [
    legacy001,
    legacy002,
    legacy003,
    legacy004,
    legacy005,
    legacy006,
    legacy007,
    legacy008,
  ];

  /// All 49 habit templates
  static const List<HabitTemplate> all = [
    ...coreHabits,
    ...strengthHabits,
    ...clarityHabits,
    ...resilienceHabits,
    ...masteryHabits,
    ...legacyHabits,
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get habit template by ID
  static HabitTemplate? findById(String id) {
    try {
      return all.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get habits by category
  static List<HabitTemplate> byCategory(HabitCategory category) {
    return all.where((h) => h.category == category).toList();
  }

  /// Get category display name
  static String getCategoryDisplayName(HabitCategory category) {
    switch (category) {
      case HabitCategory.core:
        return 'CORE';
      case HabitCategory.strength:
        return 'STRENGTH';
      case HabitCategory.clarity:
        return 'CLARITY';
      case HabitCategory.resilience:
        return 'RESILIENCE';
      case HabitCategory.mastery:
        return 'MASTERY';
      case HabitCategory.legacy:
        return 'LEGACY';
    }
  }

  /// Get category description
  static String getCategoryDescription(HabitCategory category) {
    switch (category) {
      case HabitCategory.core:
        return 'Foundation Habits';
      case HabitCategory.strength:
        return 'Physical Health';
      case HabitCategory.clarity:
        return 'Mental Performance';
      case HabitCategory.resilience:
        return 'Emotional Mastery';
      case HabitCategory.mastery:
        return 'Discipline & Systems';
      case HabitCategory.legacy:
        return 'Growth & Purpose';
    }
  }

  /// Get category color (for UI)
  static Color getCategoryColor(HabitCategory category) {
    switch (category) {
      case HabitCategory.core:
        return const Color(0xFF757575); // Gray
      case HabitCategory.strength:
        return const Color(0xFFF44336); // Red
      case HabitCategory.clarity:
        return const Color(0xFF2196F3); // Blue
      case HabitCategory.resilience:
        return const Color(0xFF4CAF50); // Green
      case HabitCategory.mastery:
        return const Color(0xFF9C27B0); // Purple
      case HabitCategory.legacy:
        return const Color(0xFFFFC107); // Amber
    }
  }

  /// Get category icon (for UI)
  static IconData getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.core:
        return Icons.bolt; // Foundation
      case HabitCategory.strength:
        return Icons.fitness_center; // Physical
      case HabitCategory.clarity:
        return Icons.psychology; // Mental
      case HabitCategory.resilience:
        return Icons.spa; // Emotional
      case HabitCategory.mastery:
        return Icons.emoji_events; // Discipline
      case HabitCategory.legacy:
        return Icons.flag; // Purpose
    }
  }
}
