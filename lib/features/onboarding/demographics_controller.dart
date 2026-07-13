// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart' show Value;
import 'package:fitkarma/core/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Domain Enums (§P1-D)
// ──────────────────────────────────────────────────────────────────────────────

enum Gender { male, female }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive;

  String get label {
    return switch (this) {
      ActivityLevel.sedentary        => 'Sedentary',
      ActivityLevel.lightlyActive    => 'Lightly Active',
      ActivityLevel.moderatelyActive => 'Moderately Active',
      ActivityLevel.veryActive       => 'Very Active',
      ActivityLevel.extraActive      => 'Extra Active',
    };
  }

  String get labelHindi {
    return switch (this) {
      ActivityLevel.sedentary        => 'कम सक्रिय',
      ActivityLevel.lightlyActive    => 'थोड़ा सक्रिय',
      ActivityLevel.moderatelyActive => 'सामान्य सक्रिय',
      ActivityLevel.veryActive       => 'बहुत सक्रिय',
      ActivityLevel.extraActive      => 'अत्यधिक सक्रिय',
    };
  }

  /// Mifflin-St Jeor activity multiplier.
  double get multiplier {
    return switch (this) {
      ActivityLevel.sedentary        => 1.2,
      ActivityLevel.lightlyActive    => 1.375,
      ActivityLevel.moderatelyActive => 1.55,
      ActivityLevel.veryActive       => 1.725,
      ActivityLevel.extraActive      => 1.9,
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// BMI Domain (§P1-D)
// ──────────────────────────────────────────────────────────────────────────────

enum BmiCategory { underweight, normal, overweight, obese }

class BmiResult {
  final double score;
  final BmiCategory category;
  const BmiResult({required this.score, required this.category});

  String get displayName => score.toStringAsFixed(1);

  String get categoryLabel {
    return switch (category) {
      BmiCategory.underweight => 'Underweight',
      BmiCategory.normal      => 'Normal',
      BmiCategory.overweight  => 'Overweight',
      BmiCategory.obese       => 'Obese',
    };
  }

  /// Fraction for the BMI indicator bar (clamped 0–1, mapped over 10–40 range).
  double get barFraction => ((score - 10.0) / 30.0).clamp(0.0, 1.0);
}

// ──────────────────────────────────────────────────────────────────────────────
// State
// ──────────────────────────────────────────────────────────────────────────────

class DemographicsState {
  const DemographicsState({
    this.gender        = Gender.male,
    this.age           = 25,
    this.heightCm      = 170.0,
    this.weightKg      = 70.0,
    this.activityLevel = ActivityLevel.sedentary,
    this.isSaving      = false,
    this.unitIsMetric  = true,
  });

  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final bool isSaving;

  /// Toggle: metric (cm / kg) vs imperial (ft-in / lbs). Affects display only;
  /// internal storage always uses SI (cm, kg).
  final bool unitIsMetric;

  // ── Derived ─────────────────────────────────────────────────────────────────

  BmiResult get bmi {
    if (heightCm <= 0) return const BmiResult(score: 0, category: BmiCategory.normal);
    final hM = heightCm / 100.0;
    final score = weightKg / (hM * hM);
    final BmiCategory cat;
    if (score < 18.5) {
      cat = BmiCategory.underweight;
    } else if (score < 25.0) {
      cat = BmiCategory.normal;
    } else if (score < 30.0) {
      cat = BmiCategory.overweight;
    } else {
      cat = BmiCategory.obese;
    }
    return BmiResult(score: score, category: cat);
  }

  /// Mifflin-St Jeor BMR → TDEE (kcal/day). Never an AI call.
  int get tdee {
    double bmr;
    if (gender == Gender.male) {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
    return (bmr * activityLevel.multiplier).round();
  }

  /// Daily calorie target from BMI category (§P1-D table).
  int get dailyCalorieTarget {
    return switch (bmi.category) {
      BmiCategory.underweight => tdee + 300,
      BmiCategory.normal      => tdee,
      BmiCategory.overweight  => (tdee - 300).clamp(1200, 9999),
      BmiCategory.obese       => (tdee - 500).clamp(1200, 9999),
    };
  }

  // ── Display helpers ─────────────────────────────────────────────────────────

  String get heightDisplay {
    if (unitIsMetric) {
      return '${heightCm.round()} cm';
    }
    // Convert to ft + in
    final totalInches = (heightCm / 2.54).round();
    final ft = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "${ft}' ${inches}\"";
  }

  String get weightDisplay {
    if (unitIsMetric) return '${weightKg.toStringAsFixed(1)} kg';
    return '${(weightKg * 2.20462).toStringAsFixed(1)} lbs';
  }

  DemographicsState copyWith({
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    bool? isSaving,
    bool? unitIsMetric,
  }) {
    return DemographicsState(
      gender:        gender        ?? this.gender,
      age:           age           ?? this.age,
      heightCm:      heightCm      ?? this.heightCm,
      weightKg:      weightKg      ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      isSaving:      isSaving      ?? this.isSaving,
      unitIsMetric:  unitIsMetric  ?? this.unitIsMetric,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class DemographicsNotifier extends Notifier<DemographicsState> {
  @override
  DemographicsState build() => const DemographicsState();

  void setGender(Gender gender) => state = state.copyWith(gender: gender);
  void setAge(int age)          => state = state.copyWith(age: age.clamp(13, 100));
  void setHeight(double cm)     => state = state.copyWith(heightCm: cm.clamp(100.0, 250.0));
  void setWeight(double kg)     => state = state.copyWith(weightKg: kg.clamp(20.0, 250.0));
  void setActivity(ActivityLevel level) => state = state.copyWith(activityLevel: level);
  void toggleUnit() => state = state.copyWith(unitIsMetric: !state.unitIsMetric);

  /// Validates all required fields. Returns an error string or null if valid.
  String? validate() {
    if (state.age < 13 || state.age > 100) return 'Please enter a valid age (13–100).';
    if (state.heightCm < 100 || state.heightCm > 250) return 'Please enter a valid height (100–250 cm).';
    if (state.weightKg < 20 || state.weightKg > 250) return 'Please enter a valid weight (20–250 kg).';
    return null;
  }

  /// Persists demographics + computed targets to the `users` table in Drift.
  Future<void> saveToDb(AppDatabase db, String userId) async {
    state = state.copyWith(isSaving: true);
    await db.updateUserDemographics(
      userId:             userId,
      age:                state.age,
      gender:             state.gender.name,
      heightCm:           state.heightCm,
      weightKg:           state.weightKg,
      activityLevel:      state.activityLevel.name,
      dailyCalorieTarget: state.dailyCalorieTarget,
    );
    state = state.copyWith(isSaving: false);
  }
}

/// Provider for the Demographics Screen state machine.
final demographicsProvider =
    NotifierProvider<DemographicsNotifier, DemographicsState>(
  DemographicsNotifier.new,
);
