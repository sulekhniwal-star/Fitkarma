import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Domain Models (§P1-G)
// ──────────────────────────────────────────────────────────────────────────────

class ProgramBlueprint {
  const ProgramBlueprint({
    required this.id,
    required this.name,
    required this.description,
    required this.targetUser,
    required this.evolvesTo,
    required this.evolvesToLabel,
  });

  final String id;
  final String name;
  final String description;
  final String targetUser;
  final String evolvesTo;
  final String evolvesToLabel;

  static const corporateFatLoss = ProgramBlueprint(
    id: 'corporate_fat_loss',
    name: 'Corporate Fat Loss',
    description:
        'Recommended based on desk-heavy style and goals. Focuses on low-barrier habits, post-meal walks, and desk-friendly movement.',
    targetUser: 'Office workers, high stress',
    evolvesTo: 'corporate_recomposition',
    evolvesToLabel: 'Corporate Recomp',
  );

  static const vegetarianMuscleGain = ProgramBlueprint(
    id: 'veg_muscle_gain',
    name: 'Indian Vegetarian Muscle Gain',
    description:
        'Designed for building lean muscle on a traditional lacto-vegetarian diet with high-protein swaps.',
    targetUser: 'Vegetarian users building muscle',
    evolvesTo: 'athletic_lean_build',
    evolvesToLabel: 'Athletic Lean Build',
  );

  static const pcosFatLoss = ProgramBlueprint(
    id: 'pcos_fat_loss',
    name: 'PCOS Fat Loss',
    description:
        'Supports insulin sensitivity and hormonal balance via strength workouts and blood-sugar stable meal pairings.',
    targetUser: 'Women with PCOS',
    evolvesTo: 'pcos_maintenance',
    evolvesToLabel: 'PCOS Maintenance',
  );

  static const weddingTransformation = ProgramBlueprint(
    id: 'wedding_transformation',
    name: 'Wedding Transformation',
    description:
        'A focused, high-adherence timeline program designed for rapid, sustainable body composition changes.',
    targetUser: '8–16 week wedding goal',
    evolvesTo: 'post_wedding_maintenance',
    evolvesToLabel: 'Post-Wedding Maintenance',
  );

  static const seniorStrength = ProgramBlueprint(
    id: 'senior_strength',
    name: 'Senior Strength & Balance',
    description:
        'Prioritizes joint health, functional balance, mobility, and progressive muscle retention.',
    targetUser: 'Users aged 50+',
    evolvesTo: 'active_aging',
    evolvesToLabel: 'Active Aging',
  );

  static const athleticPerformance = ProgramBlueprint(
    id: 'athletic_performance',
    name: 'Athletic Performance',
    description:
        'For active individuals aiming to optimize power, endurance, and overall work capacity.',
    targetUser: 'Already active users',
    evolvesTo: 'elite_athletic',
    evolvesToLabel: 'Elite Athletic',
  );

  static const diabetesSupport = ProgramBlueprint(
    id: 'diabetes_support',
    name: 'Diabetes Reversal Support',
    description:
        'A specialized routine matching glycemic guidelines to support stable blood sugars post-exercise.',
    targetUser: 'High glucose management',
    evolvesTo: 'metabolic_optimization',
    evolvesToLabel: 'Metabolic Optimization',
  );

  static const heartGuardian = ProgramBlueprint(
    id: 'heart_guardian',
    name: 'Heart Health Guardian',
    description:
        'Prioritizes low-intensity cardiovascular pacing, stress reduction, and blood pressure control.',
    targetUser: 'BP / cardiac risk management',
    evolvesTo: 'heart_maintenance',
    evolvesToLabel: 'Heart Maintenance',
  );

  static const all = [
    corporateFatLoss,
    vegetarianMuscleGain,
    pcosFatLoss,
    weddingTransformation,
    seniorStrength,
    athleticPerformance,
    diabetesSupport,
    heartGuardian,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// Recommendation Engine (Pure Dart - Deterministic)
// ──────────────────────────────────────────────────────────────────────────────

class ProgramSelectRecommendationEngine {
  const ProgramSelectRecommendationEngine();

  ProgramBlueprint recommend({
    required int age,
    required double heightCm,
    required double weightKg,
    required List<String> goals,
    required String? doshaDominant,
  }) {
    // 1. Goal checks (Priority 1)
    if (goals.contains('pcos_management')) {
      return ProgramBlueprint.pcosFatLoss;
    }
    if (goals.contains('diabetes_control')) {
      return ProgramBlueprint.diabetesSupport;
    }
    if (goals.contains('heart_health')) {
      return ProgramBlueprint.heartGuardian;
    }

    // 2. Age checks (Priority 2)
    if (age >= 50) {
      return ProgramBlueprint.seniorStrength;
    }

    // 3. BMI check
    final heightMeters = heightCm / 100.0;
    final bmi = heightMeters > 0
        ? weightKg / (heightMeters * heightMeters)
        : 22.0;

    if (bmi >= 25.0) {
      // High BMI default
      return ProgramBlueprint.corporateFatLoss;
    }

    // 4. Fallback default
    return ProgramBlueprint.athleticPerformance;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// State
// ──────────────────────────────────────────────────────────────────────────────

class ProgramSelectState {
  const ProgramSelectState({
    this.recommendedProgram,
    this.selectedProgram,
    this.isSaving = false,
    this.isLoading = false,
  });

  final ProgramBlueprint? recommendedProgram;
  final ProgramBlueprint? selectedProgram;
  final bool isSaving;
  final bool isLoading;

  ProgramSelectState copyWith({
    ProgramBlueprint? recommendedProgram,
    ProgramBlueprint? selectedProgram,
    bool? isSaving,
    bool? isLoading,
  }) {
    return ProgramSelectState(
      recommendedProgram: recommendedProgram ?? this.recommendedProgram,
      selectedProgram: selectedProgram ?? this.selectedProgram,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingProgramSelectNotifier extends Notifier<ProgramSelectState> {
  @override
  ProgramSelectState build() => const ProgramSelectState();

  Future<void> loadRecommendation(AppDatabase db, String userId) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await (db.select(
        db.users,
      )..where((t) => t.id.equals(userId))).getSingleOrNull();
      if (user != null) {
        final age = user.age ?? 30;
        final height = user.height ?? 170.0;
        final weight = user.weight ?? 70.0;

        List<String> goals = [];
        if (user.goals != null && user.goals!.isNotEmpty) {
          try {
            goals = List<String>.from(jsonDecode(user.goals!) as List);
          } catch (_) {
            goals = [];
          }
        }

        String? dominantDosha;
        if (user.dosha != null && user.dosha!.isNotEmpty) {
          try {
            final doshaMap = jsonDecode(user.dosha!) as Map<String, dynamic>;
            dominantDosha = doshaMap['dominant'] as String?;
          } catch (_) {}
        }

        const engine = ProgramSelectRecommendationEngine();
        final recommended = engine.recommend(
          age: age,
          heightCm: height,
          weightKg: weight,
          goals: goals,
          doshaDominant: dominantDosha,
        );

        state = state.copyWith(
          recommendedProgram: recommended,
          selectedProgram: recommended,
          isLoading: false,
        );
      } else {
        // Mock fallback if user row doesn't exist yet
        state = state.copyWith(
          recommendedProgram: ProgramBlueprint.corporateFatLoss,
          selectedProgram: ProgramBlueprint.corporateFatLoss,
          isLoading: false,
        );
      }
    } catch (_) {
      state = state.copyWith(
        recommendedProgram: ProgramBlueprint.corporateFatLoss,
        selectedProgram: ProgramBlueprint.corporateFatLoss,
        isLoading: false,
      );
    }
  }

  void selectProgram(ProgramBlueprint program) {
    state = state.copyWith(selectedProgram: program);
  }

  Future<void> saveToDb(AppDatabase db, String userId) async {
    if (state.selectedProgram == null) return;

    state = state.copyWith(isSaving: true);
    await db.updateUserProfile(
      userId: userId,
      currentProgram: state.selectedProgram!.id,
    );
    state = state.copyWith(isSaving: false);
  }
}

final onboardingProgramSelectProvider =
    NotifierProvider<OnboardingProgramSelectNotifier, ProgramSelectState>(
      OnboardingProgramSelectNotifier.new,
    );
