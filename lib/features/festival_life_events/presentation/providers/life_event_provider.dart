import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/life_event_engine.dart';
import '../../domain/life_event_models.dart';

final lifeEventProvider =
    StateNotifierProvider<LifeEventNotifier, LifeEventAdaptiveReport>((ref) {
  return LifeEventNotifier();
});

class LifeEventNotifier extends StateNotifier<LifeEventAdaptiveReport> {
  LifeEventNotifier() : super(_buildInitialReport());

  static final LifeEventEngine _engine = const LifeEventEngine();

  static LifeEventAdaptiveReport _buildInitialReport() {
    return _engine.generateAdaptivePlan(
      event: LifeEventCategory.examCrunch,
      daysElapsed: 4,
    );
  }

  void selectLifeEvent(LifeEventCategory event) {
    state = _engine.generateAdaptivePlan(
      event: event,
      daysElapsed: state.daysElapsedInEvent,
      executionTime: DateTime.now(),
    );
  }

  void updateDaysElapsed(int days) {
    state = _engine.generateAdaptivePlan(
      event: state.activeEvent,
      daysElapsed: days,
      executionTime: DateTime.now(),
    );
  }
}
