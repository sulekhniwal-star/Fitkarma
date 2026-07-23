/// §P5-I Micronutrient Controller
///
/// Riverpod Notifier managing daily micronutrient aggregation from logged foods,
/// RDA target calculations, deficiency risk alert evaluations, and Drift database persistence (`MicronutrientLogs`).
library;

import 'package:drift/drift.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/micronutrient_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class MicronutrientState {
  const MicronutrientState({
    this.isVegetarian = true,
    this.isFemale = true,
    this.hasPcos = false,
    this.summary = const DailyMicronutrientSummary(),
    this.rdaConfig = const MicroRdaConfig(
      ironMg: 32.4, // Female + Vegetarian (18 * 1.8)
      vitaminB12Mcg: 3.0,
      vitaminD3Iu: 800,
      calciumMg: 1200,
      magnesiumMg: 350,
      zincMg: 15,
      folateMcg: 600,
      omega3G: 2.0,
    ),
    this.activeAlerts = const [],
    this.overallCoveragePct = 0.0,
    this.isLoading = false,
  });

  final bool isVegetarian;
  final bool isFemale;
  final bool hasPcos;
  final DailyMicronutrientSummary summary;
  final MicroRdaConfig rdaConfig;
  final List<MicroAlert> activeAlerts;
  final double overallCoveragePct;
  final bool isLoading;

  MicronutrientState copyWith({
    bool? isVegetarian,
    bool? isFemale,
    bool? hasPcos,
    DailyMicronutrientSummary? summary,
    MicroRdaConfig? rdaConfig,
    List<MicroAlert>? activeAlerts,
    double? overallCoveragePct,
    bool? isLoading,
  }) {
    return MicronutrientState(
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isFemale: isFemale ?? this.isFemale,
      hasPcos: hasPcos ?? this.hasPcos,
      summary: summary ?? this.summary,
      rdaConfig: rdaConfig ?? this.rdaConfig,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      overallCoveragePct: overallCoveragePct ?? this.overallCoveragePct,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final micronutrientEngineProvider = Provider<MicronutrientEngine>((ref) {
  return const MicronutrientEngine();
});

class MicronutrientNotifier extends Notifier<MicronutrientState> {
  static const String _userId = 'local_user';

  @override
  MicronutrientState build() {
    final engine = ref.watch(micronutrientEngineProvider);
    final foodState = ref.watch(foodProvider);

    final rda = MicroRdaConfig.forUser(
      isFemale: true,
      isVegetarian: true,
      hasPcos: false,
    );

    final aggregated = _aggregateFoodItems(foodState.loggedItems, engine);
    final alerts = engine.evaluateDeficiencyRisk(
      recent7DayLogs: [aggregated],
      rdaTargets: rda,
      isVegetarian: true,
      isFemale: true,
      hasPcos: false,
    );

    final coverage = _calculateOverallCoverage(aggregated, rda);

    Future.microtask(() => _persistSummaryToDb(aggregated));

    return MicronutrientState(
      isVegetarian: true,
      isFemale: true,
      hasPcos: false,
      summary: aggregated,
      rdaConfig: rda,
      activeAlerts: alerts,
      overallCoveragePct: coverage,
    );
  }

  /// Updates user demographic profile flags and re-calculates RDA targets & alerts.
  void updateDemographics({bool? isVegetarian, bool? isFemale, bool? hasPcos}) {
    final veg = isVegetarian ?? state.isVegetarian;
    final fem = isFemale ?? state.isFemale;
    final pcos = hasPcos ?? state.hasPcos;

    final rda = MicroRdaConfig.forUser(
      isFemale: fem,
      isVegetarian: veg,
      hasPcos: pcos,
    );

    final engine = ref.read(micronutrientEngineProvider);
    final alerts = engine.evaluateDeficiencyRisk(
      recent7DayLogs: [state.summary],
      rdaTargets: rda,
      isVegetarian: veg,
      isFemale: fem,
      hasPcos: pcos,
    );

    final coverage = _calculateOverallCoverage(state.summary, rda);

    state = state.copyWith(
      isVegetarian: veg,
      isFemale: fem,
      hasPcos: pcos,
      rdaConfig: rda,
      activeAlerts: alerts,
      overallCoveragePct: coverage,
    );

    _persistSummaryToDb(state.summary);
  }

  /// Persists current daily summary to Drift `MicronutrientLogs` table.
  Future<void> _persistSummaryToDb(DailyMicronutrientSummary summary) async {
    try {
      final db = ref.read(databaseProvider);
      await db.saveMicronutrientLog(
        MicronutrientLogsCompanion(
          userId: const Value(_userId),
          logDate: Value(DateTime.now()),
          ironMg: Value(summary.ironMg),
          vitaminB12Mcg: Value(summary.vitaminB12Mcg),
          vitaminD3Iu: Value(summary.vitaminD3Iu),
          calciumMg: Value(summary.calciumMg),
          magnesiumMg: Value(summary.magnesiumMg),
          zincMg: Value(summary.zincMg),
          folateMcg: Value(summary.folateMcg),
          omega3G: Value(summary.omega3G),
        ),
      );
    } catch (_) {
      // Offline fallback
    }
  }

  DailyMicronutrientSummary _aggregateFoodItems(
    List<FoodItem> items,
    MicronutrientEngine engine,
  ) {
    DailyMicronutrientSummary total = const DailyMicronutrientSummary();
    for (final item in items) {
      final micro = engine.estimateMicrosForFood(item.name);
      total = total.add(micro);
    }
    return total;
  }

  double _calculateOverallCoverage(
    DailyMicronutrientSummary summary,
    MicroRdaConfig rda,
  ) {
    final ironPct = (summary.ironMg / (rda.ironMg > 0 ? rda.ironMg : 1)).clamp(
      0.0,
      1.0,
    );
    final b12Pct =
        (summary.vitaminB12Mcg /
                (rda.vitaminB12Mcg > 0 ? rda.vitaminB12Mcg : 1))
            .clamp(0.0, 1.0);
    final d3Pct =
        (summary.vitaminD3Iu / (rda.vitaminD3Iu > 0 ? rda.vitaminD3Iu : 1))
            .clamp(0.0, 1.0);
    final calciumPct =
        (summary.calciumMg / (rda.calciumMg > 0 ? rda.calciumMg : 1)).clamp(
          0.0,
          1.0,
        );
    final magPct =
        (summary.magnesiumMg / (rda.magnesiumMg > 0 ? rda.magnesiumMg : 1))
            .clamp(0.0, 1.0);
    final zincPct = (summary.zincMg / (rda.zincMg > 0 ? rda.zincMg : 1)).clamp(
      0.0,
      1.0,
    );
    final folatePct =
        (summary.folateMcg / (rda.folateMcg > 0 ? rda.folateMcg : 1)).clamp(
          0.0,
          1.0,
        );
    final omegaPct = (summary.omega3G / (rda.omega3G > 0 ? rda.omega3G : 1))
        .clamp(0.0, 1.0);

    final avg =
        (ironPct +
            b12Pct +
            d3Pct +
            calciumPct +
            magPct +
            zincPct +
            folatePct +
            omegaPct) /
        8.0;
    return double.parse((avg * 100).toStringAsFixed(1));
  }
}

final micronutrientProvider =
    NotifierProvider<MicronutrientNotifier, MicronutrientState>(
      MicronutrientNotifier.new,
    );
