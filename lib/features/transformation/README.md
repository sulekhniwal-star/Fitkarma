# Transformation Journey (`lib/features/transformation`)

## Overview
The **Transformation Journey** feature tracks holistic physical and mental evolution over weeks, months, and years. It goes beyond simple scale weight to celebrate non-scale victories, habit identity maturation, and body composition changes.

---

## Key Engines & Components

### 1. `TransformationJourneyEngine`
- **Location**: `lib/features/transformation/domain/services/transformation_journey_engine.dart`
- **Responsibilities**:
  - Computes exact comparative biometrics between baseline (first check-in) and latest check-in (weight delta, body fat delta, waist/hip/chest deltas, days span).
  - Automates milestone unlocks based on weight loss thresholds (e.g. 5kg, 10kg), body fat drops, workout milestones (10, 25, 50 sessions), and habit consistency streaks (7d, 21d, 60d, 90d).

### 2. `HabitIdentityEngine`
- **Location**: `lib/features/transformation/domain/services/habit_identity_engine.dart`
- **5-Stage Identity Progression**:
  1. **Stage 1 (0–6 days)**: *Curious Explorer* — Building initial awareness.
  2. **Stage 2 (7–29 days)**: *Momentum Builder* — Action taking root as routine.
  3. **Stage 3 (30–59 days)**: *Consistent Warrior* — Strong internal habit discipline.
  4. **Stage 4 (60–89 days)**: *Identity Transformer* — Self-conception shifting to "an athlete".
  5. **Stage 5 (90+ days)**: *Unstoppable Achiever* — Lifetime fitness lifestyle locked in.

### 3. `TransformationRepository`
- **Location**: `lib/features/transformation/data/transformation_repository.dart`
- **Drift Tables**:
  - `LocalBodyTransformationLogs`: Check-ins with weight, body fat %, waist/hip/chest measurements, photos, and notes.
  - `LocalTransformationMilestones`: Unlocked milestone badges with metric snapshots.
- **Outbox Sync**: Queues offline mutations to Supabase `body_transformation_logs` and `transformation_milestones`.

### 4. `TransformationTimelineScreen`
- **Location**: `lib/features/transformation/presentation/screens/transformation_timeline_screen.dart`
- **Features**:
  - Identity status card with stage affirmations.
  - Delta Bento grid (weight lost vs goal %, waist circumference reduction).
  - Milestone timeline list with unlocked achievements.
  - Check-in history stream and bottom-sheet check-in logger.

---

## Verification
- Unit Tests: `test/transformation_test.dart`
- Supabase Migration: `supabase/migrations/20260912000008_phase8_transformation_schema.sql`
