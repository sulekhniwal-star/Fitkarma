/// §P12-A Festival Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'festival_intelligence_engine.dart';
import 'festival_models.dart';

class FestivalIntelligenceNotifier
    extends Notifier<CrossModuleFestivalAdaptation> {
  late final FestivalIntelligenceEngine _engine;

  @override
  CrossModuleFestivalAdaptation build() {
    _engine = const FestivalIntelligenceEngine();
    return _engine.generateCrossModuleAdaptation(DateTime.now());
  }

  void checkDate(DateTime targetDate) {
    state = _engine.generateCrossModuleAdaptation(targetDate);
  }
}

final festivalIntelligenceProvider = NotifierProvider<
    FestivalIntelligenceNotifier, CrossModuleFestivalAdaptation>(
  FestivalIntelligenceNotifier.new,
);
