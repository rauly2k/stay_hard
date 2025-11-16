import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../features/user_profile_completion/constants/habit_templates.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../../../shared/data/models/goal_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_providers.dart';

class EnhancedHabitCard extends ConsumerStatefulWidget {
  final Habit habit;
  final DateTime selectedDate;
  final List<Goal> linkedGoals;
  final VoidCallback? onTap;
  final Function(bool)? onCompletionChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const EnhancedHabitCard({
    super.key,
    required this.habit,
    required this.selectedDate,
    this.linkedGoals = const [],
    this.onTap,
    this.onCompletionChanged,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  @override
  ConsumerState<EnhancedHabitCard> createState() => _EnhancedHabitCardState();
}

class _EnhancedHabitCardState extends ConsumerState<EnhancedHabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _completionController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeOutBack,
    ));

    final completionService = ref.read(habitCompletionProvider);
    if (completionService.isHabitCompleted(widget.habit, widget.selectedDate)) {
      _completionController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(EnhancedHabitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final completionService = ref.read(habitCompletionProvider);
    final isCompleted = completionService.isHabitCompleted(widget.habit, widget.selectedDate);

    if (isCompleted && _completionController.value == 0.0) {
      _completionController.forward();
    } else if (!isCompleted && _completionController.value == 1.0) {
      _completionController.reverse();
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final template = HabitTemplates.findById(widget.habit.templateId);
    final completionService = ref.watch(habitCompletionProvider);
    final isCompleted = completionService.isHabitCompleted(widget.habit, widget.selectedDate);

    final habitColor = template?.color ?? theme.colorScheme.primary;
    final habitIcon = template?.icon ?? Icons.check_circle;
    final habitName = template?.name ?? 'Unknown Habit';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        key: ValueKey(widget.habit.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (widget.onEdit != null)
              SlidableAction(
                onPressed: (_) => widget.onEdit?.call(),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            if (widget.onArchive != null)
              SlidableAction(
                onPressed: (_) => widget.onArchive?.call(),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                icon: Icons.archive,
                label: 'Archive',
              ),
            if (widget.onDelete != null)
              SlidableAction(
                onPressed: (_) => _confirmDelete(context),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
          ],
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? habitColor
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Habit Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: habitColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    habitIcon,
                    color: habitColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // Habit Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Habit Name
                      Text(
                        habitName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationThickness: 2,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Time of Day Chips
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.habit.timeOfDay.map((timeOfDay) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getTimeOfDayLabel(timeOfDay),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Linked Goals Indicator
                      if (widget.linkedGoals.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.flag,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.linkedGoals.length} goal${widget.linkedGoals.length > 1 ? 's' : ''}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Completion Button
                GestureDetector(
                  onTap: () {
                    if (isCompleted) {
                      _completionController.reverse();
                    } else {
                      _completionController.forward();
                    }
                    widget.onCompletionChanged?.call(!isCompleted);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted ? habitColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: habitColor,
                        width: 2,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeOfDayLabel(TimeOfDayEnum timeOfDay) {
    switch (timeOfDay) {
      case TimeOfDayEnum.morning:
        return 'Morning';
      case TimeOfDayEnum.afternoon:
        return 'Afternoon';
      case TimeOfDayEnum.evening:
        return 'Evening';
      case TimeOfDayEnum.anytime:
        return 'Anytime';
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text(
          'Are you sure you want to delete this habit? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      widget.onDelete?.call();
    }
  }
}
