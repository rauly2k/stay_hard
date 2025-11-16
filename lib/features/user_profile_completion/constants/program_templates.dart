import 'package:flutter/material.dart';
import '../data/models/program_template.dart';
import 'habit_templates.dart';

/// The 5 program archetypes for personalized onboarding
class ProgramTemplates {
  /// Profile 1: "The Phoenix" (The Beginner / Rebuilder)
  static const phoenix = ProgramTemplate(
    id: 'phoenix',
    name: 'The Phoenix',
    tagline: 'Rising from the ashes, building from scratch',
    description:
        'You\'re starting from a place of difficulty. You feel lost, burnt out, or like you\'re starting over. This program helps you build momentum from the ground up, focusing on fundamental habits that create a solid foundation for growth.',
    icon: Icons.local_fire_department,
    color: Color(0xFFFF6B35), // StayHard Orange
    coreHabitIds: [
      'make_bed',
      'drink_water',
      'no_phone_morning',
      'exercise',
      'gratitude',
      'read_pages',
      'plan_tasks',
    ],
  );

  /// Profile 2: "The Architect" (The Visionary Builder)
  static const architect = ProgramTemplate(
    id: 'architect',
    name: 'The Architect',
    tagline: 'Building a legacy, one disciplined day at a time',
    description:
        'You\'re not starting from zero; you\'re starting with a vision. You\'re driven by building a legacy and conquering goals. This program provides the structure, focus, and productivity habits you need to translate your big-picture vision into daily disciplined reality.',
    icon: Icons.architecture,
    color: Color(0xFF277DA1), // Blue
    coreHabitIds: [
      'wake_up_no_snooze',
      'plan_tasks',
      'deep_work',
      'exercise',
      'read_pages',
      'visualization',
      'drink_water',
    ],
  );

  /// Profile 3: "The Operator" (The High-Performer)
  static const operator = ProgramTemplate(
    id: 'operator',
    name: 'The Operator',
    tagline: 'Already in motion, optimizing for peak performance',
    description:
        'You\'re already moving. Your accomplishment is fresh, and you\'re looking to compete and win. You\'re not here to be fixed; you\'re here to be optimized. This intense program is designed to give high-performers the edge they need to dominate.',
    icon: Icons.rocket_launch,
    color: Color(0xFFF94144), // Red/Warning
    coreHabitIds: [
      'wake_up_no_snooze',
      'intense_exercise',
      'deep_work',
      'no_social_media',
      'read_pages',
      'plan_tasks',
      'embrace_suck',
    ],
  );

  /// Profile 4: "The Stoic Path" (The Internal Warrior)
  static const stoicPath = ProgramTemplate(
    id: 'stoic_path',
    name: 'The Stoic Path',
    tagline: 'Mastering the internal battlefield',
    description:
        'Your primary battle is internal. You\'re fighting an invisible battle or watching from the sidelines. You\'re driven by a desire to reclaim your narrative and live without regrets. This program focuses on mental fortitude, mindfulness, and resilience.',
    icon: Icons.psychology,
    color: Color(0xFF90BE6D), // Green/Success
    coreHabitIds: [
      'meditate',
      'journal',
      'gratitude',
      'read_pages',
      'exercise',
      'remember_why',
      'no_phone_morning',
    ],
  );

  /// Profile 5: "The Pioneer" (The Young Founder)
  static const pioneer = ProgramTemplate(
    id: 'pioneer',
    name: 'The Pioneer',
    tagline: 'Building a life for the first time',
    description:
        'You\'re not re-building a life; you\'re building it for the first time. You\'re young, aspirational, and ready to forge your path. This program provides formative, foundational habits that will set you up for long-term success.',
    icon: Icons.explore,
    color: Color(0xFFFFB703), // Yellow/Amber
    coreHabitIds: [
      'wake_up_no_snooze',
      'make_bed',
      'exercise',
      'read_pages',
      'learn_skill',
      'plan_tasks',
      'drink_water',
    ],
  );

  /// All program templates
  static const List<ProgramTemplate> all = [
    phoenix,
    architect,
    operator,
    stoicPath,
    pioneer,
  ];

  /// Get program template by ID
  static ProgramTemplate? findById(String id) {
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Analyze questionnaire responses and recommend a program
  static String recommendProgram(Map<String, dynamic> responses) {
    print('🤖 ========== AI ANALYSIS STARTED ==========');
    print('📊 Analyzing user responses to recommend the best program...\n');

    // Extract answers
    final chapterTitle = responses['chapter_title'] as String?;
    final futureVision = responses['future_vision'] as String?;
    final accomplishment = responses['accomplishment_feeling'] as String?;
    final morningMindset = responses['morning_mindset'] as String?;
    final struggles = responses['current_struggles'] as List?;
    final ageGroup = responses['age_group'] as String?;

    print('📋 User Responses:');
    print('  • Chapter Title: $chapterTitle');
    print('  • Future Vision: $futureVision');
    print('  • Accomplishment Feeling: $accomplishment');
    print('  • Morning Mindset: $morningMindset');
    print('  • Current Struggles: $struggles');
    print('  • Age Group: $ageGroup');
    print('');

    // Score each program
    final scores = {
      'phoenix': 0,
      'architect': 0,
      'operator': 0,
      'stoic_path': 0,
      'pioneer': 0,
    };

    print('🔍 Calculating profile scores...\n');

    // Profile 5: Pioneer (Age-based, checked first)
    if (ageGroup == '13 - 17' || ageGroup == '18 - 24') {
      scores['pioneer'] = scores['pioneer']! + 10;
      print('  ✓ Pioneer: +10 (Young age group)');
    }

    // Profile 1: Phoenix
    if (chapterTitle == 'The Great Reset' ||
        chapterTitle == 'Building from the Ashes') {
      scores['phoenix'] = scores['phoenix']! + 3;
      print('  ✓ Phoenix: +3 (Starting from difficulty/reset)');
    }
    if (accomplishment == 'It feels like a distant echo from the past.' ||
        accomplishment == 'I have to search hard to remember the feeling.' ||
        accomplishment == 'I\'m here because I need to feel it again.') {
      scores['phoenix'] = scores['phoenix']! + 3;
      print('  ✓ Phoenix: +3 (Past accomplishments feel distant)');
    }
    if (morningMindset == 'The fear of staying stuck where I am.' ||
        morningMindset == 'It feels more like a battle than a push.') {
      scores['phoenix'] = scores['phoenix']! + 2;
      print('  ✓ Phoenix: +2 (Fear of being stuck/battle mindset)');
    }
    if (struggles != null &&
        (struggles.contains('Lost in a fog without a map') ||
            struggles.contains('Running on empty with no fuel left') ||
            struggles.contains('Adrift at sea without an anchor'))) {
      scores['phoenix'] = scores['phoenix']! + 2;
      print('  ✓ Phoenix: +2 (Feeling lost/empty/adrift)');
    }

    // Profile 2: Architect
    if (chapterTitle == 'Forging the Hero' || chapterTitle == 'The Ascent') {
      scores['architect'] = scores['architect']! + 3;
      print('  ✓ Architect: +3 (Building/ascending mindset)');
    }
    if (futureVision == 'To build a legacy that outlasts me.' ||
        futureVision == 'To conquer my goals and build my vision.') {
      scores['architect'] = scores['architect']! + 3;
      print('  ✓ Architect: +3 (Legacy/vision-driven)');
    }
    if (morningMindset == 'The promises I\'ve made to myself.') {
      scores['architect'] = scores['architect']! + 2;
      print('  ✓ Architect: +2 (Self-promise driven)');
    }
    if (struggles != null &&
        struggles.contains('Carrying a weight I can\'t put down')) {
      scores['architect'] = scores['architect']! + 2;
      print('  ✓ Architect: +2 (Carrying responsibility)');
    }

    // Profile 3: Operator
    if (chapterTitle == 'Declaring War on Mediocrity' ||
        chapterTitle == 'Forging the Hero') {
      scores['operator'] = scores['operator']! + 3;
      print('  ✓ Operator: +3 (War on mediocrity/hero mindset)');
    }
    if (futureVision ==
        'To become the strongest version of myself, period.') {
      scores['operator'] = scores['operator']! + 3;
      print('  ✓ Operator: +3 (Peak performance focus)');
    }
    if (accomplishment == 'The feeling is still fresh and motivating me.') {
      scores['operator'] = scores['operator']! + 3;
      print('  ✓ Operator: +3 (Recent accomplishment driving)');
    }
    if (morningMindset == 'The opportunity to compete and win the day.') {
      scores['operator'] = scores['operator']! + 3;
      print('  ✓ Operator: +3 (Competitive mindset)');
    }

    // Profile 4: Stoic Path
    if (chapterTitle == 'Reclaiming the Narrative') {
      scores['stoic_path'] = scores['stoic_path']! + 3;
      print('  ✓ Stoic Path: +3 (Reclaiming narrative)');
    }
    if (futureVision ==
        'To live a life without what-ifs or regrets.') {
      scores['stoic_path'] = scores['stoic_path']! + 3;
      print('  ✓ Stoic Path: +3 (No regrets philosophy)');
    }
    if (morningMindset == 'The pressure to perform and not fall behind.' ||
        morningMindset == 'It feels more like a battle than a push.') {
      scores['stoic_path'] = scores['stoic_path']! + 2;
      print('  ✓ Stoic Path: +2 (Internal pressure/battle)');
    }
    if (struggles != null &&
        (struggles.contains('Fighting an invisible, internal battle') ||
            struggles
                .contains('Watching my own life from the sidelines'))) {
      scores['stoic_path'] = scores['stoic_path']! + 3;
      print('  ✓ Stoic Path: +3 (Internal battle/watching from sidelines)');
    }

    // Find the program with the highest score
    String recommendedId = 'phoenix'; // Default fallback
    int maxScore = 0;

    print('\n📈 Final Profile Scores:');
    scores.forEach((programId, score) {
      final programName = findById(programId)?.name ?? programId;
      print('  • $programName: $score points');
      if (score > maxScore) {
        maxScore = score;
        recommendedId = programId;
      }
    });

    final recommendedProgram = findById(recommendedId);
    print('\n🎯 RECOMMENDATION: ${recommendedProgram?.name ?? recommendedId}');
    print('   Score: $maxScore points');
    print('   "${recommendedProgram?.tagline ?? ''}"');
    print('🤖 ========== AI ANALYSIS COMPLETE ==========\n');

    return recommendedId;
  }
}
