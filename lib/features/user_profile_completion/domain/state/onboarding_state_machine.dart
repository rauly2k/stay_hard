import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/habit_model.dart';
import '../../constants/program_templates.dart';

/// Onboarding flow steps
enum OnboardingStep {
  intro, // Parts 1 & 2: Welcome screens
  questionnaire, // Part 3: 6 questions
  loading, // Part 4: Analyzing
  programRecommendation, // Part 5: Recommended program
  browsePrograms, // Part 6a: Browse other programs
  customProgram, // Part 6b: Create custom program
  habitConfiguration, // Part 7: Configure habits
  nameInput, // Part 8a: Ask for name
  notificationPermission, // Part 8b: Request notifications
  commitmentMessage, // Part 8c: Commitment device
  complete, // Part 9: Navigate to home
}

/// Onboarding state
class OnboardingState {
  final OnboardingStep currentStep;
  final Map<String, dynamic> questionnaireResponses;
  final String? recommendedProgramId;
  final String? selectedProgramId;
  final List<Habit>? configuredHabits;
  final String? userName;
  final String? commitmentMessage;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentStep = OnboardingStep.intro,
    this.questionnaireResponses = const {},
    this.recommendedProgramId,
    this.selectedProgramId,
    this.configuredHabits,
    this.userName,
    this.commitmentMessage,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    Map<String, dynamic>? questionnaireResponses,
    String? recommendedProgramId,
    String? selectedProgramId,
    List<Habit>? configuredHabits,
    String? userName,
    String? commitmentMessage,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      questionnaireResponses:
          questionnaireResponses ?? this.questionnaireResponses,
      recommendedProgramId: recommendedProgramId ?? this.recommendedProgramId,
      selectedProgramId: selectedProgramId ?? this.selectedProgramId,
      configuredHabits: configuredHabits ?? this.configuredHabits,
      userName: userName ?? this.userName,
      commitmentMessage: commitmentMessage ?? this.commitmentMessage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Onboarding state machine notifier
class OnboardingStateMachine extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  /// Complete intro slides (Parts 1 & 2)
  void completeIntro() {
    state = state.copyWith(currentStep: OnboardingStep.questionnaire);
  }

  /// Complete questionnaire (Part 3)
  void completeQuestionnaire(Map<String, dynamic> responses) {
    state = state.copyWith(
      questionnaireResponses: responses,
      currentStep: OnboardingStep.loading,
    );

    // Simulate loading and analyze responses
    Future.delayed(const Duration(seconds: 4), () {
      final recommendedId = ProgramTemplates.recommendProgram(responses);
      state = state.copyWith(
        recommendedProgramId: recommendedId,
        selectedProgramId: recommendedId, // Default to recommended
        currentStep: OnboardingStep.programRecommendation,
      );
    });
  }

  /// Accept recommended program
  void acceptRecommendedProgram() {
    state = state.copyWith(currentStep: OnboardingStep.habitConfiguration);
  }

  /// Browse other programs
  void browseOtherPrograms() {
    state = state.copyWith(currentStep: OnboardingStep.browsePrograms);
  }

  /// Create custom program
  void createCustomProgram() {
    state = state.copyWith(currentStep: OnboardingStep.customProgram);
  }

  /// Select a specific program
  void selectProgram(String programId) {
    state = state.copyWith(
      selectedProgramId: programId,
      currentStep: OnboardingStep.habitConfiguration,
    );
  }

  /// Select custom habits and go to configuration
  void selectCustomHabits(List<String> habitIds) async {
    // Save custom habit IDs to Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'customHabitIds': habitIds,
        }, SetOptions(merge: true));

        state = state.copyWith(
          selectedProgramId: 'custom',
          currentStep: OnboardingStep.habitConfiguration,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to save custom habits: $e');
    }
  }

  /// Complete habit configuration
  void completeHabitConfiguration(List<Habit> habits) {
    state = state.copyWith(
      configuredHabits: habits,
      currentStep: OnboardingStep.nameInput,
    );
  }

  /// Save user name
  void saveUserName(String name) {
    state = state.copyWith(
      userName: name,
      currentStep: OnboardingStep.notificationPermission,
    );
  }

  /// Complete notification permission (regardless of result)
  void completeNotificationPermission() {
    state = state.copyWith(currentStep: OnboardingStep.commitmentMessage);
  }

  /// Save commitment message and complete onboarding
  Future<void> saveCommitmentAndComplete(String message) async {
    state = state.copyWith(
      commitmentMessage: message,
      isLoading: true,
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Save all user data to Firestore
      final batch = FirebaseFirestore.instance.batch();

      // Update user profile
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      batch.set(userRef, {
        'name': state.userName,
        'commitmentMessage': message,
        'selectedProgramId': state.selectedProgramId,
        'questionnaireResponses': state.questionnaireResponses,
        'onboardingCompletedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Save habits
      if (state.configuredHabits != null) {
        for (final habit in state.configuredHabits!) {
          final habitRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('habits')
              .doc(habit.id);
          batch.set(habitRef, habit.toJson());
        }
      }

      await batch.commit();

      state = state.copyWith(
        currentStep: OnboardingStep.complete,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to complete onboarding: $e',
        isLoading: false,
      );
    }
  }

  /// Go back to previous step
  void goBack() {
    switch (state.currentStep) {
      case OnboardingStep.questionnaire:
        state = state.copyWith(currentStep: OnboardingStep.intro);
        break;
      case OnboardingStep.programRecommendation:
        state = state.copyWith(currentStep: OnboardingStep.questionnaire);
        break;
      case OnboardingStep.browsePrograms:
      case OnboardingStep.customProgram:
        state = state.copyWith(currentStep: OnboardingStep.programRecommendation);
        break;
      case OnboardingStep.habitConfiguration:
        if (state.selectedProgramId == 'custom') {
          state = state.copyWith(currentStep: OnboardingStep.customProgram);
        } else {
          state = state.copyWith(currentStep: OnboardingStep.programRecommendation);
        }
        break;
      case OnboardingStep.nameInput:
        state = state.copyWith(currentStep: OnboardingStep.habitConfiguration);
        break;
      case OnboardingStep.notificationPermission:
        state = state.copyWith(currentStep: OnboardingStep.nameInput);
        break;
      case OnboardingStep.commitmentMessage:
        state = state.copyWith(currentStep: OnboardingStep.notificationPermission);
        break;
      default:
        break;
    }
  }

  /// Reset to initial state
  void reset() {
    state = const OnboardingState();
  }
}

/// Provider for onboarding state machine
final onboardingStateMachineProvider =
    NotifierProvider<OnboardingStateMachine, OnboardingState>(
        OnboardingStateMachine.new);
