import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/daily_intelligence_package.dart';

/// §P4-A Dashboard Orchestration State
///
/// Load order (DIP-only, zero AI calls on open):
///   1. Load DIP from Drift (instant — already generated at 6am)
///   2. Load live metrics from Drift (steps, calories, water)
///   3. Render — zero AI calls
enum DashboardLoadPhase { idle, loadingDip, loadingLive, ready, error }

class DashboardState {
  final DashboardLoadPhase phase;
  final DailyIntelligencePackage? dip;
  final DashboardLiveMetrics liveMetrics;
  final String? errorMessage;

  const DashboardState({
    this.phase = DashboardLoadPhase.idle,
    this.dip,
    this.liveMetrics = const DashboardLiveMetrics(),
    this.errorMessage,
  });

  bool get isReady => phase == DashboardLoadPhase.ready;
  bool get isLoading =>
      phase == DashboardLoadPhase.loadingDip ||
      phase == DashboardLoadPhase.loadingLive;

  DashboardState copyWith({
    DashboardLoadPhase? phase,
    DailyIntelligencePackage? dip,
    DashboardLiveMetrics? liveMetrics,
    String? errorMessage,
  }) {
    return DashboardState(
      phase: phase ?? this.phase,
      dip: dip ?? this.dip,
      liveMetrics: liveMetrics ?? this.liveMetrics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// §P4-A DashboardNotifier — DIP-only orchestration, zero AI calls
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState()) {
    _orchestrate();
  }

  /// §P4-A Orchestration:
  /// Step 1 → Load DIP (pre-built at 6am, instant Drift read)
  /// Step 2 → Load live metrics (steps, calories, water from Drift)
  /// Step 3 → Render — zero AI calls
  Future<void> _orchestrate() async {
    state = state.copyWith(phase: DashboardLoadPhase.loadingDip);

    try {
      // Step 1: Load DIP from Drift (mocked — instant in production)
      await Future.delayed(const Duration(milliseconds: 80));
      final dip = _loadDipFromDrift();

      state = state.copyWith(
        phase: DashboardLoadPhase.loadingLive,
        dip: dip,
      );

      // Step 2: Load live metrics from Drift
      await Future.delayed(const Duration(milliseconds: 60));
      final live = _loadLiveMetricsFromDrift();

      state = state.copyWith(
        phase: DashboardLoadPhase.ready,
        liveMetrics: live,
      );
    } catch (e) {
      state = state.copyWith(
        phase: DashboardLoadPhase.error,
        errorMessage: 'Failed to load dashboard: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() => _orchestrate();

  // ── Drift stubs (replaced by real Drift queries in production) ─────────────

  DailyIntelligencePackage _loadDipFromDrift() {
    return DailyIntelligencePackage(
      userId: 'user_current',
      date: DateTime.now(),
      readinessScore: 82,
      healthScore: 74,
      readinessTier: ReadinessTier.enhanced,
      primaryFocus: 'Active Recovery + Protein',
      primaryInsight:
          'Your sleep debt is −45m. Prioritise 8h tonight to fully repair after yesterday\'s training load.',
      insightSource: '7-day data · Sleep',
      dailyMissions: [
        'Complete 30-min light cardio',
        'Hit 120g protein target',
        'Sleep by 10:30 PM',
      ],
    );
  }

  DashboardLiveMetrics _loadLiveMetricsFromDrift() {
    return const DashboardLiveMetrics(
      steps: 8420,
      stepGoal: 10000,
      caloriesBurned: 1240,
      calorieGoal: 1800,
      activeMinutes: 52,
      activeMinuteGoal: 60,
      waterLitres: 1.8,
      waterGoal: 3.0,
      sleepHours: 6.33,
      restingHrBpm: 68,
      streakDays: 12,
      karmaPoints: 4280,
      stepsVsYesterdayPct: 12.0,
    );
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
        (_) => DashboardNotifier());
