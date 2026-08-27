# Recovery Operating System — Recovery Age & Forecasting

## 1. Feature Description
Calculates the user's biological recovery age by comparing rolling 14-day HRV, resting heart rate, and sleep architecture to chronological age baselines, and models predictive 48-hour readiness trajectories.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 / Phase 3, §P2 & §P3 Recovery Age & Forecasting)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/recovery_forecasting_engine.dart`: Pure Dart calculation engine for biological age delta based on autonomic metrics, deep sleep ratios, and 48-hour supercompensation readiness wave forecasting.
- `lib/features/recovery_os/presentation/recovery_forecasting_card.dart`: Glassmorphism bento card displaying Biological vs. Chronological age metrics, longevity insights, and upcoming PR training windows.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.recoveryForecasting`
  - Fields: `biologicalRecoveryAge`, `ageDelta`, `forecasts`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic mathematical regression models for biological age shifts and supercompensation forecasting.
- **AI Logic:** None in the core calculator; recovery age metrics feed into downstream AI coaching synthesis.

## 6. Deviations from Spec
- None. Fully adheres to Recovery Age & Forecasting specifications.
