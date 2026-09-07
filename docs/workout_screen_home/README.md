# Workout Screen Home

## 1. Feature Description
Serves as the primary operational hub for FitKarma's Workout & Movement Intelligence Platform (Phase 6):
- **Hero Scheduled Session Bento Card**: Displays today's planned training session (e.g. Push Hypertrophy, Pull Power, Legs & Akhara Conditioning), estimated duration, planned exercise count, total working sets, and real-time Readiness Score integration (e.g. "Readiness 87% • Target RPE 8.0–9.5").
- **7-Day Periodization Strip**: Interactive weekly split overview tracking adherence, completed sessions, and rest/yoga days.
- **Weekly Tonnage & Progressive Overload Tracker**: Computes cumulative weekly volume ($kg$) and progressive overload percentage ($\Delta\%$ vs. previous week).
- **Planned Exercise Preview**: Outlines target set/rep ranges and AI-suggested working weights before starting the session.
- **Exercise & Akhara Movement Library**: Built-in searchable library featuring global standard compound lifts (Barbell Bench, Back Squat, Romanian Deadlift) alongside traditional Indian calisthenics (Desi Dand, Baithak, Mudgar / Karlakattai swings).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 6 — Workout System, §P6 Workout Screen Home)
- **Phase:** Phase 6 — Workout System

## 3. Key Files & Responsibilities
- `lib/features/workout/domain/workout_models.dart`: Domain entities for `Exercise`, `WorkoutSet`, `PlannedExercise`, `WorkoutSession`, and `MuscleGroup`.
- `lib/features/workout/data/exercise_database.dart`: High-quality movement database with biomechanical execution cues and traditional Indian Akhara patterns.
- `lib/features/workout/providers/workout_provider.dart`: Riverpod state management for active session triggers and weekly schedule progress.
- `lib/features/workout/presentation/workout_screen_home.dart`: Interactive Bento UI with scheduled session hero, weekly periodization strip, progressive volume tracking, and exercise library browser.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/workouts/{date}`
  - Writes: `/users/{uid}/workouts/{workoutId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic volume tonnage aggregation, rep/set tracking, and periodization scheduling in pure Dart.
- **AI Logic:** None in core workout home screen.

## 6. Deviations from Spec
- None. Fully adheres to Workout Screen Home specifications.
