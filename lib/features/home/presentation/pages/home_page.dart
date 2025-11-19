import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../user_profile_completion/constants/habit_templates.dart';
import '../../../user_profile_completion/domain/services/habit_configuration_service.dart';
import '../../../user_profile_completion/presentation/widgets/add_extra_habits_sheet.dart';
import '../../../ai_notifications/presentation/widgets/ai_onboarding_flow.dart';
import '../../../ai_notifications/presentation/providers/ai_notification_providers.dart';
import '../../../../shared/data/models/goal_model.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../../shared/presentation/widgets/ai_empty_state.dart';
import '../../../../shared/presentation/widgets/profile_menu_dropdown.dart';
import '../providers/habit_providers.dart';
import '../widgets/add_habit_choice_dialog.dart';
import '../widgets/enhanced_habit_card.dart';
import '../widgets/hero_graphic.dart';
import '../widgets/horizontal_calendar.dart';
import 'habit_detail_page.dart';
import 'edit_habit_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _hasCheckedAIOnboarding = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkFirstTimeAISetup();
  }

  Future<void> _checkFirstTimeAISetup() async {
    if (_hasCheckedAIOnboarding) return;

    // Wait 1.5 seconds for UI to settle
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    _hasCheckedAIOnboarding = true;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    try {
      final repository = ref.read(aiNotificationRepositoryProvider);
      final config = await repository.getConfig(userId);

      if (config == null && mounted) {
        // User hasn't set up AI notifications yet
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AIOnboardingFlow(),
        );
      }
    } catch (e) {
      // Silently fail - don't block user if AI onboarding fails
      print('Error checking AI onboarding: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Handle add habit action - shows choice dialog for template or custom habit
  Future<void> _handleAddHabit() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => const AddHabitChoiceDialog(),
    );

    if (choice == null || !mounted) return; // User cancelled

    if (choice == 'template') {
      // Show template picker bottom sheet
      final selectedTemplateIds = await showModalBottomSheet<Set<String>>(
        context: context,
        isScrollControlled: true,
        builder: (context) => const AddExtraHabitsSheet(
          programCoreHabitIds: [],
          currentExtraHabitIds: {},
        ),
      );

      if (selectedTemplateIds == null ||
          selectedTemplateIds.isEmpty ||
          !mounted) {
        return;
      }

      // For each selected template, show configuration dialog
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to add habits')),
          );
        }
        return;
      }

      int successCount = 0;
      for (final templateId in selectedTemplateIds) {
        final template = HabitTemplates.findById(templateId);
        if (template == null) continue;

        // Show config dialog
        if (!mounted) break;
        final config = await HabitConfigurationService.showConfigurationDialog(
          context,
          template.id,
          template.name,
        );

        if (config == null) continue; // User cancelled this habit

        // Create habit
        try {
          final habit = Habit(
            id: const Uuid().v4(),
            userId: currentUser.uid,
            templateId: templateId,
            configuration: config,
            description: '',
            soundId: 'default',
            repeatConfig: RepeatConfig.daily(),
            timeOfDay: [TimeOfDayEnum.anytime],
            specificReminders: [],
            completionLog: {},
            createdAt: DateTime.now(),
            isActive: true,
            sortOrder: 0,
            notificationsEnabled: true,
            aiCoachEnabled: false,
          );

          await ref.read(habitFormProvider.notifier).saveHabit(habit);
          successCount++;
        } catch (e) {
          // Continue with next habit even if one fails
          continue;
        }
      }

      // Show success message
      if (mounted && successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Added $successCount habit${successCount > 1 ? 's' : ''} successfully!'),
          ),
        );
      }
    } else if (choice == 'custom') {
      // Navigate to custom form (placeholder for now)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom habit creation coming soon!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final habitsAsync = ref.watch(habitsForDateProvider(selectedDate));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/LOGO.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: const [
          ProfileMenuDropdown(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top horizontal calendar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: HorizontalCalendar(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).setDate(date);
                },
              ),
            ),

            // Hero graphic section - Daily progress overview
            HeroGraphic(selectedDate: selectedDate),

            // Time of day tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(2),
                labelColor: theme.colorScheme.onPrimary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                tabs: const [
                  Tab(text: 'All Day'),
                  Tab(text: 'Morning'),
                  Tab(text: 'Afternoon'),
                  Tab(text: 'Evening'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Habits list
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHabitsList(habitsAsync, null),
                  _buildHabitsList(habitsAsync, TimeOfDayEnum.morning),
                  _buildHabitsList(habitsAsync, TimeOfDayEnum.afternoon),
                  _buildHabitsList(habitsAsync, TimeOfDayEnum.evening),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddHabit,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
        elevation: 4,
      ),
    );
  }

  Widget _buildHabitsList(
      AsyncValue<List<Habit>> habitsAsync, TimeOfDayEnum? timeFilter) {
    return habitsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (habits) {
        // Filter habits by time of day if specified
        final filteredHabits = timeFilter != null
            ? habits
                .where((habit) =>
                    habit.timeOfDay.contains(timeFilter) ||
                    habit.timeOfDay.contains(TimeOfDayEnum.anytime))
                .toList()
            : habits;

        if (filteredHabits.isEmpty) {
          return _buildAIEmptyState(timeFilter);
        }

        // Fetch goals for linking
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const BouncingScrollPhysics(),
            itemCount: filteredHabits.length,
            cacheExtent: 500,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final habit = filteredHabits[index];
              return EnhancedHabitCard(
                habit: habit,
                selectedDate: ref.watch(selectedDateProvider),
                linkedGoals: const [],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitDetailPage(habit: habit),
                    ),
                  );
                },
                onCompletionChanged: (completed) =>
                    _handleHabitCompletion(habit, completed),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHabitPage(habit: habit),
                    ),
                  );
                },
                onArchive: () => _handleArchive(habit),
                onDelete: () => _handleDelete(habit),
              );
            },
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('goals')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, goalsSnapshot) {
            final goals = goalsSnapshot.hasData
                ? goalsSnapshot.data!.docs
                    .map((doc) {
                      try {
                        return Goal.fromJson(doc.data() as Map<String, dynamic>);
                      } catch (e) {
                        return null;
                      }
                    })
                    .whereType<Goal>()
                    .toList()
                : <Goal>[];

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const BouncingScrollPhysics(),
              itemCount: filteredHabits.length,
              cacheExtent: 500,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final habit = filteredHabits[index];
                final linkedGoals = goals
                    .where((goal) => goal.habitIds.contains(habit.id))
                    .toList();

                return EnhancedHabitCard(
                  habit: habit,
                  selectedDate: ref.watch(selectedDateProvider),
                  linkedGoals: linkedGoals,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HabitDetailPage(habit: habit),
                      ),
                    );
                  },
                  onCompletionChanged: (completed) =>
                      _handleHabitCompletion(habit, completed),
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditHabitPage(habit: habit),
                      ),
                    );
                  },
                  onArchive: () => _handleArchive(habit),
                  onDelete: () => _handleDelete(habit),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAIEmptyState(TimeOfDayEnum? timeFilter) {
    final timeOfDayName = timeFilter?.name.capitalize() ?? 'any time';

    return AIEmptyState(
      pageType: 'habits',
      title: timeFilter != null
          ? 'No habits for $timeOfDayName'
          : 'Ready to build your first habit?',
      subtitle: timeFilter != null
          ? 'Perfect time to create a $timeOfDayName habit!'
          : 'Start by adding your first habit',
      icon: Icons.self_improvement,
      actionText: 'Create Habit',
      onActionPressed: _handleAddHabit,
      additionalContent:
          timeFilter != null ? _buildTimeSpecificTips(timeFilter) : null,
    );
  }

  Widget _buildTimeSpecificTips(TimeOfDayEnum timeFilter) {
    final theme = Theme.of(context);

    final tips = {
      TimeOfDayEnum.morning: [
        'Morning habits stick better',
        'Start with just 5 minutes',
        'Stack onto your existing routine'
      ],
      TimeOfDayEnum.afternoon: [
        'Great for energy-boosting activities',
        'Use lunch break productively',
        'Combat the afternoon slump'
      ],
      TimeOfDayEnum.evening: [
        'Perfect for reflection habits',
        'Wind down with purpose',
        'Prepare for tomorrow'
      ],
    };

    final timeSpecificTips = tips[timeFilter] ?? [];

    if (timeSpecificTips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 ${timeFilter.name.capitalize()} Tips',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...timeSpecificTips
              .map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style:
                                TextStyle(color: theme.colorScheme.primary)),
                        Expanded(
                          child: Text(
                            tip,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  void _handleHabitCompletion(Habit habit, bool completed) {
    final selectedDate = ref.read(selectedDateProvider);
    ref
        .read(habitCompletionProvider)
        .toggleHabitCompletion(habit.id, selectedDate, ref);
  }

  Future<void> _handleArchive(Habit habit) async {
    try {
      final updatedHabit = habit.copyWith(isActive: !habit.isActive);
      await ref.read(habitFormProvider.notifier).saveHabit(updatedHabit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(habit.isActive
                ? 'Habit archived'
                : 'Habit restored'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await ref.read(habitFormProvider.notifier).saveHabit(habit);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(Habit habit) async {
    try {
      await ref.read(habitFormProvider.notifier).deleteHabit(habit.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit deleted'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
