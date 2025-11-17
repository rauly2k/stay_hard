import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/models/focus_session_model.dart';
import '../providers/focus_providers.dart';

class ActiveSessionWidget extends ConsumerStatefulWidget {
  final FocusSession session;

  const ActiveSessionWidget({
    super.key,
    required this.session,
  });

  @override
  ConsumerState<ActiveSessionWidget> createState() => _ActiveSessionWidgetState();
}

class _ActiveSessionWidgetState extends ConsumerState<ActiveSessionWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _progressController;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _updateRemaining();
    _startTimer();
    _progressController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _updateRemaining();
        });

        // Auto-complete session when time is up
        if (_remaining.inSeconds <= 0) {
          _completeSession();
        }
      }
    });
  }

  void _updateRemaining() {
    final remaining = widget.session.remainingTime;
    if (remaining != null) {
      _remaining = remaining;
    }
  }

  void _completeSession() {
    _timer?.cancel();
    ref.read(focusSessionNotifierProvider.notifier).completeSession(widget.session.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Focus session completed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.session.progress;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVE SESSION',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Timer and progress ring
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                ),

                // Progress circle
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                ),

                // Time display
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(_remaining),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.session.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Focus mode and session info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getFocusModeIcon(widget.session.mode),
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.session.mode.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Total duration: ${_formatTotalDuration(widget.session.duration)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.apps,
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.session.blockedApps.length} apps blocked',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _showBlockedAppsDialog(context),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: const Text('View list'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip(
                theme,
                Icons.block,
                '${widget.session.blockedApps.length}',
                'Apps Blocked',
              ),
              _buildStatChip(
                theme,
                Icons.warning_amber,
                '${widget.session.blockAttempts}',
                'Attempts',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEndConfirmation(context),
                  icon: const Icon(Icons.stop),
                  label: const Text('End Session'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    side: BorderSide(
                      color: theme.colorScheme.onPrimary,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: widget.session.status == FocusSessionStatus.paused
                      ? () => _resumeSession()
                      : () => _pauseSession(),
                  icon: Icon(
                    widget.session.status == FocusSessionStatus.paused
                        ? Icons.play_arrow
                        : Icons.pause,
                  ),
                  label: Text(
                    widget.session.status == FocusSessionStatus.paused
                        ? 'Resume'
                        : 'Pause',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatTotalDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  IconData _getFocusModeIcon(FocusMode mode) {
    switch (mode) {
      case FocusMode.deepWork:
        return Icons.workspace_premium;
      case FocusMode.study:
        return Icons.school;
      case FocusMode.bedtime:
        return Icons.bedtime;
      case FocusMode.minimalDistraction:
        return Icons.notifications_off;
      case FocusMode.custom:
        return Icons.tune;
    }
  }

  void _showBlockedAppsDialog(BuildContext context) async {
    final appService = ref.read(appBlockingServiceProvider);
    final installedApps = await appService.getInstalledApps();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blocked Apps'),
        content: SizedBox(
          width: double.maxFinite,
          child: widget.session.blockedApps.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No apps are currently blocked.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.session.blockedApps.length,
                  itemBuilder: (context, index) {
                    final packageName = widget.session.blockedApps[index];
                    final app = installedApps.firstWhere(
                      (a) => a.packageName == packageName,
                      orElse: () => InstalledAppInfo(
                        packageName: packageName,
                        name: packageName,
                      ),
                    );

                    return ListTile(
                      leading: const Icon(Icons.block, color: Colors.red),
                      title: Text(app.name),
                      subtitle: Text(
                        packageName,
                        style: const TextStyle(fontSize: 11),
                      ),
                      dense: true,
                    );
                  },
                ),
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

  void _pauseSession() {
    ref.read(focusSessionNotifierProvider.notifier).pauseSession(widget.session.id);
    _timer?.cancel();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session paused')),
    );
  }

  void _resumeSession() {
    ref.read(focusSessionNotifierProvider.notifier).resumeSession(widget.session.id);
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session resumed')),
    );
  }

  void _showEndConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text(
          'Are you sure you want to end this focus session early? Your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(focusSessionNotifierProvider.notifier).cancelSession(widget.session.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session ended')),
              );
            },
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
}
