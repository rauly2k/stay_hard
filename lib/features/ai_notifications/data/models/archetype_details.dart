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
          emoji: '💪',
          tagline: 'Drop and give me 20!',
          description: 'Tough love, no excuses. Military-style discipline.',
          sampleMessage:
              'Morning, recruit! Your mission today: 8 habits. Zero completed. Drop the phone. Get to work. That\'s an order! 🎖️',
          traits: [
            'Commanding and authoritative',
            'High energy, urgency',
            'Zero tolerance for excuses',
            'Military terminology',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.wiseMentor,
          name: 'Wise Mentor',
          emoji: '🧘',
          tagline: 'Discipline is freedom',
          description: 'Calm, philosophical guidance inspired by Stoic wisdom.',
          sampleMessage:
              'Good morning. "The obstacle is the way." Your habits are not tasks—they are the path itself. Begin with one. The journey starts now. 🌅',
          traits: [
            'Philosophical and reflective',
            'Stoic wisdom',
            'Patient and understanding',
            'Deep, meaningful insights',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.friendlyCoach,
          name: 'Friendly Coach',
          emoji: '🎯',
          tagline: 'We\'ve got this together!',
          description: 'Supportive, encouraging, celebrates every win.',
          sampleMessage:
              'Hey champ! ☀️ It\'s a brand new day with 8 fresh habits waiting for you. I know you\'ve got this—yesterday you crushed 7/8. Let\'s go for perfect today! 💙',
          traits: [
            'Enthusiastic and upbeat',
            'Celebrates small wins',
            'Empathetic and warm',
            'Team player mentality',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.motivationalSpeaker,
          name: 'Motivational Speaker',
          emoji: '🔥',
          tagline: 'TIME TO DOMINATE!',
          description:
              'High energy, passionate inspiration. Tony Robbins style.',
          sampleMessage:
              'RISE AND GRIND! ⚡ Today isn\'t just another day—it\'s THE day you prove to yourself what you\'re made of! You have 8 opportunities to WIN today. Let\'s DOMINATE! 🔥',
          traits: [
            'HIGH ENERGY, dramatic',
            'Vision-casting language',
            'Calls to greatness',
            'Inspirational passion',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.philosopher,
          name: 'The Philosopher',
          emoji: '🤔',
          tagline: 'What is the meaning of this habit?',
          description:
              'Thoughtful, introspective, explores deeper purpose.',
          sampleMessage:
              'Kierkegaard asked: "What is a poet?" What will your habits compose today? Your actions are not mere repetitions—they are statements of who you choose to become. 📖',
          traits: [
            'Intellectual depth',
            'Reflective questions',
            'Historical references',
            'Explores meaning',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.humorousFriend,
          name: 'Humorous Friend',
          emoji: '😄',
          tagline: 'Let\'s have fun with this!',
          description:
              'Light-hearted, funny, makes motivation enjoyable.',
          sampleMessage:
              '☕ Good morning, sleepyhead! Your habits are doing that thing where they wait for you to remember they exist. 8 habits. 1 amazing person. Let\'s do this before your coffee gets cold! 😄',
          traits: [
            'Playful and fun',
            'Pop culture references',
            'Self-deprecating humor',
            'Makes you smile',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.competitor,
          name: 'The Competitor',
          emoji: '🏆',
          tagline: 'Protect home court!',
          description:
              'Results-driven, scoreboard mentality, championship mindset.',
          sampleMessage:
              '🏀 Game day! Today\'s matchup: YOU vs YOUR GOALS. 8 habits on the board. Current record: 21 wins, 2 losses this month. Protect home court. Tip-off: NOW.',
          traits: [
            'Sports metaphors',
            'Performance metrics',
            'Competitive framing',
            'Winner mindset',
          ],
        ),
        const ArchetypeDetails(
          type: AIArchetype.growthGuide,
          name: 'Growth Guide',
          emoji: '🌱',
          tagline: 'Every seed becomes a tree',
          description: 'Nurturing, patient, focused on long-term transformation.',
          sampleMessage:
              '🌱 Every seed needs time to become a tree. Today\'s 8 habits aren\'t just tasks—they\'re nourishment for your growth. Water them with intention. Growth happens in the doing.',
          traits: [
            'Process over outcome',
            'Growth mindset',
            'Patient and nurturing',
            'Celebrates learning',
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
