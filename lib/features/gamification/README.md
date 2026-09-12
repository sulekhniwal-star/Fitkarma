# Phase 7 — Gamification, Karma Ledger & Habit Automation

## Overview
Phase 7 implements FitKarma's comprehensive **Gamification and Habit Operating System**, centering around an append-only Karma points ledger, dynamic streak multipliers, 4-pillar health adherence scoring, and demographic cohort benchmarking.

---

## Key Architecture & Components

### 1. Domain Models (`lib/features/gamification/domain/models/gamification_models.dart`)
- `KarmaActionType`: Rewardable actions (`workoutCompleted` +50, `mealLogged` +20, `stepsTargetHit` +30, `sleepTargetMet` +25, `dailyBriefingDone` +15, `sorenessLogged` +10, `fastingGoalCompleted` +40).
- `KarmaTier`: Karma Novice (0–499) -> Karma Sadhak (500–1,499) -> Karma Abhyasi (1,500–3,499) -> Karma Yogi (3,500–6,999) -> Karma Guru (7,000+).
- `HabitStreak`: Streak tracking across daily logging, workout consistency, steps, and sleep.
- `AdherenceBreakdown`: Multi-pillar consistency score (0–100) combining Workouts (35%), Nutrition (25%), Steps (20%), and Sleep (20%).
- `CohortBenchmarkResult`: Demographic peer ranking (e.g. "Top 14% in Indian Males 25–34").

### 2. Deterministic Intelligence Engines
- **`KarmaEngine`**: Calculates activity points with streak multiplier curves (+10% at 3 days, +25% at 7 days, +50% at 14+ days) and resolves user Yogi tier.
- **`AdherenceEngine`**: Computes multi-pillar adherence index and generates actionable coaching summaries in English & Hindi.
- **`CohortBenchmarkingEngine`**: Evaluates anonymous population percentiles based on age, gender, weekly tonnage, and daily steps.

### 3. Local-First Drift Persistence & Outbox Synchronization (`GamificationRepository`)
- Drift tables: `LocalKarmaPoints` (append-only ledger) and `LocalHabitStreaks`.
- Outbox sync worker queues writes to Supabase `karma_points` and `habit_streaks` tables.

### 4. Presentation Layer
- `KarmaHubScreen`: Glowing Karma level progress bar, active habit streaks grid, 4-pillar adherence rings, and demographic cohort percentile card.

---

## Verification & Testing
- Automated unit test suite: `test/gamification_test.dart` (Karma calculation, Streak bonuses, Tiers, Adherence scoring, Cohort benchmarking, Drift repository & Outbox).
- All 72 tests passing cleanly across the entire suite (`flutter test`).
- Zero analyzer warnings or errors (`flutter analyze`).
