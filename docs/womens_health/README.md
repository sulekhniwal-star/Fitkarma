# Women's Advanced Health Layer

## 1. Feature Description
Synchronizes training intensity, macronutrient distribution, and metabolic shifts with the female hormonal cycle across 4 phases (Menstrual, Follicular, Ovulatory, Luteal) and specialized life stages (PCOS/PCOD Calibrator, Fertility Window, Menopause Care).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 1 — Onboarding, Women's Advanced Health Layer)
- **Phase:** Phase 1 — Onboarding

## 3. Key Files & Responsibilities
- `lib/features/onboarding/domain/womens_health_engine.dart`: Pure Dart calculation engine that determines cycle phase, training load multipliers ($0.75\times$ to $1.15\times$), luteal metabolic calorie shifts (+150 kcal), PCOS low-GI/insulin-sensitizing rules, and menopause bone density protocols.
- `lib/features/onboarding/data/womens_health_repository.dart`: Firestore repository with offline caching.
- `lib/features/onboarding/providers/womens_health_provider.dart`: Riverpod state provider.
- `lib/features/onboarding/presentation/screens/womens_health_screen.dart`: Interactive phase tracking and life stage setup screen with animated `ActivityRings`, cycle sliders, and nutrition/training guidance.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/womensHealth/profile`
  - Fields: `cycleLengthDays`, `periodLengthDays`, `currentCycleDay`, `currentPhase`, `lifeStageMode`, `isPcosDiagnosed`, `calorieOffset`, `trainingLoadMultiplier`, `trainingRecommendation`, `nutritionRecommendation`, `wellnessTips`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic pure Dart calculations for cycle phase boundaries, training intensity multipliers, calorie offsets, and PCOS nutritional adaptations.
- **AI Logic:** None in the core calculator; the Health OS Brain incorporates hormonal phase context into daily morning briefings.

## 6. Deviations from Spec
- None. Fully adheres to Phase 1 Women's Advanced Health Layer specifications.
