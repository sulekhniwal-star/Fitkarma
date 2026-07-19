import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

class GlucoseState {
  const GlucoseState({
    required this.fastingGlucose,
    required this.postMealGlucose,
    required this.estimatedHba1c,
    required this.isUnlocked,
    required this.pinInput,
    required this.isPinError,
    required this.history,
    required this.isLoading,
  });

  final double fastingGlucose;
  final double postMealGlucose;
  final double estimatedHba1c;
  final bool isUnlocked;
  final String pinInput;
  final bool isPinError;
  final List<GlucoseReading> history;
  final bool isLoading;

  GlucoseState copyWith({
    double? fastingGlucose,
    double? postMealGlucose,
    double? estimatedHba1c,
    bool? isUnlocked,
    String? pinInput,
    bool? isPinError,
    List<GlucoseReading>? history,
    bool? isLoading,
  }) {
    return GlucoseState(
      fastingGlucose: fastingGlucose ?? this.fastingGlucose,
      postMealGlucose: postMealGlucose ?? this.postMealGlucose,
      estimatedHba1c: estimatedHba1c ?? this.estimatedHba1c,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      pinInput: pinInput ?? this.pinInput,
      isPinError: isPinError ?? this.isPinError,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GlucoseNotifier extends Notifier<GlucoseState> {
  @override
  GlucoseState build() {
    Future.microtask(() => loadFromDb());
    return const GlucoseState(
      fastingGlucose: 98.0,
      postMealGlucose: 142.0,
      estimatedHba1c: 5.6,
      isUnlocked: false,
      pinInput: '',
      isPinError: false,
      history: [],
      isLoading: true,
    );
  }

  Future<void> loadFromDb() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);

      // Query Glucose readings sorted by measuredAt descending, id descending
      final readings = await (db.select(db.glucoseReadings)
            ..orderBy([
              (t) => drift.OrderingTerm(expression: t.measuredAt, mode: drift.OrderingMode.desc),
              (t) => drift.OrderingTerm(expression: t.id, mode: drift.OrderingMode.desc),
            ]))
          .get();

      // Latest Fasting
      final fastingRecord = readings.where((r) => r.mealTag == 'Fasting').toList();
      final latestFasting = fastingRecord.isNotEmpty ? fastingRecord.first.glucoseValue : 98.0;

      // Latest Post-Meal
      final postMealRecord = readings.where((r) => r.mealTag.contains('Post-Meal')).toList();
      final latestPostMeal = postMealRecord.isNotEmpty ? postMealRecord.first.glucoseValue : 142.0;

      // HbA1c estimation
      double hba1c = 5.6;
      if (readings.isNotEmpty) {
        double sum = 0.0;
        for (final r in readings) {
          sum += r.glucoseValue;
        }
        final double avg = sum / readings.length;
        final rawHba1c = (avg + 46.7) / 28.7;
        hba1c = double.parse(rawHba1c.toStringAsFixed(1));
      }

      state = state.copyWith(
        fastingGlucose: latestFasting,
        postMealGlucose: latestPostMeal,
        estimatedHba1c: hba1c,
        history: readings,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void enterPinDigit(String digit) {
    if (state.pinInput.length < 6) {
      final newInput = state.pinInput + digit;
      state = state.copyWith(pinInput: newInput, isPinError: false);

      if (newInput.length == 6) {
        if (newInput == '123456') {
          state = state.copyWith(isUnlocked: true, pinInput: '', isPinError: false);
        } else {
          state = state.copyWith(isPinError: true, pinInput: '');
        }
      }
    }
  }

  void clearPin() {
    state = state.copyWith(pinInput: '', isPinError: false);
  }

  void authenticateBiometrics(bool success) {
    if (success) {
      state = state.copyWith(isUnlocked: true, pinInput: '', isPinError: false);
    }
  }

  void resetLock() {
    state = state.copyWith(isUnlocked: false, pinInput: '', isPinError: false);
  }

  Future<void> addGlucoseReading(double value, String tag) async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      await db.into(db.glucoseReadings).insert(
        GlucoseReadingsCompanion.insert(
          glucoseValue: value,
          mealTag: tag,
          measuredAt: now,
        ),
      );

      await loadFromDb();
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final glucoseProvider = NotifierProvider<GlucoseNotifier, GlucoseState>(
  GlucoseNotifier.new,
);
