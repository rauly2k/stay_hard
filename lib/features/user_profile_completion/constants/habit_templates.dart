import 'package:flutter/material.dart';
import '../data/models/habit_template.dart';

/// Comprehensive library of habit templates for StayHard app
class HabitTemplates {
  // Core Universal Habits (recommended to all users)
  static const drinkWater = HabitTemplate(
    id: 'drink_water',
    name: 'Drink Water',
    detail: 'Stay hydrated throughout the day (minimum 2L)',
    icon: Icons.local_drink,
    category: HabitCategory.foundation,
    configType: HabitConfigType.quantity,
    defaultUnit: 'glasses',
    defaultValue: 8,
  );

  static const readPages = HabitTemplate(
    id: 'read_pages',
    name: 'Read 10 Pages',
    detail: 'Read at least 10 pages of a book daily',
    icon: Icons.menu_book,
    category: HabitCategory.mental,
    configType: HabitConfigType.quantity,
    defaultUnit: 'pages',
    defaultValue: 10,
  );

  static const planTasks = HabitTemplate(
    id: 'plan_tasks',
    name: 'Plan Top 3 Tasks',
    detail: 'Plan your top 3 tasks for tomorrow',
    icon: Icons.assignment,
    category: HabitCategory.discipline,
    configType: HabitConfigType.none,
  );

  static const exercise = HabitTemplate(
    id: 'exercise',
    name: 'Exercise',
    detail: 'Any physical activity: gym, walk, run, etc.',
    icon: Icons.fitness_center,
    category: HabitCategory.physical,
    configType: HabitConfigType.duration,
    defaultValue: 30,
  );

  static const meditate = HabitTemplate(
    id: 'meditate',
    name: 'Meditate',
    detail: 'Practice mindfulness or meditation',
    icon: Icons.self_improvement,
    category: HabitCategory.mental,
    configType: HabitConfigType.duration,
    defaultValue: 10,
  );

  static const noPhoneMorning = HabitTemplate(
    id: 'no_phone_morning',
    name: 'No Phone (First 30 Min)',
    detail: 'No phone for the first 30 minutes after waking up',
    icon: Icons.phone_disabled,
    category: HabitCategory.discipline,
    configType: HabitConfigType.none,
  );

  static const gratitude = HabitTemplate(
    id: 'gratitude',
    name: 'Gratitude Practice',
    detail: 'Write down 3 things you\'re grateful for',
    icon: Icons.favorite,
    category: HabitCategory.mental,
    configType: HabitConfigType.none,
  );

  // Extra/Profile-Specific Habits
  static const deepWork = HabitTemplate(
    id: 'deep_work',
    name: 'Deep Work Session',
    detail: 'Complete one 90-minute uninterrupted work block',
    icon: Icons.work,
    category: HabitCategory.discipline,
    configType: HabitConfigType.duration,
    defaultValue: 90,
  );

  static const noSocialMedia = HabitTemplate(
    id: 'no_social_media',
    name: 'No Social Media (Focus)',
    detail: 'No social media until Top 3 tasks are complete',
    icon: Icons.block,
    category: HabitCategory.discipline,
    configType: HabitConfigType.none,
  );

  static const learnSkill = HabitTemplate(
    id: 'learn_skill',
    name: 'Learn a Skill',
    detail: 'Dedicate time to focused practice or study',
    icon: Icons.school,
    category: HabitCategory.mental,
    configType: HabitConfigType.duration,
    defaultValue: 30,
  );

  static const wakeUpNoSnooze = HabitTemplate(
    id: 'wake_up_no_snooze',
    name: 'Wake Up (No Snooze)',
    detail: 'Get out of bed immediately when alarm rings',
    icon: Icons.alarm,
    category: HabitCategory.discipline,
    configType: HabitConfigType.time,
  );

  static const intenseExercise = HabitTemplate(
    id: 'intense_exercise',
    name: 'Intense Exercise',
    detail: '30+ minutes of high-intensity physical activity',
    icon: Icons.fitness_center,
    category: HabitCategory.physical,
    configType: HabitConfigType.duration,
    defaultValue: 30,
  );

  static const noProcessedSugar = HabitTemplate(
    id: 'no_processed_sugar',
    name: 'No Processed Sugar',
    detail: 'Avoid processed sugars and sugary drinks',
    icon: Icons.block,
    category: HabitCategory.physical,
    configType: HabitConfigType.none,
  );

  static const journal = HabitTemplate(
    id: 'journal',
    name: 'Journal',
    detail: 'Journaling to process thoughts and emotions',
    icon: Icons.edit_note,
    category: HabitCategory.mental,
    configType: HabitConfigType.duration,
    defaultValue: 10,
  );

  static const makeBed = HabitTemplate(
    id: 'make_bed',
    name: 'Make Your Bed',
    detail: 'Make your bed immediately after waking up',
    icon: Icons.bed,
    category: HabitCategory.foundation,
    configType: HabitConfigType.none,
  );

  static const noJunkFood = HabitTemplate(
    id: 'no_junk_food',
    name: 'No Junk Food',
    detail: 'Choose long-term health over short-term pleasure',
    icon: Icons.no_meals,
    category: HabitCategory.physical,
    configType: HabitConfigType.none,
  );

  static const noAlcohol = HabitTemplate(
    id: 'no_alcohol',
    name: 'No Alcohol',
    detail: 'The hard choice for mental clarity and physical health',
    icon: Icons.local_bar_outlined,
    category: HabitCategory.physical,
    configType: HabitConfigType.none,
  );

  static const noAddictions = HabitTemplate(
    id: 'no_addictions',
    name: 'No Addictions',
    detail: 'Stay free from harmful addictions',
    icon: Icons.block,
    category: HabitCategory.lifestyle,
    configType: HabitConfigType.none,
  );

  static const embraceSuck = HabitTemplate(
    id: 'embrace_suck',
    name: 'Embrace the Suck',
    detail: 'Voluntarily do one physically uncomfortable thing',
    icon: Icons.ac_unit,
    category: HabitCategory.physical,
    configType: HabitConfigType.none,
  );

  static const selfCare = HabitTemplate(
    id: 'self_care',
    name: 'Practice Self-Care',
    detail: 'The disciplined act of maintaining yourself',
    icon: Icons.spa,
    category: HabitCategory.lifestyle,
    configType: HabitConfigType.duration,
    defaultValue: 15,
  );

  static const visualization = HabitTemplate(
    id: 'visualization',
    name: 'Visualization',
    detail: '5 minutes of visualizing success or a perfect day',
    icon: Icons.visibility,
    category: HabitCategory.mental,
    configType: HabitConfigType.duration,
    defaultValue: 5,
  );

  static const rememberWhy = HabitTemplate(
    id: 'remember_why',
    name: 'Remember Your "Why"',
    detail: 'A 1-minute review of your core motivation',
    icon: Icons.favorite_border,
    category: HabitCategory.mental,
    configType: HabitConfigType.none,
  );

  static const giveBack = HabitTemplate(
    id: 'give_back',
    name: 'Give Back / Be Kind',
    detail: 'Practice humility and connection with others',
    icon: Icons.volunteer_activism,
    category: HabitCategory.lifestyle,
    configType: HabitConfigType.none,
  );

  /// All available habit templates
  static const List<HabitTemplate> all = [
    // Core universal habits
    drinkWater,
    readPages,
    planTasks,
    exercise,
    meditate,
    noPhoneMorning,
    gratitude,

    // Extra habits
    deepWork,
    noSocialMedia,
    learnSkill,
    wakeUpNoSnooze,
    intenseExercise,
    noProcessedSugar,
    journal,
    makeBed,
    noJunkFood,
    noAlcohol,
    noAddictions,
    embraceSuck,
    selfCare,
    visualization,
    rememberWhy,
    giveBack,
  ];

  /// Core universal habits IDs (recommended to all users)
  static const List<String> coreUniversalIds = [
    'drink_water',
    'read_pages',
    'plan_tasks',
    'exercise',
    'meditate',
    'no_phone_morning',
    'gratitude',
  ];

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

  /// Get extra (non-core) habits
  static List<HabitTemplate> get extraHabits {
    return all.where((h) => !coreUniversalIds.contains(h.id)).toList();
  }
}
