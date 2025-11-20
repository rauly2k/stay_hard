import 'ai_notification_config.dart';

/// Details about each AI archetype for UI display
class ArchetypeDetails {
  final AIArchetype type;
  final String name;
  final String emoji;
  final String tagline;
  final String description;
  final String sampleMessage;
  final List<String> traits;

  const ArchetypeDetails({
    required this.type,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.description,
    required this.sampleMessage,
    required this.traits,
  });

  /// Get all archetype details
  static List<ArchetypeDetails> getAll() => [
        const ArchetypeDetails(
          type: AIArchetype.drillSergeant,
          name: 'Drill Sergeant',
          emoji: '🪖',
          tagline: 'Stay Hard. No Excuses.',
          description: 'Tough love inspired by David Goggins and Jocko Willink. Military-style discipline with zero tolerance for excuses. Comfort is the enemy, suffering is the forge of character.',
          sampleMessage:
              'Feet on the floor, recruit! Sun\'s up. Excuses are zero. Your bed is a trap—escape it. Execute the mission NOW! 🎖️',
          traits: [
            'Commanding and authoritative',
            'Extreme ownership mentality',
            'Zero tolerance for excuses',
            'Military terminology',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.wiseMentor,
          name: 'Wise Mentor',
          emoji: '🧘',
          tagline: 'The obstacle is the way',
          description: 'Stoic wisdom inspired by Marcus Aurelius, Seneca, and Uncle Iroh. Views habits as the path to virtue. Patient, calm, and profound. Speaks of "The Way" and helps you find stillness in chaos.',
          sampleMessage:
              'The morning is a blank page. Write a good sentence. Each day is a life in miniature. Live this one well. 🌅',
          traits: [
            'Philosophical and reflective',
            'Stoic wisdom and ancient quotes',
            'Patient and understanding',
            'Focuses on virtue and meaning',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.friendlyCoach,
          name: 'Friendly Coach',
          emoji: '🎯',
          tagline: 'Believe! We\'ve got this!',
          description: 'Relentlessly optimistic like Ted Lasso and Simon Sinek. Uses "we" language to show you\'re on the team. Celebrates small wins and believes in your potential. Your biggest fan.',
          sampleMessage:
              'Good morning, champ! ☀️ Let\'s get a win today! I believe in you! We\'ve got goals to crush and coffee to drink! 💙',
          traits: [
            'Relentlessly optimistic',
            'Celebrates every small win',
            'Uses "we" language',
            'Your biggest cheerleader',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.motivationalSpeaker,
          name: 'Motivational Speaker',
          emoji: '🔥',
          tagline: 'MASSIVE ACTION!',
          description:
              'High-energy, explosive motivation like Tony Robbins, Les Brown, and Eric Thomas. Uses capitalization for emphasis. Talks about Destiny, Hunger, and The Grind. Demands massive action NOW!',
          sampleMessage:
              'WAKE UP! TODAY IS YOUR MASTERPIECE! PAINT IT! The dream is FREE but the hustle is SOLD SEPARATELY! LET\'S GO! 🔥',
          traits: [
            'EXPLOSIVE ENERGY',
            'Vision-casting language',
            'Rhetorical questions',
            'Demands massive action',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.philosopher,
          name: 'The Philosopher',
          emoji: '🤔',
          tagline: 'Find your why',
          description:
              'Deep, existential wisdom from Nietzsche, Viktor Frankl, and Jordan Peterson. Questions the meaning behind actions. Treats habits as defense against chaos. Speaks of The Abyss, Order, and Responsibility.',
          sampleMessage:
              'Why do you rise? To experience existence? Then act. The chaos of the world awaits. Bring order to your morning. 🤔',
          traits: [
            'Deep and existential',
            'Questions meaning',
            'References great thinkers',
            'Explores purpose and order',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.humorousFriend,
          name: 'Humorous Friend',
          emoji: '😄',
          tagline: 'Adulting is hard. Let\'s do it anyway!',
          description:
              'Witty, sarcastic accountability partner like Kevin Hart and Ryan Reynolds. Self-deprecating humor with pop culture references. Acknowledges that adulting is hard but still wants you to succeed.',
          sampleMessage:
              'Coffee first. Then world domination. Or just this habit. Mostly the habit. Your bed misses you, but your goals are getting lonely! ☕',
          traits: [
            'Witty and sarcastic',
            'Pop culture references',
            'Self-deprecating humor',
            'Fun accountability partner',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.competitor,
          name: 'The Competitor',
          emoji: '🏆',
          tagline: 'Mamba Mentality. Job\'s not finished.',
          description:
              'Obsessed with winning like Michael Jordan, Kobe Bryant, and Tim Grover. Views life as a scoreboard. Uses sports metaphors and championship mentality. Cold, calculated, results-driven.',
          sampleMessage:
              'Game day. You vs. You. Who wins? Your competition is already awake. Tip-off time. Championships are won in the morning. Let\'s work. 🏆',
          traits: [
            'Championship mentality',
            'Sports metaphors everywhere',
            'Stats and scoreboard focus',
            'Demands Cleaner status',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.growthGuide,
          name: 'Growth Guide',
          emoji: '🌱',
          tagline: '1% better every day',
          description: 'Scientific, methodical approach inspired by James Clear and Andrew Huberman. Focuses on systems over goals. Talks about dopamine, neural pathways, and compound interest. Trust the process.',
          sampleMessage:
              '1% better starts with the first decision of the day. Prime your environment. Execute the morning protocol. The compound effect waits for no one. 🌱',
          traits: [
            'Systems over goals',
            'Scientific and methodical',
            'Growth mindset focus',
            'Treats failure as data',
          ],
        ),
      ];

  /// Get details for specific archetype
  static ArchetypeDetails? getForType(AIArchetype type) {
    try {
      return getAll().firstWhere((details) => details.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Get recommended archetype based on user personality (from onboarding)
  static AIArchetype getRecommendedArchetype(String? personalityType) {
    switch (personalityType?.toLowerCase()) {
      case 'phoenix':
        return AIArchetype.friendlyCoach;
      case 'architect':
        return AIArchetype.competitor;
      case 'operator':
        return AIArchetype.drillSergeant;
      case 'stoic path':
        return AIArchetype.wiseMentor;
      case 'pioneer':
        return AIArchetype.humorousFriend;
      default:
        return AIArchetype.friendlyCoach; // Default recommendation
    }
  }
}

/// Intensity level details for UI display
class IntensityDetails {
  final AIIntensity level;
  final String name;
  final String description;
  final List<String> features;
  final int notificationsPerDay;

  const IntensityDetails({
    required this.level,
    required this.name,
    required this.description,
    required this.features,
    required this.notificationsPerDay,
  });

  static List<IntensityDetails> getAll() => [
        const IntensityDetails(
          level: AIIntensity.low,
          name: 'Gentle Companion',
          description: 'Perfect for minimal interruption',
          features: [
            '1-2 notifications per day',
            'Morning motivation only',
            'Gentle encouragement tone',
            'Focus on positive reinforcement',
          ],
          notificationsPerDay: 1,
        ),
        const IntensityDetails(
          level: AIIntensity.medium,
          name: 'Active Coach',
          description: 'Recommended for most users',
          features: [
            '2-3 notifications per day',
            'Morning, midday & evening',
            'Balanced encouragement & accountability',
            'Context-aware messaging',
          ],
          notificationsPerDay: 3,
        ),
        const IntensityDetails(
          level: AIIntensity.high,
          name: 'Intense Accountability',
          description: 'For maximum motivation',
          features: [
            '3-5 notifications per day',
            'Multiple touchpoints throughout day',
            'Strong accountability language',
            'Proactive habit reminders',
          ],
          notificationsPerDay: 5,
        ),
      ];

  static IntensityDetails? getForLevel(AIIntensity level) {
    try {
      return getAll().firstWhere((details) => details.level == level);
    } catch (e) {
      return null;
    }
  }
}
