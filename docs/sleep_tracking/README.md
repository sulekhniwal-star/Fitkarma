# Sleep Screen (Stage Metrics, Debt Modeling)

## 1. Feature Description
Provides a comprehensive sleep tracking dashboard displaying sleep architecture (Deep, REM, Light, Awake), rolling 7-day sleep debt accumulation, optimal circadian bedtime windows, and actionable wind-down rituals.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Sleep Screen)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/sleep_intelligence_engine.dart`: Pure Dart mathematical model calculating sleep efficiency, stage percentages, sleep debt, and circadian bedtime windows.
- `lib/features/health_tracking/presentation/sleep_screen.dart`: Primary health tracking sleep screen with stage breakdowns, glowing debt gauges, and wind-down guidance.
- `lib/features/recovery_os/presentation/sleep_intelligence_card.dart`: Hero sleep bento card reusable across dashboard and briefing views.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.sleep`
  - Fields: `bedTime`, `wakeTime`, `deepSleepMinutes`, `remSleepMinutes`, `lightSleepMinutes`, `awakeMinutes`, `sleepDebtMinutes`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic sleep stage ratios, sleep debt accumulation formulas, and optimal bedtime computations.
- **AI Logic:** None in core sleep calculation.

## 6. Deviations from Spec
- None. Fully adheres to Sleep Tracking specifications.
