# Dosha Quiz (Scoring Engine)

## 1. Feature Description
Provides an Ayurvedic constitutional assessment (Vata, Pitta, Kapha), evaluating body frame, digestive agni, energy rhythm, sleep patterns, and climate tolerances to generate personalized nutrition and workout adaptations.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Dosha Quiz)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/domain/dosha_scoring_engine.dart`: Pure Dart deterministic scoring engine with 6 bilingual Ayurvedic questions, percentage distribution calculation, and Vata/Pitta/Kapha nutrition & workout adaptation logic.
- `lib/features/onboarding/presentation/screens/dosha_quiz_screen.dart`: Interactive question step-through screen with `ActivityRings` constitutional breakdown, primary/secondary dosha badges, and retake controls.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod state notifier.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: Computed in `OnboardingState` and saved to `/users/{uid}.primaryDosha` upon onboarding completion.
- **Security rules:** Nested under `/users/{userId}` with strict owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% pure Dart mathematical weighting and ranking of constitutional doshas without AI dependencies.
- **AI Logic:** None in the quiz engine; dosha outputs inform downstream meal and coaching prompts.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Dosha Quiz specifications.
