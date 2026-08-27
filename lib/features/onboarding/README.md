# Onboarding Flow Order

## 1. Feature Description
Manages the structured multi-step onboarding journey for new users, orchestrating step progression, progress tracking, demographic inputs, adaptive routing (e.g. sex-specific flows), and state persistence.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, §P0-G, §P1)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/domain/onboarding_flow_step.dart`: Enum defining all 7 onboarding steps (`welcome`, `goals`, `demographics`, `doshaQuiz`, `womensHealth`, `aiDietResults`, `blueprintSelection`), linear progress calculations, and skippable step flags.
- `lib/features/onboarding/domain/onboarding_state.dart`: Immutable state model capturing answers across steps with dynamic live BMI calculation.
- `lib/features/onboarding/providers/onboarding_flow_provider.dart`: Riverpod `Notifier` managing forward/backward navigation, demographic updates, skip logic, and dynamic sex-based routing.
- `lib/features/onboarding/presentation/onboarding_container_screen.dart`: Container screen featuring animated linear progress indicators, back buttons, and step headers.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}`
  - Fields: `selectedGoals`, `weightKg`, `heightCm`, `age`, `sex`, `nutritionGoal`, `primaryDosha`, `isPcosAware`, `selectedBlueprintId`, `bmi`, `isCompleted`, `updatedAt`.
- **Security rules:** Nested under `/users/{userId}` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Step sequence order, navigation rules, live BMI calculation, and sex-specific step skipping (e.g., auto-skipping Women's Health for male profiles) are 100% deterministic in pure Dart.
- **AI Logic:** None in the navigation sequencer; individual result screens (e.g. AI Diet Plan) call their respective AI services.

## 6. Deviations from Spec
- None. Follows the exact 7-step onboarding sequence defined in Phase 1 specifications.
