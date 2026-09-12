# Phase 6 — Workout System & Training Operating System

## Overview
Phase 6 implements FitKarma's comprehensive **Training Operating System**, featuring progressive overload automation (RPE-driven load increases and double progression), movement biomechanics form cues, an offline exercise database with Desi and compound movements, and live set tracking.

---

## Key Architecture & Components

### 1. Domain Models (`lib/features/workout/domain/models/workout_models.dart`)
- `Exercise`: Movement pattern (Push, Pull, Squat, Hinge, Lunge, Carry, Core), target muscle groups, equipment, target rep/set ranges, and bilingual form cues.
- `WorkoutSet`: Set number, weight in kg, reps, RPE (Rating of Perceived Exertion), and completion status.
- `OverloadRecommendation`: Deterministic load suggestions (+2.5kg / +5.0kg / +1 rep / micro-deload).
- `FormCheckResult`: Joint angle posture validation result.

### 2. Deterministic Intelligence Engines
- **`ExerciseDatabase`**: Pre-seeded catalog of 10+ compound, isolation, and Desi exercises (Barbell Back Squat, Conventional Deadlift, Romanian Deadlift, Bench Press, Overhead Press, Bent-over Row, Pull-ups, Desi Dand/Hindu Pushups, Desi Baithak/Hindu Squats, Surya Namaskar).
- **`ProgressiveOverloadEngine`**:
  - Upper rep range achieved at RPE <= 8.5 -> Increases weight by +2.5kg (upper body) or +5.0kg (squat/deadlift).
  - Lower rep range achieved -> Suggests adding +1 rep before increasing weight.
  - Consecutive failures (2+ sessions) -> Triggers micro-deload (-10% load) to reset the nervous system.
- **`MovementIntelligenceEngine`**: Evaluates joint angle ranges for squats (hip-knee angle, upright torso angle, grounded heels) and bench pressing (elbow flare angle < 75° to protect rotator cuff).

### 3. Local-First Drift Persistence & Outbox Synchronization (`WorkoutRepository`)
- Drift tables: `LocalWorkoutSessions` (session volume, duration, avg RPE) and `LocalWorkoutSets` (individual sets).
- Outbox sync worker queues writes to Supabase `workout_sessions` and `workout_sets` tables.
- Derives progressive overload suggestions from past exercise history.

### 4. Presentation Layer
- `WorkoutHomeScreen`: Weekly training tonnage, streak tracker, today's workout split, and start session CTA.
- `ActiveWorkoutScreen`: Live set logger, rest timer indicator, and progressive overload target cues.
- `ExerciseLibraryScreen`: Muscle group filter chips, movement mechanics, and form cues in English & Hindi.

---

## Verification & Testing
- Automated unit test suite: `test/workout_test.dart` (Exercise database, Progressive overload logic, Movement intelligence, Drift persistence and Outbox queue).
- All 65 tests passing cleanly across the entire suite (`flutter test`).
- Zero analyzer warnings or errors (`flutter analyze`).
