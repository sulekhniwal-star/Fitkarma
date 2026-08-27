# Readiness Engine (Three-Tier Confidence Model)

## 1. Feature Description
Calculates the user's daily physiological readiness score (0-100) and readiness zone (`optimal`, `moderate`, `recovery`, `rest`) through a three-tier confidence model that adapts seamlessly across smart wearable data, basic tracking, and subjective check-ins.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 2 — Daily Mission + Readiness, §P2 Readiness Engine)
- **Phase:** Phase 2 — Daily Mission + Readiness

## 3. Key Files & Responsibilities
- `lib/features/readiness_engine/domain/readiness_engine.dart`: Pure Dart deterministic scoring engine implementing:
  - **Tier 1 (Wearables)**: 35% HRV deviation + 25% sleep architecture + 20% resting HR + 20% recovery soreness.
  - **Tier 2 (Basic Tracking)**: 45% sleep duration + 30% muscle soreness + 25% previous day step load.
  - **Tier 3 (Subjective)**: 40% sleep rating + 35% somatic soreness + 25% energy rating.
- `lib/features/readiness_engine/data/readiness_repository.dart`: Firestore repository with offline caching.
- `lib/features/readiness_engine/providers/readiness_provider.dart`: Riverpod state provider managing daily readiness states.
- `lib/features/readiness_engine/presentation/readiness_gauge_card.dart`: Glassmorphism bento card displaying concentric `ActivityRings`, `GlowingMetric`, confidence tier badges, and readiness zone recommendations.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/dailyLogs/{date}.readiness` and `/users/{uid}/healthOS/{date}`
  - Fields: `score`, `zone`, `tier`, `hrvScoreContribution`, `sleepScoreContribution`, `recoveryContribution`, `strainContribution`, `recommendation`, `safetyAlerts`, `evaluatedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart mathematical weighting across all 3 confidence tiers, zone thresholding, and safety bounds.
- **AI Logic:** None in the calculation engine; the Health OS Brain incorporates readiness scores to synthesize conversational morning briefings.

## 6. Deviations from Spec
- None. Fully adheres to Phase 2 Readiness Engine specifications.
