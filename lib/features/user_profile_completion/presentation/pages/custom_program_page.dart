import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/habit_templates.dart';
import '../../domain/state/onboarding_state_machine.dart';
import '../../data/models/habit_template.dart';

/// Create a custom program by selecting habits
class CustomProgramPage extends ConsumerStatefulWidget {
  const CustomProgramPage({super.key});

  @override
  ConsumerState<CustomProgramPage> createState() => _CustomProgramPageState();
}

class _CustomProgramPageState extends ConsumerState<CustomProgramPage> {
  final Set<String> _selectedHabitIds = {};

  Map<HabitCategory, List<HabitTemplate>> get _habitsByCategory {
    final Map<HabitCategory, List<HabitTemplate>> result = {};
    for (final habit in HabitTemplates.all) {
      result.putIfAbsent(habit.category, () => []).add(habit);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Custom Program'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(onboardingStateMachineProvider.notifier).goBack();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Your Habits',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the habits that align with your goals (minimum 3)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedHabitIds.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selectedHabitIds.length} habits selected',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Habits list grouped by category
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: HabitCategory.values.length,
                itemBuilder: (context, categoryIndex) {
                  final category = HabitCategory.values[categoryIndex];
                  final habits = _habitsByCategory[category];

                  if (habits == null || habits.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category header
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 12),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  HabitTemplates.getCategoryDisplayName(category),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: HabitTemplates.getCategoryColor(category),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  HabitTemplates.getCategoryDescription(category),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Habits in this category
                      ...habits.map((habit) {
                        final isSelected = _selectedHabitIds.contains(habit.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedHabitIds.remove(habit.id);
                                } else {
                                  _selectedHabitIds.add(habit.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? HabitTemplates.getCategoryColor(category)
                                        .withValues(alpha: 0.1)
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? HabitTemplates.getCategoryColor(category)
                                      : theme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Checkbox
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: isSelected
                                          ? HabitTemplates.getCategoryColor(category)
                                          : theme.colorScheme.surface,
                                      border: Border.all(
                                        color: isSelected
                                            ? HabitTemplates.getCategoryColor(category)
                                            : theme.colorScheme.outline
                                                .withValues(alpha: 0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),

                                  const SizedBox(width: 16),

                                  // Icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: HabitTemplates.getCategoryColor(category)
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      habit.icon,
                                      color: HabitTemplates.getCategoryColor(category),
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Name and detail
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.name,
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          habit.detail,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),

            // Continue button
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
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedHabitIds.length >= 3
                      ? () {
                          ref
                              .read(onboardingStateMachineProvider.notifier)
                              .selectCustomHabits(_selectedHabitIds.toList());
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedHabitIds.length >= 3
                        ? 'Continue with ${_selectedHabitIds.length} habits'
                        : 'Select at least 3 habits',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(HabitCategory category) {
    return HabitTemplates.getCategoryColor(category);
  }
}
