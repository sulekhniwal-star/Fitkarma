class TraceMetric {
  final String traceName;
  final int durationMs;
  final DateTime timestamp;
  final bool isWithinBudget;

  const TraceMetric({
    required this.traceName,
    required this.durationMs,
    required this.timestamp,
    required this.isWithinBudget,
  });
}

class PerformanceMonitor {
  final Map<String, Stopwatch> _activeTraces = {};
  final List<TraceMetric> _completedTraces = [];

  // Budgets defined per TRD / Production Checklist
  static const int startupBudgetMs = 1200; // < 1.2s cold start
  static const int frameBudgetMs = 16; // 60fps frame render threshold (16.6ms)
  static const int queryBudgetMs = 100; // < 100ms local SQLite query

  void startTrace(String traceName) {
    _activeTraces[traceName] = Stopwatch()..start();
  }

  TraceMetric? stopTrace(String traceName) {
    final watch = _activeTraces.remove(traceName);
    if (watch == null) return null;

    watch.stop();
    final durationMs = watch.elapsedMilliseconds;

    int budget = queryBudgetMs;
    if (traceName.contains('startup')) {
      budget = startupBudgetMs;
    } else if (traceName.contains('frame')) {
      budget = frameBudgetMs;
    }

    final metric = TraceMetric(
      traceName: traceName,
      durationMs: durationMs,
      timestamp: DateTime.now(),
      isWithinBudget: durationMs <= budget,
    );

    _completedTraces.add(metric);
    if (_completedTraces.length > 100) {
      _completedTraces.removeAt(0);
    }

    return metric;
  }

  List<TraceMetric> getCompletedTraces() => List.unmodifiable(_completedTraces);

  /// Computes average query latency across all recorded database queries
  double getAverageQueryLatencyMs() {
    final queries = _completedTraces.where((t) => t.traceName.startsWith('db_'));
    if (queries.isEmpty) return 0.0;
    final total = queries.fold<int>(0, (sum, q) => sum + q.durationMs);
    return total / queries.length;
  }

  /// Determines if app performance is currently healthy
  bool isPerformanceHealthy() {
    if (_completedTraces.isEmpty) return true;
    final slowTraces = _completedTraces.where((t) => !t.isWithinBudget);
    // Healthy if >90% of traces are within budget
    return (slowTraces.length / _completedTraces.length) < 0.10;
  }
}
