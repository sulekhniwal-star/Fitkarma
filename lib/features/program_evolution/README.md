# Program Evolution Engine

## 1. Feature Description
Dynamically evaluates a user's multi-week training and nutrition blueprint, deciding when to increase volume (+5%), maintain steady progression, trigger active deload recovery weeks, or recalibrate calorie targets based on adherence, plateau detection, and rolling readiness trends.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-G Phase 0, Vision Statement, §P6-D)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/features/program_evolution/domain/program_evolution_engine.dart`: Pure Dart deterministic decision engine evaluating adherence rates, fatigue markers, and weight plateaus to output evolution actions (`progress`, `maintain`, `deload`, `recalibrate`).
- `lib/features/program_evolution/data/program_evolution_repository.dart`: Firestore repository with offline caching and seamless local calculation fallback.
- `lib/features/program_evolution/providers/program_evolution_provider.dart`: Riverpod state provider managing the user's latest program evolution status.
- `lib/features/program_evolution/presentation/program_evolution_card.dart`: Glassmorphism bento card displaying cycle adherence, volume adjustments, and evolution rationale.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/programEvolution/latest`
  - Fields: `action`, `volumeMultiplier`, `recommendedCalorieDelta`, `adherenceRate`, `averageReadiness`, `reasoning`, `evaluatedAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Progression triggers, deload fatigue detection thresholds (3+ consecutive low readiness days or avg readiness < 45), 14-day plateau adjustments, and volume multiplier math are 100% deterministic in pure Dart.
- **AI Logic:** Used in the Health OS Brain cycle for optional conversational coaching elaboration.
- **Split location:** The pure Dart engine computes the evolution action and parameters with zero LLM dependence for instantaneous offline evaluation.

## 6. Deviations from Spec
- None. Fully adheres to Phase 0 Foundation and §P6 specifications.
