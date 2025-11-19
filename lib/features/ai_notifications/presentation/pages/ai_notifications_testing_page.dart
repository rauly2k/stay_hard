import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_notification_config.dart';
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
    // In a real implementation, this would use the AI service
    // For now, return a mock message based on archetype
    await Future.delayed(const Duration(seconds: 2)); // Simulate AI call

    final archetypeName = _selectedArchetype.name;
    final categoryName = category.displayName;

    // Simple mock messages
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test AI Notifications'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI Style Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current AI Style',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<AIArchetype>(
                    isExpanded: true,
                    value: _selectedArchetype,
                    items: AIArchetype.values
                        .map(
                          (archetype) => DropdownMenuItem(
                            value: archetype,
                            child: Text(archetype.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedArchetype = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Habit Context: Using your actual habits',
                    style: theme.textTheme.bodySmall,
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
