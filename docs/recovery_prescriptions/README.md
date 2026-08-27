# Recovery Operating System — Recovery Behaviors & Prescriptions

## 1. Feature Description
Tracks and prescribes evidence-based lifestyle recovery habits (Pranayama, Late Caffeine Cutoff, Haldi Doodh/Ashwagandha, Cold Showers, Screen-Free Buffers, Post-Meal Walks), analyzing their physiological impact on HRV and sleep quality.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 / Phase 3, §P2 & §P3 Recovery Behaviors & Prescriptions)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/recovery_os/domain/recovery_behavior_engine.dart`: Pure Dart calculation engine defining trackable recovery behaviors, estimated HRV benefits (+3.0 to +6.5 ms), and daily priority prescription generation based on strain and soreness.
- `lib/features/recovery_os/presentation/recovery_prescriptions_screen.dart`: Interactive habit dashboard featuring daily prioritized prescriptions, estimated HRV gain indicators, and habit toggle switches.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.recoveryBehaviors`
  - Fields: `completedBehaviorIds`, `loggedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart rules for prescription prioritization and impact attribution.
- **AI Logic:** None in the core calculator; completed behaviors enrich the morning Health OS Brain briefing context.

## 6. Deviations from Spec
- None. Fully adheres to Recovery Behaviors & Prescriptions specifications.
