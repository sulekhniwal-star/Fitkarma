import 'dart:convert';

import 'package:fitkarma/core/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Goal catalogue (static, matches the doc wireframe exactly)
// ──────────────────────────────────────────────────────────────────────────────

class GoalOption {
  const GoalOption({
    required this.id,
    required this.label,
    required this.labelHindi,
    required this.icon,
  });

  final String id;
  final String label;
  final String labelHindi;
  final String icon; // emoji used in the chip

  static const all = [
    GoalOption(
      id: 'weight_loss',
      label: 'Weight Loss',
      labelHindi: 'वजन घटाना',
      icon: '⚖️',
    ),
    GoalOption(
      id: 'muscle_gain',
      label: 'Muscle Gain',
      labelHindi: 'मसल्स बनाना',
      icon: '💪',
    ),
    GoalOption(
      id: 'pcos_management',
      label: 'PCOS Management',
      labelHindi: 'PCOS नियंत्रण',
      icon: '🌸',
    ),
    GoalOption(
      id: 'heart_health',
      label: 'Heart Health',
      labelHindi: 'हृदय स्वास्थ्य',
      icon: '❤️',
    ),
    GoalOption(
      id: 'diabetes_control',
      label: 'Diabetes Control',
      labelHindi: 'मधुमेह नियंत्रण',
      icon: '🩺',
    ),
    GoalOption(
      id: 'general_fitness',
      label: 'General Fitness',
      labelHindi: 'सामान्य फिटनेस',
      icon: '🏃',
    ),
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// State
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingGoalsState {
  const OnboardingGoalsState({
    this.selectedGoals = const [],
    this.targetWeight,
    this.isSaving = false,
  });

  final List<String> selectedGoals;
  final double? targetWeight;
  final bool isSaving;

  /// Whether the target-weight slider should be shown.
  bool get showTargetWeightSlider =>
      selectedGoals.contains('weight_loss') ||
      selectedGoals.contains('muscle_gain');

  OnboardingGoalsState copyWith({
    List<String>? selectedGoals,
    double? targetWeight,
    bool? isSaving,
  }) {
    return OnboardingGoalsState(
      selectedGoals: selectedGoals ?? this.selectedGoals,
      targetWeight: targetWeight ?? this.targetWeight,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingGoalsNotifier extends Notifier<OnboardingGoalsState> {
  static const int maxGoals = 3;

  @override
  OnboardingGoalsState build() => const OnboardingGoalsState();

  /// Toggle a goal on or off.
  /// Returns `true` if toggled; returns `false` if the max limit was hit.
  bool toggleGoal(String goalId) {
    final current = state.selectedGoals;
    if (current.contains(goalId)) {
      state = state.copyWith(
        selectedGoals: current.where((id) => id != goalId).toList(),
      );
      return true;
    } else if (current.length < maxGoals) {
      state = state.copyWith(selectedGoals: [...current, goalId]);
      return true;
    }
    // Limit reached — caller should trigger shake animation
    return false;
  }

  /// Update target weight from the slider.
  void updateTargetWeight(double weight) {
    state = state.copyWith(targetWeight: weight);
  }

  /// Seed the default target weight from the user's current weight.
  void seedDefaultTargetWeight(double currentWeight) {
    if (state.targetWeight != null) return; // already set
    if (state.selectedGoals.contains('weight_loss')) {
      state = state.copyWith(targetWeight: (currentWeight - 5).clamp(40, 150));
    } else if (state.selectedGoals.contains('muscle_gain')) {
      state = state.copyWith(targetWeight: (currentWeight + 5).clamp(40, 150));
    }
  }

  /// Persists the selected goals (JSON array) and targetWeight to Drift.
  Future<void> saveToDb(AppDatabase db, String userId) async {
    state = state.copyWith(isSaving: true);
    final goalsJson = jsonEncode(state.selectedGoals);
    await db.updateUserProfile(
      userId: userId,
      goalsJson: goalsJson,
      targetWeight: state.targetWeight,
    );
    state = state.copyWith(isSaving: false);
  }
}

/// Provider for Goals Screen state machine.
final onboardingGoalsProvider =
    NotifierProvider<OnboardingGoalsNotifier, OnboardingGoalsState>(
      OnboardingGoalsNotifier.new,
    );
