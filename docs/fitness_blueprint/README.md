# Dynamic Fitness Blueprint Generator

## 1. Feature Description
Deterministically generates comprehensive 4-to-12-week periodized training blueprints customized to the user's primary fitness goal, weekly availability, equipment access, and athletic experience:
- **Goal-Calibrated Periodization**:
  - *Muscle Hypertrophy*: 8–12 rep range, 90s rest, 12–18 weekly sets per muscle.
  - *Fat Loss & Conditioning*: 12–16 rep range, 60s rest, high metabolic density.
  - *Traditional Akhara Power*: 15–25 rep high-volume bodyweight calisthenics (Desi Dand, Baithak, Mudgar/Gada rotational swings).
  - *Strength & Joint Longevity*: 5–8 rep heavy compound focus with 120s rest periods.
- **Flexible Weekly Frequencies (3–6 Days)**:
  - 3-Day: Full Body (Sessions A, B, C).
  - 4-Day: Upper / Lower Power & Hypertrophy.
  - 5-Day: Push / Pull / Legs / Upper / Lower.
  - 6-Day: Push / Pull / Legs $\times 2$.
- **Equipment Optimization**:
  - Full Commercial Gym (Barbells, Cables, Dumbbells).
  - Home Gym (Dumbbells, Bench, Pull-up Bar).
  - Akhara / Indian Calisthenics (Dand, Baithak, Mudgar / Karlakattai).
- **Mesocycle Periodization Framework**: 4-week structure with 3 weeks of progressive overload volume accumulation + 1 week active resensitization deload.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Dynamic Fitness Blueprint Generator)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/fitness_blueprint_engine.dart`: Pure Dart deterministic blueprint synthesis engine for multi-frequency splits, volume allocations, and mesocycle models.
- `lib/features/workout/presentation/fitness_blueprint_screen.dart`: Interactive Bento UI with goal chips, frequency sliders, equipment dropdowns, weekly volume progress bars, and day-by-day session breakdowns.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/userProfile.workoutPreferences`
  - Writes: `/users/{uid}/activeBlueprint/current`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic periodization math, set/rep mapping, and muscle group volume calculations in pure Dart.
- **AI Logic:** None in core blueprint generation engine.

## 6. Deviations from Spec
- None. Fully adheres to Dynamic Fitness Blueprint Generator specifications.
