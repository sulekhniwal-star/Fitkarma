# AI Diet Plan Results Screen

## 1. Feature Description
Presents the user's personalized nutrition blueprint, calculating daily calorie targets, macro distribution (protein/carbs/fats), 4-phase Indian meal timing splits, and AI coaching insights.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, AI Diet Plan Results Screen)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/presentation/screens/ai_diet_plan_results_screen.dart`: Visual results screen featuring animated `ActivityRings` for macro ratios, `GlowingMetric` hero calories, Indian meal timing breakdown cards, and AI coaching insights.
- `lib/features/metabolism/domain/adaptive_metabolism_engine.dart`: Pure Dart mathematical engine computing tailored calorie/protein targets.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Connected Riverpod state provider.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: Computed in-memory during onboarding; persisted to `/users/{uid}` and `/users/{uid}/healthOS/{date}` upon onboarding completion.
- **Security rules:** Nested under `/users/{userId}` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Daily calorie deficit/surplus math, macronutrient gram calculations, and percentage distribution are 100% deterministic in pure Dart.
- **AI Logic:** Used in the coaching narrative card (with local deterministic fallback).

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 AI Diet Plan Results specifications.
