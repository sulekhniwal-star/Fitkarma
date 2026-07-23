/// §P6-F Adaptive Computer Vision Loop — Thermal Frame Processor
///
/// Polls device thermal headroom via native MethodChannel and applies
/// adaptive frame-drop logic to keep MediaPipe inference within thermal budget.
///
/// Direct implementation of §P6-F Section 3 specification.
library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Thermal Workload State
// ─────────────────────────────────────────────────────────────────────────────

/// Thermal pipeline mode (§P6-F Thermal-Aware Downsampling Matrix).
enum ThermalWorkloadState {
  /// H < 0.75 — 30 fps, 33-joint full tracking.
  normal,

  /// 0.75 ≤ H < 0.85 — 15 fps (skip 1:2), 33 joints, reduced UI particles.
  moderate,

  /// 0.85 ≤ H < 0.95 — 10 fps (skip 1:3), core 11 joints only.
  severe,

  /// H ≥ 0.95 — 5 fps (skip 1:6), squat/press depth isolation only.
  critical,
}

extension ThermalWorkloadStateX on ThermalWorkloadState {
  /// Target frame rate for each thermal tier.
  int get targetFps {
    switch (this) {
      case ThermalWorkloadState.normal:   return 30;
      case ThermalWorkloadState.moderate: return 15;
      case ThermalWorkloadState.severe:   return 10;
      case ThermalWorkloadState.critical: return 5;
    }
  }

  /// Human-readable badge text shown in the FormFeedbackOverlay.
  String? get optimizationBadge {
    switch (this) {
      case ThermalWorkloadState.normal:
        return null;
      case ThermalWorkloadState.moderate:
        return '⚡ Optimization Mode Active: Device is warm. Reduced UI effects.';
      case ThermalWorkloadState.severe:
        return '⚡ Optimization Mode Active: High temperature. Core skeletal tracking only.';
      case ThermalWorkloadState.critical:
        return '⚡ Optimization Mode Active: Device temperature is high. Shifting to core skeletal metrics to protect battery stability and continue tracking your set.';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ThermalFrameProcessor
// ─────────────────────────────────────────────────────────────────────────────

class ThermalFrameProcessor extends Notifier<ThermalWorkloadState> {
  @override
  ThermalWorkloadState build() {
    _startThermalMonitoring();
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
    return ThermalWorkloadState.normal;
  }

  static const _thermalChannel = MethodChannel('fitkarma.healthos/thermal');

  Timer? _pollingTimer;
  int _frameCount = 0;

  void _startThermalMonitoring() {
    // Poll native thermal manager every 10 seconds to minimize API overhead
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final dynamic result =
            await _thermalChannel.invokeMethod<double>('getThermalHeadroom');
        final double headroom =
            (result is double) ? result : (result as num?)?.toDouble() ?? 0.0;
        _evaluateHeadroom(headroom);
      } catch (_) {
        // Graceful fallback — stay at normal if channel unavailable
        state = ThermalWorkloadState.normal;
      }
    });
  }

  /// Maps thermal headroom value to the appropriate workload state.
  void evaluateHeadroom(double headroom) => _evaluateHeadroom(headroom);

  void _evaluateHeadroom(double headroom) {
    if (headroom >= 0.95) {
      state = ThermalWorkloadState.critical;
    } else if (headroom >= 0.85) {
      state = ThermalWorkloadState.severe;
    } else if (headroom >= 0.75) {
      state = ThermalWorkloadState.moderate;
    } else {
      state = ThermalWorkloadState.normal;
    }
  }

  /// Returns true if the current camera frame should be sent to MediaPipe.
  ///
  /// Skip ratios (§P6-F spec):
  /// - Normal:   process every frame (1:1)
  /// - Moderate: process every 2nd frame (1:2 → 15 fps)
  /// - Severe:   process every 3rd frame (1:3 → 10 fps)
  /// - Critical: process every 6th frame (1:6 → 5 fps)
  bool shouldProcessNextFrame() {
    _frameCount++;
    switch (state) {
      case ThermalWorkloadState.normal:
        return true;
      case ThermalWorkloadState.moderate:
        return _frameCount % 2 == 0;
      case ThermalWorkloadState.severe:
        return _frameCount % 3 == 0;
      case ThermalWorkloadState.critical:
        return _frameCount % 6 == 0;
    }
  }

  /// Resets frame counter (useful for test isolation).
  void resetFrameCount() => _frameCount = 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Riverpod Provider
// ─────────────────────────────────────────────────────────────────────────────

final thermalProcessorProvider =
    NotifierProvider<ThermalFrameProcessor, ThermalWorkloadState>(
  ThermalFrameProcessor.new,
);
