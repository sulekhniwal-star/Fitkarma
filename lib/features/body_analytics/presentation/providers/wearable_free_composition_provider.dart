import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/body_analytics_models.dart';
import '../../domain/wearable_free_composition_engine.dart';
import '../../domain/wearable_free_composition_models.dart';

final wearableFreeCompositionProvider = StateNotifierProvider<
    WearableFreeCompositionNotifier, WearableFreeCompositionReport>((ref) {
  return WearableFreeCompositionNotifier();
});

class WearableFreeCompositionNotifier
    extends StateNotifier<WearableFreeCompositionReport> {
  WearableFreeCompositionNotifier() : super(_buildInitialReport());

  static final WearableFreeCompositionEngine _engine =
      const WearableFreeCompositionEngine();

  static WearableFreeCompositionReport _buildInitialReport() {
    return _engine.computeWearableFreeComposition(
      weightKg: 74.5,
      heightCm: 178.0,
      age: 32,
      sex: AnthropometricSex.male,
      waistCm: 81.0,
      neckCm: 38.0,
      hipsCm: 96.0,
      applySouthAsianCalibrations: true,
    );
  }

  void recalculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required AnthropometricSex sex,
    required double waistCm,
    required double neckCm,
    double? hipsCm,
    bool applySouthAsianCalibrations = true,
  }) {
    state = _engine.computeWearableFreeComposition(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      waistCm: waistCm,
      neckCm: neckCm,
      hipsCm: hipsCm,
      applySouthAsianCalibrations: applySouthAsianCalibrations,
      executionTime: DateTime.now(),
    );
  }
}
