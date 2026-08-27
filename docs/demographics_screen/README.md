# Demographics Screen (Live BMI + Adaptive Targets)

## 1. Feature Description
Captures core user biometric parameters (biological sex, age, height, weight, nutrition goal) while computing Asian-Indian BMI classifications and real-time calibrated energy expenditure targets in pure Dart.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Demographics Screen)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/presentation/screens/demographics_screen.dart`: Interactive biometric onboarding screen featuring real-time Asian-Indian BMI classification ($<18.5$ underweight, $18.5-22.9$ normal, $23-24.9$ overweight, $\ge 25$ obese), weight/height sliders, age steppers, and live calibrated target previews.
- `lib/features/metabolism/domain/adaptive_metabolism_engine.dart`: Pure Dart mathematical engine providing instant BMR, TDEE, and protein projections as sliders move.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod notifier updating `OnboardingState` and advancing to subsequent steps.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: Stored in `OnboardingState` during onboarding, persisted to `/users/{uid}` on onboarding completion (`weightKg`, `heightCm`, `age`, `sex`, `nutritionGoal`, `bmi`).
- **Security rules:** Enforced under `/users/{userId}` with strict owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart calculations for BMI, Asian-Indian cutoff classifications, Mifflin-St Jeor BMR, and macronutrient targets.
- **AI Logic:** None on this screen.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Demographics Screen specifications.
