# Goals Screen

## 1. Feature Description
Allows new users to select up to 3 primary health and fitness goals (fat loss, muscle building, stamina, recovery, metabolic health, longevity) with bilingual titles, descriptions, and dynamic multi-selection.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Goals Screen)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/presentation/screens/goals_screen.dart`: Interactive multi-selection goal screen built using `BentoCard`, `BilingualLabel`, glowing selection highlights, and animated radio/checkbox indicators.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod notifier storing selected goals into `OnboardingState` and triggering step progression.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: Stored locally in `OnboardingState` during the onboarding session and persisted to `/users/{uid}.selectedGoals` upon completion.
- **Security rules:** Nested under `/users/{userId}` with strict owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic selection logic, multi-select limits (1 to 3 goals), and state management in pure Dart.
- **AI Logic:** None on this screen.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Goals Screen specifications.
