import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/ai_notification_config.dart';
import '../../data/models/archetype_details.dart';
import '../providers/ai_notification_providers.dart';

/// Main AI Onboarding Flow Widget
class AIOnboardingFlow extends ConsumerStatefulWidget {
  const AIOnboardingFlow({super.key});

  @override
  ConsumerState<AIOnboardingFlow> createState() => _AIOnboardingFlowState();
}

class _AIOnboardingFlowState extends ConsumerState<AIOnboardingFlow> {
  int currentStep = 0;
  AIArchetype? selectedArchetype;
  AIIntensity selectedIntensity = AIIntensity.medium;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveConfigAndRequestPermission() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || selectedArchetype == null) return;

    final config = AINotificationConfig(
      userId: userId,
      archetype: selectedArchetype!,
      intensity: selectedIntensity,
      isEnabled: true,
      onboardingCompletedAt: DateTime.now(),
    );

    try {
      // Save configuration
      final repository = ref.read(aiNotificationRepositoryProvider);
      await repository.saveConfig(config);

      // Request notification permission
      await Permission.notification.request();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI Companion activated! 🤖'),
            backgroundColor: Colors.green,
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

  Future<void> _saveConfigWithoutPermission() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || selectedArchetype == null) return;

    final config = AINotificationConfig(
      userId: userId,
      archetype: selectedArchetype!,
      intensity: selectedIntensity,
      isEnabled: false, // Disabled for now
      onboardingCompletedAt: DateTime.now(),
    );

    try {
      final repository = ref.read(aiNotificationRepositoryProvider);
      await repository.saveConfig(config);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Page view
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildWelcomeScreen(),
                _buildHowItWorksScreen(),
                _buildArchetypeSelectionScreen(),
                _buildIntensitySelectionScreen(),
                _buildPermissionScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🤖',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 24),
          Text(
            'Meet Your Personal\nAccountability Partner',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'We\'ve built an AI system that sends you personalized motivational notifications to keep you on track with your habits and goals.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Step 2 of 4',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          const Text(
            '📱 → 💬 → ⚡',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 24),
          Text(
            'Smart, Not Annoying',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your AI analyzes:\n'
            '• Your daily habits & progress\n'
            '• Time of day and context\n'
            '• Your goals and deadlines\n'
            '• Your personality type\n\n'
            'Then sends timely messages when you need them most.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildArchetypeSelectionScreen() {
    final archetypes = ArchetypeDetails.getAll();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Step 3 of 4',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 8),
              Text(
                'Pick Your Communication Style',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'Tap "Preview" to see a sample message',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: archetypes.length,
            itemBuilder: (context, index) {
              final archetype = archetypes[index];
              final isSelected = selectedArchetype == archetype.type;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                elevation: isSelected ? 4 : 1,
                child: InkWell(
                  onTap: () {
                    setState(() => selectedArchetype = archetype.type);
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
                            onPressed: () => _showPreviewDialog(archetype),
                            icon: const Icon(Icons.visibility, size: 16),
                            label: const Text('Preview Message'),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedArchetype != null ? _nextStep : null,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntensitySelectionScreen() {
    final intensities = IntensityDetails.getAll();

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Step 4 of 4',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          const Text(
            'How Often Should I Reach Out?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Slider(
            value: selectedIntensity.index.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: (value) {
              setState(() {
                selectedIntensity = AIIntensity.values[value.toInt()];
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Low', style: TextStyle(fontSize: 12)),
              Text('Medium', style: TextStyle(fontSize: 12)),
              Text('High', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 ${intensities[selectedIntensity.index].name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...intensities[selectedIntensity.index]
                    .features
                    .map((feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('• $feature', style: const TextStyle(fontSize: 12)),
                        )),
                const SizedBox(height: 8),
                if (selectedIntensity == AIIntensity.medium)
                  Text(
                    'Recommended for most users',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Final Step',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          const Text(
            '🔔',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 24),
          const Text(
            'Enable Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'To receive your personalized AI messages, we need permission to send notifications.\n\n'
            'You can:\n'
            '• Adjust intensity anytime\n'
            '• Set quiet hours\n'
            '• Change AI personality\n'
            '• Turn off completely',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveConfigAndRequestPermission,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Enable Notifications',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _saveConfigWithoutPermission,
            child: const Text('Skip for Now'),
          ),
        ],
      ),
    );
  }
}
