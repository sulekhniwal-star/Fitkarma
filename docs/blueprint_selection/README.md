# Program Blueprint Selection Screen

## 1. Feature Description
Allows new users to choose their foundational multi-week workout program blueprint (e.g. Desi Iron 4-Day Gym Split, Ghar Par Calisthenics, Athletic Hybrid PPL, Desk Worker Posture), matching their primary goals, available equipment, and training schedule.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Program Blueprint Selection Screen, §P6-D)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/domain/workout_blueprint.dart`: Pure Dart catalog model defining blueprint metadata (days per week, duration weeks, location, experience levels, equipment required, focus muscle groups).
- `lib/features/onboarding/presentation/screens/program_blueprint_selection_screen.dart`: Interactive blueprint picker screen with "Recommended for You" goal badges, equipment chips, and the final "Launch Health OS" onboarding completion trigger.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod notifier storing selected blueprint and finalizing onboarding.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: Computed in `OnboardingState` and saved to `/users/{uid}.selectedBlueprintId` and `/users/{uid}.isCompleted` upon onboarding conclusion.
- **Security rules:** Nested under `/users/{userId}` with strict owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic blueprint catalog rules, goal matchmaking heuristics, and selection state management.
- **AI Logic:** None in the selection screen.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Program Blueprint Selection specifications.
