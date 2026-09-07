# Active Workout Screen

## 1. Feature Description
Provides real-time, in-gym/at-home active workout tracking and set-by-set execution interface:
- **Live Elapsed Stopwatch & Dynamic Volume Tonnage**: Continuous timer with live tonnage accumulation calculation ($kg$).
- **Interactive Set-by-Set Logging Table**:
  - Displays set number, previous session load ghost cues ($70\text{kg} \times 10$), editable working weights and reps, and 1-tap completion checkmarks.
  - Dynamically computes progressive overload adherence.
  - Add / remove sets dynamically.
- **Automated Floating Rest Timer**: Triggers an automated 90-second countdown immediately upon set completion, with quick $+30\text{s}$ extensions and skip options.
- **Finish Workout Celebration & Summary Modal**: Computes total lifted tonnage, session duration, completed sets, and strain score ($0.0\text{–}21.0$).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Active Workout Screen)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/providers/workout_provider.dart`: StateNotifier managing set completion toggles, weight/rep adjustments, volume accumulation, and rest countdown timers.
- `lib/features/workout/presentation/active_workout_screen.dart`: Interactive Bento UI with live stopwatch, interactive set rows, floating rest countdown pill, and workout completion celebration dialog.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{workoutId}`
  - Writes: Updates `/users/{uid}/workouts/{workoutId}.completedSets` and `/users/{uid}/dailyStrain/{date}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic volume calculation ($\sum (\text{weight} \times \text{reps})$), rest timer countdown, and stopwatch synchronization in pure Dart.
- **AI Logic:** None in core active logging loop.

## 6. Deviations from Spec
- None. Fully adheres to Active Workout Screen specifications.
