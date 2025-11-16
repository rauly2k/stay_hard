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
    switch (state.currentStep) {
      case OnboardingStep.intro:
        return const IntroPage();

      case OnboardingStep.questionnaire:
        return const QuestionnairePage();

      case OnboardingStep.loading:
        return const LoadingPage();

      case OnboardingStep.programRecommendation:
        return const ProgramRecommendationPage();

      case OnboardingStep.browsePrograms:
        return const BrowseProgramsPage();

      case OnboardingStep.customProgram:
        return const CustomProgramPage();

      case OnboardingStep.habitConfiguration:
        return const HabitConfigurationPage();

      case OnboardingStep.nameInput:
        return const NameInputPage();

      case OnboardingStep.notificationPermission:
        return const NotificationPermissionPage();

      case OnboardingStep.commitmentMessage:
        return const CommitmentMessagePage();

      case OnboardingStep.complete:
        // Navigating in listener above
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
