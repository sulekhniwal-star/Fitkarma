import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/festival_intelligence_engine.dart';
import '../../domain/festival_intelligence_models.dart';

final festivalIntelligenceProvider =
    StateNotifierProvider<FestivalIntelligenceNotifier, FestivalIntelligencePlan>((ref) {
  return FestivalIntelligenceNotifier();
});

class FestivalIntelligenceNotifier extends StateNotifier<FestivalIntelligencePlan> {
  FestivalIntelligenceNotifier() : super(_buildInitialPlan());

  static final FestivalIntelligenceEngine _engine = const FestivalIntelligenceEngine();

  static FestivalIntelligencePlan _buildInitialPlan() {
    return _engine.generateFestivalPlan(
      festival: IndianFestival.diwali,
      isFestivalModeActive: true,
      daysUntilFestival: 3,
    );
  }

  void selectFestival(IndianFestival festival) {
    state = _engine.generateFestivalPlan(
      festival: festival,
      isFestivalModeActive: state.isFestivalModeActive,
      daysUntilFestival: state.daysUntilFestival,
      executionTime: DateTime.now(),
    );
  }

  void toggleFestivalMode(bool isActive) {
    state = _engine.generateFestivalPlan(
      festival: state.activeFestival,
      isFestivalModeActive: isActive,
      daysUntilFestival: state.daysUntilFestival,
      executionTime: DateTime.now(),
    );
  }
}
