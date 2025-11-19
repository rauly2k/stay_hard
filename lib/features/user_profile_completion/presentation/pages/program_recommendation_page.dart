import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/program_templates.dart';
import '../../constants/habit_templates.dart';
import '../../domain/state/onboarding_state_machine.dart';

/// Program recommendation page after questionnaire
class ProgramRecommendationPage extends ConsumerWidget {
  const ProgramRecommendationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateMachineProvider);
    final programId = state.recommendedProgramId ?? 'phoenix';
    final program = ProgramTemplates.findById(programId);

    if (program == null) {
      return const Scaffold(
        body: Center(child: Text('Program not found')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Your Perfect Match',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Based on your answers, we recommend:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Program Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            program.color,
                            program.color.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: program.color.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              program.icon,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Name
                          Text(
                            program.name,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Tagline
                          Text(
                            program.tagline,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Description
                    Text(
                      'What This Means For You',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      program.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Core Habits Preview
                    Text(
                      'Your Core Habits',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'These ${program.coreHabitIds.length} habits will form your foundation:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Group habits by category
                    ...() {
                      // Organize habits by category
                      final habitsByCategory = <HabitCategory, List<HabitTemplate>>{};

                      for (final habitId in program.coreHabitIds) {
                        final habitTemplate = HabitTemplates.findById(habitId);
                        if (habitTemplate != null) {
                          habitsByCategory.putIfAbsent(
                            habitTemplate.category,
                            () => [],
                          ).add(habitTemplate);
                        }
                      }

                      // Build category sections
                      final widgets = <Widget>[];

                      for (final category in HabitCategory.values) {
                        final habits = habitsByCategory[category];
                        if (habits == null || habits.isEmpty) continue;

                        // Category header
                        widgets.add(
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: HabitTemplates.getCategoryColor(category)
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    HabitTemplates.getCategoryIcon(category),
                                    color: HabitTemplates.getCategoryColor(category),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${HabitTemplates.getCategoryDisplayName(category)} (${HabitTemplates.getCategoryDescription(category)})',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: HabitTemplates.getCategoryColor(category),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // Habits in this category
                        for (final habitTemplate in habits) {
                          widgets.add(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: HabitTemplates.getCategoryColor(category)
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: HabitTemplates.getCategoryColor(category)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        habitTemplate.icon,
                                        color: HabitTemplates.getCategoryColor(category),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habitTemplate.name,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            habitTemplate.detail,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      return widgets;
                    }(),

                    const SizedBox(height: 100), // Space for buttons
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Accept button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(onboardingStateMachineProvider.notifier)
                            .acceptRecommendedProgram();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: program.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Accept & Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Browse other programs
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(onboardingStateMachineProvider.notifier)
                            .browseOtherPrograms();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: program.color,
                        side: BorderSide(color: program.color),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Browse Other Programs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Create custom program
                  TextButton(
                    onPressed: () {
                      ref
                          .read(onboardingStateMachineProvider.notifier)
                          .createCustomProgram();
                    },
                    child: const Text('Or create a custom program'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
