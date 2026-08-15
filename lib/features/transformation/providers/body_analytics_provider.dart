import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/body_composition_estimator.dart';

class BodyAnalyticsState {
  final double currentWeightKg;
  final double heightCm;
  final double waistCm;
  final double neckCm;
  final double? hipCm;
  final double bodyFatPct;
  final double leanMassKg;
  final double fatMassKg;
  final String categoryLabel;
  final String estimationMethod;
  final String confidence;
  final double bodyFatDelta3Months;
  final double leanMassDelta3Months;
  final bool isBiometricUnlocked;
  final bool isLoading;

  const BodyAnalyticsState({
    required this.currentWeightKg,
    required this.heightCm,
    required this.waistCm,
    required this.neckCm,
    this.hipCm,
    required this.bodyFatPct,
    required this.leanMassKg,
    required this.fatMassKg,
    required this.categoryLabel,
    required this.estimationMethod,
    required this.confidence,
    required this.bodyFatDelta3Months,
    required this.leanMassDelta3Months,
    this.isBiometricUnlocked = false,
    this.isLoading = false,
  });

  factory BodyAnalyticsState.initial() {
    const estimator = BodyCompositionEstimator();
    final result = estimator.estimate(
      heightCm: 175.0,
      weightKg: 78.0,
      waistCm: 86.5,
      neckCm: 38.0,
      gender: 'male',
      age: 28,
    );

    return BodyAnalyticsState(
      currentWeightKg: 78.0,
      heightCm: 175.0,
      waistCm: 86.5,
      neckCm: 38.0,
      hipCm: null,
      bodyFatPct: result.bodyFatPct,
      leanMassKg: result.leanMassKg,
      fatMassKg: result.fatMassKg,
      categoryLabel: result.bfCategory,
      estimationMethod: result.estimationMethod,
      confidence: result.confidence,
      bodyFatDelta3Months: -3.8,
      leanMassDelta3Months: 3.1,
      isBiometricUnlocked: false,
      isLoading: false,
    );
  }

  BodyAnalyticsState copyWith({
    double? currentWeightKg,
    double? heightCm,
    double? waistCm,
    double? neckCm,
    double? hipCm,
    double? bodyFatPct,
    double? leanMassKg,
    double? fatMassKg,
    String? categoryLabel,
    String? estimationMethod,
    String? confidence,
    double? bodyFatDelta3Months,
    double? leanMassDelta3Months,
    bool? isBiometricUnlocked,
    bool? isLoading,
  }) {
    return BodyAnalyticsState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
      neckCm: neckCm ?? this.neckCm,
      hipCm: hipCm ?? this.hipCm,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      leanMassKg: leanMassKg ?? this.leanMassKg,
      fatMassKg: fatMassKg ?? this.fatMassKg,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      estimationMethod: estimationMethod ?? this.estimationMethod,
      confidence: confidence ?? this.confidence,
      bodyFatDelta3Months: bodyFatDelta3Months ?? this.bodyFatDelta3Months,
      leanMassDelta3Months: leanMassDelta3Months ?? this.leanMassDelta3Months,
      isBiometricUnlocked: isBiometricUnlocked ?? this.isBiometricUnlocked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BodyAnalyticsNotifier extends StateNotifier<BodyAnalyticsState> {
  BodyAnalyticsNotifier() : super(BodyAnalyticsState.initial());

  void unlockBiometrics() {
    state = state.copyWith(isBiometricUnlocked: true);
  }

  void updateMeasurements({
    required double waistCm,
    required double neckCm,
    double? hipCm,
    required double weightKg,
    required String gender,
    required int age,
  }) {
    const estimator = BodyCompositionEstimator();
    final result = estimator.estimate(
      heightCm: state.heightCm,
      weightKg: weightKg,
      waistCm: waistCm,
      neckCm: neckCm,
      hipCm: hipCm,
      gender: gender,
      age: age,
    );

    state = state.copyWith(
      currentWeightKg: weightKg,
      waistCm: waistCm,
      neckCm: neckCm,
      hipCm: hipCm,
      bodyFatPct: result.bodyFatPct,
      leanMassKg: result.leanMassKg,
      fatMassKg: result.fatMassKg,
      categoryLabel: result.bfCategory,
      estimationMethod: result.estimationMethod,
      confidence: result.confidence,
    );
  }
}

final bodyAnalyticsProvider =
    StateNotifierProvider<BodyAnalyticsNotifier, BodyAnalyticsState>((ref) {
  return BodyAnalyticsNotifier();
});
