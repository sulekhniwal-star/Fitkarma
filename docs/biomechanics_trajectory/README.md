# Training Operating System — Biomechanics & Trajectory Projections

## 1. Feature Description
Forecasts future strength trajectories (3, 6, and 12-month projections) and calculates personalized anthropometric joint calibrations for FitKarma's Training OS (Phase 6):
- **Logarithmic Strength Trajectory Engine**: Models physiological strength adaptation diminishing returns curve for compound movements (Bench Press, Squats, Romanian Deadlifts, Desi Dand) factoring in user adherence rates.
- **Anthropometric Limb Lever Advisor**:
  - *Long Femurs / Short Torso*: Recommends wider stance ($1.2\times$ shoulder width) or heel elevation blocks to optimize knee/hip torque.
  - *Long Torso / Short Femurs*: Narrow-to-moderate high-bar squat positioning with upright spinal mechanics.
  - *Long Wingspan*: Optimizes deadlift starting hip heights and lat engaging cues.
- **Hypertrophic Lean Tissue Accrual Projections (Casey Butt & Alan Aragon Model)**: Calculates potential 6-month lean muscle gains based on training consistency and progressive overload volume.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Training OS Biomechanics & Trajectory Projections)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/biomechanics_trajectory_engine.dart`: Pure Dart mathematical engine for logarithmic 1RM milestones, anthropometric lever calibrations, and net lean tissue growth algorithms.
- `lib/features/workout/presentation/biomechanics_trajectory_screen.dart`: Interactive Bento UI with 6-month forecast hero cards, anthropometric lever selectors, and milestone progress pills.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}`
  - Writes: `/users/{uid}/strengthTrajectories/current`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic logarithmic strength curve formulas and anthropometric biomechanical mappings in pure Dart.
- **AI Logic:** None in core trajectory engine.

## 6. Deviations from Spec
- None. Fully adheres to Training Operating System — Biomechanics & Trajectory Projections specifications.
