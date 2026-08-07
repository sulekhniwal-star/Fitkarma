import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/blood_pressure_engine.dart';

// ── Security Access Lock State ────────────────────────────────────────────────

enum BiometricLockStatus {
  locked,         // Requires auth
  authenticating, // Local auth prompt open
  unlocked,       // Biometric/PIN verified
  failed,         // Biometric failed, PIN fallback ready
}

// ── Blood Pressure Screen State ───────────────────────────────────────────────

class BloodPressureState {
  final BiometricLockStatus lockStatus;
  final List<BloodPressureRecord> history;
  final BloodPressureRecord? latest;
  final String? warningMessage;
  final String pinInput;
  final bool pinError;

  const BloodPressureState({
    this.lockStatus = BiometricLockStatus.locked,
    this.history = const [],
    this.latest,
    this.warningMessage,
    this.pinInput = '',
    this.pinError = false,
  });

  BloodPressureState copyWith({
    BiometricLockStatus? lockStatus,
    List<BloodPressureRecord>? history,
    BloodPressureRecord? latest,
    String? warningMessage,
    String? pinInput,
    bool? pinError,
  }) {
    return BloodPressureState(
      lockStatus: lockStatus ?? this.lockStatus,
      history: history ?? this.history,
      latest: latest ?? this.latest,
      warningMessage: warningMessage,
      pinInput: pinInput ?? this.pinInput,
      pinError: pinError ?? this.pinError,
    );
  }
}

// ── Blood Pressure Provider / Notifier ────────────────────────────────────────

class BloodPressureNotifier extends StateNotifier<BloodPressureState> {
  final BloodPressureEngine _engine;
  static const String _defaultBackupPin = '123456'; // Default 6-digit security PIN

  BloodPressureNotifier(this._engine)
      : super(_buildInitialState(_engine));

  static BloodPressureState _buildInitialState(BloodPressureEngine engine) {
    final now = DateTime.now();
    final sampleHistory = [
      BloodPressureRecord(
        id: 1,
        systolic: 120,
        diastolic: 78,
        measuredAt: now.subtract(const Duration(days: 3)),
        recordingMethod: BpRecordingMethod.wearable,
      ),
      BloodPressureRecord(
        id: 2,
        systolic: 122,
        diastolic: 80,
        measuredAt: now.subtract(const Duration(days: 2)),
        recordingMethod: BpRecordingMethod.wearable,
      ),
      BloodPressureRecord(
        id: 3,
        systolic: 125,
        diastolic: 81,
        measuredAt: now.subtract(const Duration(days: 1)),
        recordingMethod: BpRecordingMethod.manual,
      ),
      BloodPressureRecord(
        id: 4,
        systolic: 128,
        diastolic: 82,
        measuredAt: now.subtract(const Duration(hours: 4)),
        recordingMethod: BpRecordingMethod.manual,
      ),
    ];

    final latest = sampleHistory.last;
    final warning = engine.generateBpWarning(sampleHistory);

    return BloodPressureState(
      lockStatus: BiometricLockStatus.locked,
      history: sampleHistory,
      latest: latest,
      warningMessage: warning,
    );
  }

  /// Simulate or execute local biometric authentication prompt
  Future<void> authenticateWithBiometrics({bool simulateSuccess = true}) async {
    state = state.copyWith(lockStatus: BiometricLockStatus.authenticating);

    if (simulateSuccess) {
      state = state.copyWith(lockStatus: BiometricLockStatus.unlocked);
    } else {
      state = state.copyWith(
        lockStatus: BiometricLockStatus.failed,
        pinInput: '',
        pinError: false,
      );
    }
  }

  /// Enter digit into PIN keypad
  void appendPinDigit(String digit) {
    if (state.pinInput.length >= 6) return;
    final updated = state.pinInput + digit;
    state = state.copyWith(pinInput: updated, pinError: false);

    if (updated.length == 6) {
      verifyPin(updated);
    }
  }

  /// Delete last digit from PIN keypad
  void deletePinDigit() {
    if (state.pinInput.isEmpty) return;
    final updated = state.pinInput.substring(0, state.pinInput.length - 1);
    state = state.copyWith(pinInput: updated, pinError: false);
  }

  /// Verify entered 6-digit backup PIN
  void verifyPin(String pin) {
    if (pin == _defaultBackupPin) {
      state = state.copyWith(
        lockStatus: BiometricLockStatus.unlocked,
        pinInput: '',
        pinError: false,
      );
    } else {
      state = state.copyWith(
        pinInput: '',
        pinError: true,
      );
    }
  }

  /// Add new manual or wearable reading
  void logBloodPressure({
    required int systolic,
    required int diastolic,
    BpRecordingMethod method = BpRecordingMethod.manual,
  }) {
    final record = BloodPressureRecord(
      id: state.history.length + 1,
      systolic: systolic,
      diastolic: diastolic,
      measuredAt: DateTime.now(),
      recordingMethod: method,
    );

    final updatedHistory = [...state.history, record];
    final warning = _engine.generateBpWarning(updatedHistory);

    state = state.copyWith(
      history: updatedHistory,
      latest: record,
      warningMessage: warning,
    );
  }

  /// Force lock screen (e.g. app backgrounded or logout)
  void lockScreen() {
    state = state.copyWith(
      lockStatus: BiometricLockStatus.locked,
      pinInput: '',
    );
  }
}

final bloodPressureProvider =
    StateNotifierProvider<BloodPressureNotifier, BloodPressureState>(
  (_) => BloodPressureNotifier(const BloodPressureEngine()),
);
