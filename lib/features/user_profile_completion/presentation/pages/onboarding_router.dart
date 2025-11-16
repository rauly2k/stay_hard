import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/state/onboarding_state_machine.dart';
import 'intro_page.dart';
import 'questionnaire_page.dart';
import 'loading_page.dart';
import 'program_recommendation_page.dart';
import 'browse_programs_page.dart';
import 'custom_program_page.dart';
import 'habit_configuration_page.dart';
import 'name_input_page.dart';
import 'notification_permission_page.dart';
import 'commitment_message_page.dart';

/// Router that displays the correct page based on onboarding state
class OnboardingRouter extends ConsumerWidget {
  const OnboardingRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateMachineProvider);

    // Listen for completion and navigate to home
    ref.listen<OnboardingState>(
      onboardingStateMachineProvider,
      (previous, next) {
        if (next.currentStep == OnboardingStep.complete) {
          context.go('/home');
        }
      },
    );

    // Show appropriate page based on current step
    return switch (state.currentStep) {
      OnboardingStep.intro => const IntroPage(),
      OnboardingStep.questionnaire => const QuestionnairePage(),
      OnboardingStep.loading => const LoadingPage(),
      OnboardingStep.programRecommendation => const ProgramRecommendationPage(),
      OnboardingStep.browsePrograms => const BrowseProgramsPage(),
      OnboardingStep.customProgram => const CustomProgramPage(),
      OnboardingStep.habitConfiguration => const HabitConfigurationPage(),
      OnboardingStep.nameInput => const NameInputPage(),
      OnboardingStep.notificationPermission => const NotificationPermissionPage(),
      OnboardingStep.commitmentMessage => const CommitmentMessagePage(),
      OnboardingStep.complete => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
    };
  }
}
