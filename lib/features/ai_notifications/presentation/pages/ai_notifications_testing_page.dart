import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_notification_config.dart';
import '../../data/models/archetype_details.dart';
import '../../data/models/notification_intervention_category.dart';
import '../../domain/services/ai_message_generator.dart';
import '../providers/ai_notification_providers.dart';

/// AI Notifications Testing Page
/// Based on AI_NOTIFICATION_SYSTEM_SPEC.md Section 5
class AINotificationsTestingPage extends ConsumerStatefulWidget {
  const AINotificationsTestingPage({super.key});

  @override
  ConsumerState<AINotificationsTestingPage> createState() =>
      _AINotificationsTestingPageState();
}

class _AINotificationsTestingPageState
    extends ConsumerState<AINotificationsTestingPage> {
  final Map<InterventionCategory, bool> _isGenerating = {};
  final Map<InterventionCategory, String?> _generatedMessages = {};
  final Map<InterventionCategory, DateTime?> _lastGenerated = {};
  AIArchetype _selectedArchetype = AIArchetype.friendlyCoach;
  int _selectedMilestone = 7; // For streak celebration testing

  @override
  void initState() {
    super.initState();
    for (final category in InterventionCategory.values) {
      _isGenerating[category] = false;
      _generatedMessages[category] = null;
      _lastGenerated[category] = null;
    }
  }

  Future<void> _generateAndSendTest(InterventionCategory category) async {
    // Rate limiting check
    final lastGen = _lastGenerated[category];
    if (lastGen != null &&
        DateTime.now().difference(lastGen).inSeconds < 20) {
      final remainingSeconds = 20 - DateTime.now().difference(lastGen).inSeconds;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please wait $remainingSeconds seconds before testing again'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isGenerating[category] = true;
      _generatedMessages[category] = null;
    });

    try {
      // Create a mock notification context based on category
      final context = _createMockContext(category);

      // Generate AI message
      final message = await _generateMessage(context, category);

      setState(() {
        _generatedMessages[category] = message;
        _lastGenerated[category] = DateTime.now();
      });

      // Send as actual notification (in a real app)
      // For now, show a preview
      if (mounted) {
        _showNotificationPreview(category, message);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isGenerating[category] = false;
      });
    }
  }

  NotificationContext _createMockContext(InterventionCategory category) {
    // Create different contexts based on category
    switch (category) {
      case InterventionCategory.morningMotivation:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.morningMotivation,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 0,
          pendingHabitNames: ['Morning Workout', 'Meditation', 'Reading'],
          currentStreak: 7,
          longestStreak: 15,
          completionRate7Days: 0.85,
          timeOfDay: 'morning',
        );

      case InterventionCategory.missedHabitRecovery:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.streakRecovery,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 1,
          pendingHabitNames: ['Morning Workout', 'Reading'],
          currentStreak: 0,
          longestStreak: 15,
          completionRate7Days: 0.40,
          timeOfDay: 'afternoon',
        );

      case InterventionCategory.lowMoraleBoost:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.encouragement,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 2,
          pendingHabitNames: ['Workout', 'Reading', 'Meditation'],
          currentStreak: 3,
          longestStreak: 15,
          completionRate7Days: 0.35,
          timeOfDay: 'afternoon',
        );

      case InterventionCategory.streakCelebration:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.streakMilestone,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 5,
          pendingHabitNames: [],
          currentStreak: _selectedMilestone,
          longestStreak: _selectedMilestone,
          completionRate7Days: 1.0,
          timeOfDay: 'evening',
        );

      case InterventionCategory.eveningCheckIn:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.eveningReflection,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 4,
          pendingHabitNames: ['Evening Reflection'],
          currentStreak: 10,
          longestStreak: 15,
          completionRate7Days: 0.90,
          timeOfDay: 'evening',
        );

      case InterventionCategory.comebackSupport:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.encouragement,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 0,
          pendingHabitNames: ['All habits'],
          currentStreak: 0,
          longestStreak: 15,
          completionRate7Days: 0.20,
          timeOfDay: 'morning',
        );

      case InterventionCategory.progressInsights:
        return NotificationContext(
          userId: 'test-user',
          scenario: NotificationScenario.customTiming,
          timestamp: DateTime.now(),
          totalHabitsToday: 5,
          completedCount: 5,
          pendingHabitNames: [],
          currentStreak: 14,
          longestStreak: 20,
          completionRate7Days: 0.75,
          timeOfDay: 'evening',
        );
    }
  }

  Future<String> _generateMessage(
    NotificationContext context,
    InterventionCategory category,
  ) async {
    try {
      // Use the real AI Message Generator service
      final generator = ref.read(aiMessageGeneratorProvider);

      final message = await generator.generateMessage(
        context: context,
        archetype: _selectedArchetype,
        intensity: AIIntensity.medium, // Default to medium for testing
        category: category,
      );

      return message;
    } catch (e) {
      // If AI generation fails, return a helpful error message
      print('AI generation error: $e');

      // Fallback to simple mock messages for testing without API key
      final categoryName = category.displayName;
      switch (_selectedArchetype) {
        case AIArchetype.drillSergeant:
          return 'SOLDIER! Time to tackle $categoryName! No excuses! 💪';
        case AIArchetype.friendlyCoach:
          return 'Hey friend! Let\'s work on $categoryName together! 🌟';
        case AIArchetype.wiseMentor:
          return 'As the ancients say, $categoryName is the path to wisdom. 🧘';
        case AIArchetype.motivationalSpeaker:
          return 'YOU CAN DO THIS! $categoryName is calling your name! 🔥';
        case AIArchetype.philosopher:
          return 'Reflect on $categoryName and its meaning in your journey. 🤔';
        case AIArchetype.humorousFriend:
          return 'Time for $categoryName! Don\'t worry, I won\'t tell if you skip... just kidding! 😄';
        case AIArchetype.competitor:
          return 'Game time! $categoryName is your next challenge to conquer! 🏆';
        case AIArchetype.growthGuide:
          return 'Every step in $categoryName is growth. Embrace the process! 🌱';
      }
    }
  }

  Widget _buildCurrentArchetypeCard() {
    final archetypeDetails = ArchetypeDetails.getForType(_selectedArchetype);
    if (archetypeDetails == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            archetypeDetails.emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  archetypeDetails.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  archetypeDetails.tagline,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showArchetypeSelector() {
    final archetypes = ArchetypeDetails.getAll();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select AI Style',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Archetype list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: archetypes.length,
                itemBuilder: (context, index) {
                  final archetype = archetypes[index];
                  final isSelected = _selectedArchetype == archetype.type;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    elevation: isSelected ? 4 : 1,
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedArchetype = archetype.type);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  archetype.emoji,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        archetype.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        archetype.tagline,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              archetype.description,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            // Preview button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showPreviewDialog(archetype);
                                },
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Preview Sample Message'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPreviewDialog(ArchetypeDetails archetype) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji with pulse effect
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      archetype.emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Archetype name
              Text(
                archetype.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Divider
              Container(
                width: 50,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 16),

              // Sample message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  archetype.sampleMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationPreview(
    InterventionCategory category,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(category.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category.displayName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AI Style: ${_selectedArchetype.name}',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Sent!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apiKey = ref.watch(geminiApiKeyProvider);
    final hasValidApiKey = apiKey != 'YOUR_API_KEY_HERE' && apiKey.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test AI Notifications'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // API Key Status Banner
          if (!hasValidApiKey)
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'API Key Required',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To test real AI-generated notifications, you need a Gemini API key.\n\n'
                      'To add your API key:\n'
                      '1. Get a free API key from https://makersuite.google.com/app/apikey\n'
                      '2. Update the geminiApiKeyProvider in ai_notification_providers.dart\n'
                      '3. Replace "YOUR_API_KEY_HERE" with your actual key\n\n'
                      'Without an API key, fallback mock messages will be used.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          if (!hasValidApiKey) const SizedBox(height: 16),

          // AI Style Selector
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current AI Style',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showArchetypeSelector,
                        icon: const Icon(Icons.tune, size: 18),
                        label: const Text('Change Style'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Current archetype display
                  _buildCurrentArchetypeCard(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        hasValidApiKey ? Icons.check_circle : Icons.offline_bolt,
                        size: 16,
                        color: hasValidApiKey ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hasValidApiKey
                              ? 'Using real AI generation with your updated prompts'
                              : 'Using fallback mock messages',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hasValidApiKey ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Intervention Types
          Text(
            'Intervention Types',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...InterventionCategory.values.map(
            (category) => _buildTestCard(category, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(InterventionCategory category, ThemeData theme) {
    final isGenerating = _isGenerating[category] ?? false;
    final generatedMessage = _generatedMessages[category];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  category.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        category.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Special controls for streak celebration
            if (category == InterventionCategory.streakCelebration) ...[
              Row(
                children: [
                  const Text('Milestone: '),
                  DropdownButton<int>(
                    value: _selectedMilestone,
                    items: [7, 14, 30, 60, 100, 365]
                        .map(
                          (days) => DropdownMenuItem(
                            value: days,
                            child: Text('$days days'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedMilestone = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isGenerating
                    ? null
                    : () => _generateAndSendTest(category),
                child: isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Generating...'),
                        ],
                      )
                    : const Text('Generate & Send Test'),
              ),
            ),

            // Show generated message if available
            if (generatedMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Last Generated:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(generatedMessage),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
