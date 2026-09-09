import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/wedding_mode_engine.dart';
import '../../domain/wedding_mode_models.dart';

final weddingModeProvider =
    StateNotifierProvider<WeddingModeNotifier, WeddingTransformationReport>((ref) {
  return WeddingModeNotifier();
});

class WeddingModeNotifier extends StateNotifier<WeddingTransformationReport> {
  WeddingModeNotifier() : super(_buildInitialPlan());

  static final WeddingModeEngine _engine = const WeddingModeEngine();

  static WeddingTransformationReport _buildInitialPlan() {
    final now = DateTime.now();
    return _engine.generateWeddingPlan(
      role: WeddingRole.bride,
      weddingDate: now.add(const Duration(days: 45)), // 6.5 weeks away (Definition phase)
      currentWeightKg: 62.0,
      targetWeightKg: 57.5,
      targetBodyFatPercent: 19.5,
      executionTime: now,
    );
  }

  void updateRole(WeddingRole newRole) {
    state = _engine.generateWeddingPlan(
      role: newRole,
      weddingDate: state.weddingDate,
      currentWeightKg: state.currentWeightKg,
      targetWeightKg: state.targetWeightKg,
      targetBodyFatPercent: state.targetBodyFatPercent,
      executionTime: DateTime.now(),
    );
  }

  void updateWeddingDate(DateTime date) {
    state = _engine.generateWeddingPlan(
      role: state.role,
      weddingDate: date,
      currentWeightKg: state.currentWeightKg,
      targetWeightKg: state.targetWeightKg,
      targetBodyFatPercent: state.targetBodyFatPercent,
      executionTime: DateTime.now(),
    );
  }
}
