# Training Operating System — Adherence & Athletic Profiling

## 1. Feature Description
Evaluates the user's athletic persona, training adherence consistency, and multi-vector performance capacity within FitKarma's Training OS (Phase 6):
- **Athletic Persona Classification**:
  - *Akhara Pehlwan / Functional Powerhouse*: High bodyweight calisthenic endurance (Dand, Baithak), rotational core strength (Gada/Mudgar), and joint durability.
  - *Hypertrophy Architect*: High weekly volume density, strict tempo control, and progressive overload accumulation.
  - *Compound Strength & Neural Power*: High 1RM force output, heavy compound mastery, and high CNS efficiency.
  - *Metabolic Conditioning Warrior*: High work capacity, short rest density, and cardiovascular/muscular synergy.
- **5-Vector Athletic Radar Matrix**:
  1. *Max Strength & 1RM*
  2. *Hypertrophic Work Capacity*
  3. *Rotational & Multi-Planar Mobility*
  4. *30-Day Training Adherence*
  5. *Neuromuscular Recovery Speed*
- **Training Adherence & Streak Consistency**: Calculates rolling 30-day workout adherence rate ($\%$) and active streak resilience.
- **Time-Crunched Anti-Quit Protocol**: 20-minute bodyweight express alternative (Desi Dand, Baithak, Mudgar flow) to prevent skipping workouts on busy days.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Training OS Adherence & Athletic Profiling)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/athletic_profiling_engine.dart`: Pure Dart deterministic calculator for athletic personas, 5-vector athletic radar, 30-day adherence consistency scoring, and compassionate micro-adjustments.
- `lib/features/workout/presentation/athletic_profiling_screen.dart`: Interactive Bento UI with athletic persona hero badge, 5-vector radar bars, active streak counters, and time-crunched express protocols.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}`
  - Writes: `/users/{uid}/athleticProfile/current`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic athletic vector mathematics, persona categorization thresholds, and adherence algorithms in pure Dart.
- **AI Logic:** None in core profiling engine.

## 6. Deviations from Spec
- None. Fully adheres to Training Operating System — Adherence & Athletic Profiling specifications.
