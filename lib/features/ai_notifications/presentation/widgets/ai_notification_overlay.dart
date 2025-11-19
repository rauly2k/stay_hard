import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/ai_notification_config.dart';
import '../../data/models/archetype_details.dart';

/// Full-screen AI Notification Overlay
class AINotificationOverlay extends StatefulWidget {
  final String message;
  final AIArchetype archetype;
  final VoidCallback onDismiss;
  final VoidCallback onViewHabits;

  const AINotificationOverlay({
    super.key,
    required this.message,
    required this.archetype,
    required this.onDismiss,
    required this.onViewHabits,
  });

  @override
  State<AINotificationOverlay> createState() => _AINotificationOverlayState();
}

class _AINotificationOverlayState extends State<AINotificationOverlay> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after 60 seconds
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final archetypeDetails = ArchetypeDetails.getForType(widget.archetype);

    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black.withOpacity(0.95),
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            // Swipe down to dismiss
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 500) {
              widget.onDismiss();
            }
          },
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Archetype Icon with pulse animation
                    Text(
                      archetypeDetails?.emoji ?? '🤖',
                      style: const TextStyle(fontSize: 96),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.0, 1.0),
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOut,
                        ),

                    const SizedBox(height: 40),

                    // Message Text
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms),

                    const SizedBox(height: 60),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.onViewHabits,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View My Habits',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 16),

                    // Dismiss Button
                    TextButton(
                      onPressed: widget.onDismiss,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: const Text(
                        'Dismiss',
                        style: TextStyle(fontSize: 16),
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 16),

                    // Swipe indicator
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 32,
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .moveY(
                          begin: -5,
                          end: 5,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).scale(
              begin: const Offset(0.9, 0.9),
              duration: 300.ms,
            ),
      ),
    );
  }
}

/// Show AI Notification Overlay
Future<void> showAINotificationOverlay({
  required BuildContext context,
  required String message,
  required AIArchetype archetype,
  required VoidCallback onViewHabits,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => AINotificationOverlay(
      message: message,
      archetype: archetype,
      onDismiss: () => Navigator.of(context).pop(),
      onViewHabits: () {
        Navigator.of(context).pop();
        onViewHabits();
      },
    ),
  );
}
