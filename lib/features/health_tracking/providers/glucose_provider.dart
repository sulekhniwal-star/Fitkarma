import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/glucose_engine.dart';

// ── Glucose State ─────────────────────────────────────────────────────────────

class GlucoseState {
  final List<GlucoseRecord> records;
  final GlucoseRecord? latestFasting;
  final GlucoseRecord? latestPostMeal;
  final Hba1cEstimation hba1c;
  final String? spikeNudge;
  final bool isLocked;

  const GlucoseState({
    this.records = const [],
    this.latestFasting,
    this.latestPostMeal,
    required this.hba1c,
    this.spikeNudge,
    this.isLocked = true,
  });

  GlucoseState copyWith({
    List<GlucoseRecord>? records,
    GlucoseRecord? latestFasting,
    GlucoseRecord? latestPostMeal,
    Hba1cEstimation? hba1c,
    String? spikeNudge,
    bool? isLocked,
  }) {
    return GlucoseState(
      records: records ?? this.records,
      latestFasting: latestFasting ?? this.latestFasting,
      latestPostMeal: latestPostMeal ?? this.latestPostMeal,
      hba1c: hba1c ?? this.hba1c,
      spikeNudge: spikeNudge,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

// ── Glucose Provider / Notifier ───────────────────────────────────────────────

class GlucoseNotifier extends StateNotifier<GlucoseState> {
  final GlucoseEngine _engine;

  GlucoseNotifier(this._engine)
      : super(_buildInitialState(_engine));

  static GlucoseState _buildInitialState(GlucoseEngine engine) {
    final now = DateTime.now();
    final sampleRecords = [
      GlucoseRecord(
        id: 1,
        mgDl: 94,
        tag: GlucoseContextTag.fasting,
        measuredAt: now.subtract(const Duration(hours: 12)),
      ),
      GlucoseRecord(
        id: 2,
        mgDl: 142,
        tag: GlucoseContextTag.postMeal1h,
        measuredAt: now.subtract(const Duration(hours: 5)),
        correlatedMealName: 'Breakfast (Poha & Chai)',
      ),
      GlucoseRecord(
        id: 3,
        mgDl: 118,
        tag: GlucoseContextTag.postMeal2h,
        measuredAt: now.subtract(const Duration(hours: 3)),
        correlatedMealName: 'Lunch (Roti & Dal)',
      ),
      GlucoseRecord(
        id: 4,
        mgDl: 98,
        tag: GlucoseContextTag.fasting,
        measuredAt: now.subtract(const Duration(hours: 1)),
      ),
    ];

    final latestFasting = sampleRecords.lastWhere(
      (r) => r.tag == GlucoseContextTag.fasting,
      orElse: () => sampleRecords.first,
    );

    final latestPostMeal = sampleRecords.lastWhere(
      (r) => r.tag == GlucoseContextTag.postMeal1h || r.tag == GlucoseContextTag.postMeal2h,
      orElse: () => sampleRecords.first,
    );

    final hba1c = engine.calculateEstimatedHba1c(
      records: sampleRecords,
      totalLoggedDays: 92, // Simulated >=90 days
    );

    final nudge = engine.detectMealSpikeNudge(sampleRecords);

    return GlucoseState(
      records: sampleRecords,
      latestFasting: latestFasting,
      latestPostMeal: latestPostMeal,
      hba1c: hba1c,
      spikeNudge: nudge,
      isLocked: true,
    );
  }

  void unlockScreen() {
    state = state.copyWith(isLocked: false);
  }

  void lockScreen() {
    state = state.copyWith(isLocked: true);
  }

  void logGlucoseReading({
    required double mgDl,
    required GlucoseContextTag tag,
    String? correlatedMealName,
    String? notes,
  }) {
    final record = GlucoseRecord(
      id: state.records.length + 1,
      mgDl: mgDl,
      tag: tag,
      measuredAt: DateTime.now(),
      correlatedMealName: correlatedMealName,
      notes: notes,
    );

    final updated = [...state.records, record];

    final latestFasting = tag == GlucoseContextTag.fasting ? record : state.latestFasting;
    final latestPostMeal = (tag == GlucoseContextTag.postMeal1h || tag == GlucoseContextTag.postMeal2h)
        ? record
        : state.latestPostMeal;

    final hba1c = _engine.calculateEstimatedHba1c(
      records: updated,
      totalLoggedDays: state.hba1c.totalLoggedDays + 1,
    );

    final nudge = _engine.detectMealSpikeNudge(updated);

    state = state.copyWith(
      records: updated,
      latestFasting: latestFasting,
      latestPostMeal: latestPostMeal,
      hba1c: hba1c,
      spikeNudge: nudge,
    );
  }
}

final glucoseProvider = StateNotifierProvider<GlucoseNotifier, GlucoseState>(
  (_) => GlucoseNotifier(const GlucoseEngine()),
);
