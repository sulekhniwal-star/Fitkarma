import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThermalWorkloadState { normal, moderate, severe, critical }

class ThermalFrameProcessor extends StateNotifier<ThermalWorkloadState> {
  static const _thermalChannel = MethodChannel('fitkarma.healthos/thermal');
  Timer? _pollingTimer;
  int _frameCount = 0;
  double _currentHeadroom = 0.0;

  ThermalFrameProcessor() : super(ThermalWorkloadState.normal) {
    _startThermalMonitoring();
  }

  double get currentHeadroom => _currentHeadroom;

  void _startThermalMonitoring() {
    // Poll native thermal manager every 10 seconds to minimize API overhead
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await pollThermalHeadroom();
    });
  }

  Future<void> pollThermalHeadroom() async {
    try {
      final double headroom = await _thermalChannel.invokeMethod('getThermalHeadroom') ?? 0.0;
      _evaluateHeadroom(headroom);
    } catch (_) {
      state = ThermalWorkloadState.normal; // Graceful fallback
    }
  }

  void updateHeadroomDirectly(double headroom) {
    _evaluateHeadroom(headroom);
  }

  void _evaluateHeadroom(double headroom) {
    _currentHeadroom = headroom;
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

  /// Evaluates whether the current camera frame should be analyzed or discarded
  bool shouldProcessNextFrame() {
    _frameCount++;

    switch (state) {
      case ThermalWorkloadState.normal:
        return true; // Analyze 100% of incoming camera frames (30 fps target)
      case ThermalWorkloadState.moderate:
        return _frameCount % 2 == 0; // Skip every alternate frame (15 fps target)
      case ThermalWorkloadState.severe:
        return _frameCount % 3 == 0; // Skip 2 out of 3 frames (10 fps target)
      case ThermalWorkloadState.critical:
        return _frameCount % 6 == 0; // Drop to emergency trace metrics (5 fps target)
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

// Riverpod Provider Registration
final thermalProcessorProvider =
    StateNotifierProvider<ThermalFrameProcessor, ThermalWorkloadState>((ref) {
  return ThermalFrameProcessor();
});
