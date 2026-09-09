import 'package:flutter/foundation.dart';

/// Performance optimization pillars in FitKarma Health OS
enum PerformancePillar {
  frameBudget(
    name: '60/120 FPS Frame Budget',
    regionalName: '६०/१२० एफपीएस फ्रेम बजट',
    targetThreshold: '< 16.6 ms per frame',
  ),
  engineLatency(
    name: 'Deterministic Calculation Latency',
    regionalName: 'एल्गोरिदम निष्पादन गति',
    targetThreshold: '< 50 ms for complex synthesis',
  ),
  memoryFootprint(
    name: 'Memory & Leak Management',
    regionalName: 'मेमोरी व कैश प्रबंधन',
    targetThreshold: '< 120 MB active RAM',
  ),
  networkPayload(
    name: 'Offline Caching & Data Payloads',
    regionalName: 'ऑफलाइन कैश व नेटवर्क अनुकूलन',
    targetThreshold: '< 25 KB average payload',
  ),
  batteryEfficiency(
    name: 'Battery & Sensor Throttling',
    regionalName: 'बैटरी व सेंसर अनुकूलन',
    targetThreshold: '< 2% battery drain / hour',
  );

  final String name;
  final String regionalName;
  final String targetThreshold;

  const PerformancePillar({
    required this.name,
    required this.regionalName,
    required this.targetThreshold,
  });
}

/// Status of benchmark execution
enum PerformanceGrade {
  gradeA(name: 'A+ Elite (Sub-16ms)', regionalName: 'सर्वोत्तम गति (ए+)', score: 95),
  gradeB(name: 'B Smooth (16-33ms)', regionalName: 'संतोषजनक गति (बी)', score: 80),
  gradeC(name: 'C Needs Optimization', regionalName: 'सुधार योग्य गति (सी)', score: 60);

  final String name;
  final String regionalName;
  final int score;

  const PerformanceGrade({
    required this.name,
    required this.regionalName,
    required this.score,
  });
}

/// An individual engine execution benchmark
@immutable
class EngineBenchmarkResult {
  final String engineName;
  final String regionalEngineName;
  final int executionMicroseconds;
  final double executionMilliseconds;
  final int iterationsRun;
  final bool isWithinBudget;

  const EngineBenchmarkResult({
    required this.engineName,
    required this.regionalEngineName,
    required this.executionMicroseconds,
    required this.executionMilliseconds,
    required this.iterationsRun,
    required this.isWithinBudget,
  });
}

/// Performance configuration settings
@immutable
class PerformanceSettings {
  final int targetFps; // 60 or 120
  final bool enableRepaintBoundaries;
  final bool enableAggressiveLruCache;
  final int maxCacheSizeMb;
  final int telemetryBatchSize;
  final bool batterySaverMode;

  const PerformanceSettings({
    this.targetFps = 120,
    this.enableRepaintBoundaries = true,
    this.enableAggressiveLruCache = true,
    this.maxCacheSizeMb = 64,
    this.telemetryBatchSize = 100,
    this.batterySaverMode = false,
  });

  PerformanceSettings copyWith({
    int? targetFps,
    bool? enableRepaintBoundaries,
    bool? enableAggressiveLruCache,
    int? maxCacheSizeMb,
    int? telemetryBatchSize,
    bool? batterySaverMode,
  }) {
    return PerformanceSettings(
      targetFps: targetFps ?? this.targetFps,
      enableRepaintBoundaries: enableRepaintBoundaries ?? this.enableRepaintBoundaries,
      enableAggressiveLruCache: enableAggressiveLruCache ?? this.enableAggressiveLruCache,
      maxCacheSizeMb: maxCacheSizeMb ?? this.maxCacheSizeMb,
      telemetryBatchSize: telemetryBatchSize ?? this.telemetryBatchSize,
      batterySaverMode: batterySaverMode ?? this.batterySaverMode,
    );
  }
}

/// Comprehensive Performance & Profiling Audit Report
@immutable
class PerformanceAuditReport {
  final int overallPerformanceScore; // 0 to 100
  final PerformanceGrade performanceGrade;
  final double averageFps;
  final double currentMemoryUsageMb;
  final List<EngineBenchmarkResult> benchmarkResults;
  final PerformanceSettings settings;
  final List<String> optimizationTips;
  final List<String> regionalOptimizationTips;
  final DateTime auditedAt;

  const PerformanceAuditReport({
    required this.overallPerformanceScore,
    required this.performanceGrade,
    required this.averageFps,
    required this.currentMemoryUsageMb,
    required this.benchmarkResults,
    required this.settings,
    required this.optimizationTips,
    required this.regionalOptimizationTips,
    required this.auditedAt,
  });
}
