import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';

class BpState {
  const BpState({
    required this.latestSystolic,
    required this.latestDiastolic,
    required this.isUnlocked,
    required this.pinInput,
    required this.isPinError,
    required this.history,
    required this.showWarning,
    required this.isLoading,
  });

  final int latestSystolic;
  final int latestDiastolic;
  final bool isUnlocked;
  final String pinInput;
  final bool isPinError;
  final List<BpReading> history;
  final bool showWarning;
  final bool isLoading;

  BpState copyWith({
    int? latestSystolic,
    int? latestDiastolic,
    bool? isUnlocked,
    String? pinInput,
    bool? isPinError,
    List<BpReading>? history,
    bool? showWarning,
    bool? isLoading,
  }) {
    return BpState(
      latestSystolic: latestSystolic ?? this.latestSystolic,
      latestDiastolic: latestDiastolic ?? this.latestDiastolic,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      pinInput: pinInput ?? this.pinInput,
      isPinError: isPinError ?? this.isPinError,
      history: history ?? this.history,
      showWarning: showWarning ?? this.showWarning,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BpNotifier extends Notifier<BpState> {
  @override
  BpState build() {
    Future.microtask(() => loadFromDb());
    return const BpState(
      latestSystolic: 120,
      latestDiastolic: 80,
      isUnlocked: false,
      pinInput: '',
      isPinError: false,
      history: [],
      showWarning: false,
      isLoading: true,
    );
  }

  Future<void> loadFromDb() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);

      // Query BP readings sorted by measuredAt descending, id descending
      final readings =
          await (db.select(db.bpReadings)..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.measuredAt,
                  mode: drift.OrderingMode.desc,
                ),
                (t) => drift.OrderingTerm(
                  expression: t.id,
                  mode: drift.OrderingMode.desc,
                ),
              ]))
              .get();

      final latest = readings.isNotEmpty ? readings.first : null;

      // Check if last 3 consecutive readings are rising
      bool warning = false;
      if (readings.length >= 3) {
        final r1 = readings[2]; // oldest
        final r2 = readings[1]; // middle
        final r3 = readings[0]; // newest (latest)
        if ((r3.systolic > r2.systolic && r2.systolic > r1.systolic) ||
            (r3.diastolic > r2.diastolic && r2.diastolic > r1.diastolic)) {
          warning = true;
        }
      }

      state = state.copyWith(
        latestSystolic: latest?.systolic ?? 120,
        latestDiastolic: latest?.diastolic ?? 80,
        history: readings,
        showWarning: warning,
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
          state = state.copyWith(
            isUnlocked: true,
            pinInput: '',
            isPinError: false,
          );
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

  Future<void> addBpReading(int systolic, int diastolic, String method) async {
    state = state.copyWith(isLoading: true);
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      await db
          .into(db.bpReadings)
          .insert(
            BpReadingsCompanion.insert(
              systolic: systolic,
              diastolic: diastolic,
              measuredAt: now,
              recordingMethod: method,
            ),
          );

      await loadFromDb();
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final bpProvider = NotifierProvider<BpNotifier, BpState>(BpNotifier.new);
