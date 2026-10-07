import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../health_os/presentation/providers/dashboard_providers.dart';
import '../data/health_tracking_repository.dart';
import '../domain/models/health_models.dart';

enum GoogleHealthConnectionState {
  uninitialized,
  disconnected,
  authorizing,
  connected,
  syncing,
  error,
}

class GoogleHealthSyncState {
  final GoogleHealthConnectionState connectionState;
  final bool isAuthorized;
  final String? errorMessage;
  final DateTime? lastSyncTime;
  final int syncedSteps;
  final double? syncedHeartRate;
  final double? syncedSleepHours;

  const GoogleHealthSyncState({
    this.connectionState = GoogleHealthConnectionState.uninitialized,
    this.isAuthorized = false,
    this.errorMessage,
    this.lastSyncTime,
    this.syncedSteps = 0,
    this.syncedHeartRate,
    this.syncedSleepHours,
  });

  String get platformServiceName {
    if (!kIsWeb && Platform.isIOS) {
      return 'Apple Health';
    }
    return 'Google Health Connect';
  }

  GoogleHealthSyncState copyWith({
    GoogleHealthConnectionState? connectionState,
    bool? isAuthorized,
    String? errorMessage,
    DateTime? lastSyncTime,
    int? syncedSteps,
    double? syncedHeartRate,
    double? syncedSleepHours,
  }) {
    return GoogleHealthSyncState(
      connectionState: connectionState ?? this.connectionState,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      errorMessage: errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncedSteps: syncedSteps ?? this.syncedSteps,
      syncedHeartRate: syncedHeartRate ?? this.syncedHeartRate,
      syncedSleepHours: syncedSleepHours ?? this.syncedSleepHours,
    );
  }
}

class GoogleHealthSyncService extends Notifier<GoogleHealthSyncState> {
  final Health _health = Health();

  static const List<HealthDataType> _requestedTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_GLUCOSE,
  ];

  @override
  GoogleHealthSyncState build() {
    _init();
    return const GoogleHealthSyncState();
  }

  HealthTrackingRepository get _repository => ref.read(healthTrackingRepositoryProvider);

  Future<void> _init() async {
    try {
      if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
        state = state.copyWith(
          connectionState: GoogleHealthConnectionState.disconnected,
          errorMessage: 'Google Health is supported on mobile devices.',
        );
        return;
      }

      await _health.configure();
      final hasPerms = await _health.hasPermissions(_requestedTypes);

      state = state.copyWith(
        isAuthorized: hasPerms ?? false,
        connectionState: (hasPerms ?? false)
            ? GoogleHealthConnectionState.connected
            : GoogleHealthConnectionState.disconnected,
      );

      if (hasPerms == true) {
        final userId = ref.read(activeUserIdProvider);
        await syncData(userId: userId);
      }
    } catch (e) {
      debugPrint('GoogleHealthSyncService init error: $e');
      state = state.copyWith(
        connectionState: GoogleHealthConnectionState.disconnected,
      );
    }
  }

  /// Request authorization from Health Connect / Google Health
  Future<bool> requestAuthorization() async {
    state = state.copyWith(connectionState: GoogleHealthConnectionState.authorizing, errorMessage: null);

    try {
      if (Platform.isAndroid) {
        // Request activity recognition permission
        final activityStatus = await Permission.activityRecognition.request();
        if (activityStatus.isDenied || activityStatus.isPermanentlyDenied) {
          debugPrint('Activity recognition permission denied.');
        }
      }

      await _health.configure();
      final authorized = await _health.requestAuthorization(_requestedTypes);

      if (authorized) {
        state = state.copyWith(
          isAuthorized: true,
          connectionState: GoogleHealthConnectionState.connected,
          errorMessage: null,
        );

        final userId = ref.read(activeUserIdProvider);
        await syncData(userId: userId);
        return true;
      } else {
        state = state.copyWith(
          isAuthorized: false,
          connectionState: GoogleHealthConnectionState.disconnected,
          errorMessage: 'Permission not granted in Health Connect.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isAuthorized: false,
        connectionState: GoogleHealthConnectionState.error,
        errorMessage: 'Unable to connect to Google Health: ${e.toString().replaceAll("Exception: ", "")}',
      );
      return false;
    }
  }

  /// Sync all health metrics from Health Connect into local Drift database
  Future<void> syncData({required String userId}) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    state = state.copyWith(connectionState: GoogleHealthConnectionState.syncing);

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      // 1. Fetch Total Steps
      int totalSteps = 0;
      final stepCount = await _health.getTotalStepsInInterval(startOfDay, now);
      if (stepCount != null && stepCount > 0) {
        totalSteps = stepCount;
        await _repository.recordWearableSample(
          userId: userId,
          source: 'google_health',
          metric: 'steps',
          value: stepCount.toDouble(),
          unit: 'count',
          timestamp: now,
        );
      }

      // 2. Fetch Health Data Points for Heart Rate, Sleep, BP, Glucose
      final healthDataList = await _health.getHealthDataFromTypes(
        types: _requestedTypes,
        startTime: startOfDay.subtract(const Duration(days: 1)),
        endTime: now,
      );

      double? latestHr;
      double? sleepDurationHours;
      double? systolicBp;
      double? diastolicBp;

      for (final point in healthDataList) {
        final val = point.value;
        if (val is NumericHealthValue) {
          final numericVal = val.numericValue.toDouble();

          if (point.type == HealthDataType.HEART_RATE || point.type == HealthDataType.RESTING_HEART_RATE) {
            latestHr = numericVal;
            await _repository.recordWearableSample(
              userId: userId,
              source: 'google_health',
              metric: 'heart_rate',
              value: numericVal,
              unit: 'bpm',
              timestamp: point.dateTo,
            );
          } else if (point.type == HealthDataType.BLOOD_GLUCOSE) {
            await _repository.recordBiomarkerReading(
              userId: userId,
              source: 'google_health',
              type: BiomarkerType.fastingGlucose,
              primaryValue: numericVal,
              unit: 'mg/dL',
              measuredAt: point.dateTo,
            );
          } else if (point.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
            systolicBp = numericVal;
          } else if (point.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
            diastolicBp = numericVal;
          }
        }
      }

      if (systolicBp != null) {
        await _repository.recordBiomarkerReading(
          userId: userId,
          source: 'google_health',
          type: BiomarkerType.bloodPressure,
          primaryValue: systolicBp,
          secondaryValue: diastolicBp ?? 80,
          unit: 'mmHg',
          measuredAt: now,
        );
      }

      // Calculate total sleep from sleep data
      final sleepPoints = healthDataList.where((p) =>
          p.type == HealthDataType.SLEEP_SESSION || p.type == HealthDataType.SLEEP_ASLEEP);
      if (sleepPoints.isNotEmpty) {
        int totalSleepMinutes = 0;
        for (final sp in sleepPoints) {
          totalSleepMinutes += sp.dateTo.difference(sp.dateFrom).inMinutes;
        }
        if (totalSleepMinutes > 0) {
          sleepDurationHours = totalSleepMinutes / 60.0;
          await _repository.recordWearableSample(
            userId: userId,
            source: 'google_health',
            metric: 'sleep',
            value: sleepDurationHours,
            unit: 'hours',
            timestamp: now,
          );
        }
      }

      state = state.copyWith(
        connectionState: GoogleHealthConnectionState.connected,
        lastSyncTime: now,
        syncedSteps: totalSteps,
        syncedHeartRate: latestHr,
        syncedSleepHours: sleepDurationHours,
        errorMessage: null,
      );
    } catch (e) {
      debugPrint('Google Health sync error: $e');
      state = state.copyWith(
        connectionState: GoogleHealthConnectionState.connected,
        errorMessage: 'Sync error: $e',
      );
    }
  }
}

final googleHealthSyncServiceProvider =
    NotifierProvider<GoogleHealthSyncService, GoogleHealthSyncState>(GoogleHealthSyncService.new);
