# Recovery Operating System — Sleep Intelligence Layer

## 1. Feature Description
Analyzes sleep architecture (Deep, REM, Light, Awake), calculates sleep quality scores (0-100), tracks rolling 7-day sleep debt, and recommends optimal bedtime windows paired with circadian wind-down rituals.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 / Phase 3, §P2 Sleep Intelligence Layer)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/sleep_intelligence_engine.dart`: Pure Dart calculation engine for duration vs individual sleep need, deep sleep ratios ($\ge 15\%$), REM sleep ratios ($\ge 20\%$), sleep efficiency, and 7-day cumulative sleep debt.
- `lib/features/recovery_os/presentation/sleep_intelligence_card.dart`: Bento card displaying concentric `ActivityRings` (Deep/REM stages), sleep debt `GlowingMetric`, and bedtime window indicators.
- `lib/features/recovery_os/presentation/sleep_detail_screen.dart`: In-depth sleep dashboard with detailed stage timelines, efficiency statistics, and Indian wind-down protocols.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.sleep`
  - Fields: `sleepStart`, `sleepEnd`, `deepSleepMinutes`, `remSleepMinutes`, `lightSleepMinutes`, `awakeMinutes`, `latencyMinutes`, `userSleepNeedHours`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart calculations for sleep scores, stage percentages, efficiency metrics, and sleep debt calculations.
- **AI Logic:** None in the calculator; sleep metrics are passed to the Health OS Brain for morning briefing synthesis.

## 6. Deviations from Spec
- None. Fully adheres to Sleep Intelligence Layer specifications.
