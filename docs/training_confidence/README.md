# Training Operating System — Confidence Indices

## 1. Feature Description
Calculates real-time statistical reliability, mechanical safety, and physiological recovery alignment for strength & conditioning logs across 4 core indices:
- **Form & Mechanical Integrity Index (30% weight)**: Detects near-failure sets (RPE $\ge 9.5$) and evaluates whether motor control and bar path stability were sustained.
- **Progression Confidence Index (30% weight)**: Quantifies the probability that prescribed progressive overload jumps (e.g. $+2.5\text{kg}$ load) will be completed based on target rep fulfillment rates.
- **CNS & Recovery Alignment Index (25% weight)**: Cross-references session training volume and RPE against the user's daily Readiness score and autonomic HRV recovery state to protect the Central Nervous System (CNS).
- **Data & Measurement Precision Index (15% weight)**: Evaluates real-time stopwatch tracking vs. retroactive end-of-day batch logging (which introduces ~35% RPE memory bias).
- **Training Confidence Shield**: Classifies the training session into tiers (*Shielded / High Precision*, *Calibrated*, *Provisional*, *Uncertain*) and auto-applies recovery adjustments.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Training OS Confidence Indices)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/training_confidence_engine.dart`: Pure Dart mathematical engine for computing the 4 training indices, composite confidence score, and safeguard calibrations.
- `lib/features/workout/presentation/training_confidence_screen.dart`: Interactive Bento UI with Training Confidence Shield status, real-time logging toggles, 4 pillar progress bars, and active safeguard directives.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}`
  - Writes: `/users/{uid}/workoutConfidence/{workoutId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic statistical confidence algorithms, CNS alignment ratios, and weighted index math in pure Dart.
- **AI Logic:** None in core confidence indices engine.

## 6. Deviations from Spec
- None. Fully adheres to Training Operating System — Confidence Indices specifications.
