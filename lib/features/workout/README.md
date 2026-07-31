# Workout Feature (`lib/features/workout/`)

## Purpose
Manages active workout execution, set/rep/weight logging, rest timers, MediaPipe joint angle calculations, and progressive overload calculations.

## Subdirectories
- **`models/`**: `WorkoutExercise`, `WorkoutSet`, and `PoseAngleResult` data models.
- **`providers/`**: Riverpod state management for active workout tracking and rest timers.
- **`screens/`**: Interactive `ActiveWorkoutScreen` for logging sets and tracking rest intervals.
