# Progressive Overload Engine (Deterministic)

## 1. Feature Description
Calculates deterministic double progression, estimated 1-Rep Max (1RM), and readiness-calibrated load prescriptions for every movement in the user's training regimen:
- **Estimated 1RM Modeling**: Computes composite maximum strength via Epley ($W \times (1 + R/30)$) and Brzycki ($W \times 36 / (37 - R)$) algorithms.
- **Double Progression Protocol**:
  - *Phase 1 (Rep Accumulation)*: Keeps load fixed until the user achieves the upper rep target (e.g. 10 reps) across all working sets with $\text{RPE} \le 9.0$.
  - *Phase 2 (Load Increment)*: Increments weight systematically ($+2.5\text{kg}$ for upper body compound, $+5.0\text{kg}$ for lower body compound, $+1.25\text{kg}$ for isolation) while resetting to the base rep target (e.g. 8 reps).
- **Readiness-Adaptive Deload Engine**: Automatically caps intensity and prescribes a $-20\%$ deload when the user's Readiness Score drops below $50\%$ to prevent Central Nervous System (CNS) burnout.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Progressive Overload Engine)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/progressive_overload_engine.dart`: Pure Dart deterministic algorithms for 1RM estimations, double progression calculations, and deload protocol triggers.
- `lib/features/workout/presentation/progressive_overload_screen.dart`: Interactive Bento UI showcasing estimated 1RM cards, double progression matrix, next target loads, and readiness simulation slider.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}.completedSets`
  - Writes: `/users/{uid}/overloadPrescriptions/{exerciseId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic mathematical progression algorithms (Epley/Brzycki formulas, Double Progression thresholds) in pure Dart.
- **AI Logic:** None in core overload progression math.

## 6. Deviations from Spec
- None. Fully adheres to Progressive Overload Engine specifications.
