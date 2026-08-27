# Recovery Operating System — Recovery Capacity & Strain System

## 1. Feature Description
Calculates daily cardiovascular, neuromuscular, and environmental physical exertion on a 0.0 to 21.0 logarithmic strain scale and recommends optimal target strain windows dynamically paired with body readiness scores.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 / Phase 3, §P2 & §P3 Recovery Capacity & Strain System)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/strain_system_engine.dart`: Pure Dart calculation engine for logarithmic step strain ($10\text{k steps} \approx 7.0$), workout load intensity factor, heat index cardiac stress, and optimal target strain window boundaries ($0.0-21.0$).
- `lib/features/recovery_os/presentation/strain_gauge_card.dart`: Glassmorphism bento card with animated `ActivityRings`, exertion source breakdown (steps/workout/heat), target strain comparisons, and overreaching alerts.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.strain`
  - Fields: `currentStrain`, `targetStrainMin`, `targetStrainMax`, `category`, `stepsContribution`, `workoutContribution`, `heatContribution`, `isOverreaching`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic logarithmic strain formulas, thermal penalties, and readiness-adjusted target windows in pure Dart.
- **AI Logic:** None in the calculation engine; strain parameters inform downstream AI coaching summaries.

## 6. Deviations from Spec
- None. Fully adheres to Recovery Capacity & Strain System specifications.
